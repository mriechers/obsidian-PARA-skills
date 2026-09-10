#!/usr/bin/env bash
# tests/validate.sh — L1 static validation for obsidian-PARA-skills.
# Run from anywhere; exits non-zero on any failure.
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

FAIL=0
red=$'\033[31m'; grn=$'\033[32m'; ylw=$'\033[33m'; bold=$'\033[1m'; rst=$'\033[0m'
pass() { printf "  ${grn}✓${rst} %s\n" "$1"; }
fail() { printf "  ${red}✗${rst} %s\n" "$1"; FAIL=1; }
skip() { printf "  ${ylw}–${rst} %s\n" "$1"; }
section() { printf "\n${bold}%s${rst}\n" "$1"; }

# New (para-*) skill dirs and the five upstream dirs.
PARA_SKILLS=(skills/para-*/)
UPSTREAM_DIRS=(skills/obsidian-markdown skills/obsidian-bases skills/json-canvas skills/obsidian-cli skills/defuddle)

# ---------------------------------------------------------------------------
section "1. Every skills/*/SKILL.md frontmatter parses as YAML"
for f in skills/*/SKILL.md; do
  [ -f "$f" ] || continue
  if msg=$(python3 - "$f" <<'PY'
import sys, yaml
p = sys.argv[1]
t = open(p, encoding="utf-8").read()
if not t.startswith("---"):
    print("no opening --- fence"); sys.exit(1)
parts = t.split("---", 2)
if len(parts) < 3:
    print("unterminated frontmatter"); sys.exit(1)
try:
    yaml.safe_load(parts[1])
except Exception as e:
    print(f"YAML error: {e}"); sys.exit(1)
PY
  ); then pass "$f"; else fail "$f — $msg"; fi
done

# ---------------------------------------------------------------------------
section "2. Each para-* SKILL.md: exactly {name, description}; name == dir"
for d in "${PARA_SKILLS[@]}"; do
  f="${d}SKILL.md"; dir="$(basename "$d")"
  [ -f "$f" ] || { fail "$f — missing"; continue; }
  if msg=$(python3 - "$f" "$dir" <<'PY'
import sys, yaml
p, dirname = sys.argv[1], sys.argv[2]
try:
    fm = yaml.safe_load(open(p, encoding="utf-8").read().split("---", 2)[1])
except Exception as e:
    print(f"frontmatter YAML error: {e}"); sys.exit(1)
if not isinstance(fm, dict):
    print("frontmatter is not a mapping"); sys.exit(1)
keys = sorted(fm.keys())
if keys != ["description", "name"]:
    print(f"keys are {keys}, expected ['description','name']"); sys.exit(1)
if fm["name"] != dirname:
    print(f"name '{fm['name']}' != dir '{dirname}'"); sys.exit(1)
PY
  ); then pass "$dir (name+description, name==dir)"; else fail "$dir — $msg"; fi
done

# ---------------------------------------------------------------------------
section "3. Relative links in para-* skills resolve"
broken=$(python3 - "${PARA_SKILLS[@]}" <<'PY'
import sys, os, re, glob
link_re = re.compile(r"\[[^\]]*\]\(([^)]+)\)")
for base in sys.argv[1:]:
    for md in glob.glob(os.path.join(base, "**", "*.md"), recursive=True):
        d = os.path.dirname(md)
        for m in link_re.findall(open(md, encoding="utf-8").read()):
            t = m.strip()
            if t.startswith(("http://", "https://", "mailto:", "#")):
                continue
            t = t.split("#", 1)[0]            # drop anchor
            if not t:
                continue
            if not os.path.exists(os.path.normpath(os.path.join(d, t))):
                print(f"{md}: broken link -> {m}")
PY
)
if [ -z "$broken" ]; then pass "all para-* relative links resolve"; else fail "broken relative links:"; printf '      %s\n' "$broken"; fi

# ---------------------------------------------------------------------------
section "4. Packaging JSON valid + versions match"
if jq empty .claude-plugin/marketplace.json >/dev/null 2>&1; then pass "marketplace.json is valid JSON"; else fail "marketplace.json invalid JSON"; fi
if jq empty .claude-plugin/plugin.json >/dev/null 2>&1; then pass "plugin.json is valid JSON"; else fail "plugin.json invalid JSON"; fi
MV=$(jq -r '.plugins[0].version' .claude-plugin/marketplace.json 2>/dev/null)
PV=$(jq -r '.version' .claude-plugin/plugin.json 2>/dev/null)
if [ -n "$MV" ] && [ "$MV" = "$PV" ]; then pass "versions match ($PV)"; else fail "version mismatch (marketplace=$MV plugin=$PV)"; fi

# ---------------------------------------------------------------------------
section "5. Forbidden content in para-* skills"
# dataview: allowed only on lines that also prohibit it
badview=$(grep -rinE 'dataview' "${PARA_SKILLS[@]}" 2>/dev/null | grep -viE '(never|disabled|forbidden|prohibit)' || true)
if [ -z "$badview" ]; then pass "no un-prohibited 'dataview' mention"; else fail "dataview mentioned without prohibition:"; printf '      %s\n' "$badview"; fi
for pat in '27123' 'find-generic-password' 'keychain'; do
  hits=$(grep -rinE "$pat" "${PARA_SKILLS[@]}" 2>/dev/null || true)
  if [ -z "$hits" ]; then pass "no '$pat'"; else fail "'$pat' present:"; printf '      %s\n' "$hits"; fi
done

# ---------------------------------------------------------------------------
section "6. Upstream skill dirs byte-identical to upstream/main"
if git remote | grep -qx upstream; then
  if git rev-parse --verify -q upstream/main >/dev/null; then
    if git diff --quiet upstream/main -- "${UPSTREAM_DIRS[@]}"; then
      pass "5 upstream dirs match upstream/main"
    else
      fail "upstream dirs diverge from upstream/main:"; git diff --stat upstream/main -- "${UPSTREAM_DIRS[@]}" | sed 's/^/      /'
    fi
  else
    skip "upstream remote present but upstream/main not fetched (run: git fetch upstream)"
  fi
else
  skip "no 'upstream' remote yet (added in Wave 0); skipping integrity check"
fi

# ---------------------------------------------------------------------------
section "7. claude plugin validate"
if command -v claude >/dev/null 2>&1 && claude plugin validate --help >/dev/null 2>&1; then
  if out=$(claude plugin validate . 2>&1); then pass "claude plugin validate ."; else fail "claude plugin validate . failed:"; printf '      %s\n' "$out"; fi
else
  skip "claude plugin validate not supported by installed CLI"
fi

# ---------------------------------------------------------------------------
printf "\n"
if [ "$FAIL" -eq 0 ]; then printf "${grn}${bold}L1 validation passed${rst}\n"; exit 0
else printf "${red}${bold}L1 validation FAILED${rst}\n"; exit 1; fi
