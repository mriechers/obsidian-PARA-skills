# 09 — Deployment runbook

## 0. Preconditions

- `gh auth status` OK **and** `gh auth setup-git` has been run — the marketplace
  clone of a private repo rides on HTTPS git credentials.
- `git remote add upstream https://github.com/kepano/obsidian-skills.git` in the
  permanent clone (`/Users/mriechers/Developer/personal/obsidian-PARA-skills`).
- Obsidian running (needed only for L3 tests).

## 1. Pre-release gates

- `tests/validate.sh` green (L1).
- L2 local-path install green (see 08-testing-spec.md).
- `version` is `2.0.0` in BOTH `.claude-plugin/plugin.json` and
  `.claude-plugin/marketplace.json`.

## 2. Repo visibility

```
gh repo edit mriechers/obsidian-PARA-skills --visibility private --accept-visibility-change-consequences
gh repo view mriechers/obsidian-PARA-skills --json visibility   # expect PRIVATE
```

Must be PRIVATE before pushing skills/planning content (they describe the vault).

## 3. Ship

```
git add -A && git commit && git push origin main
```

## 4. Install from GitHub

```
/plugin marketplace remove obsidian-para-skills   # if a local-path test copy exists
/plugin marketplace add mriechers/obsidian-PARA-skills
/plugin install obsidian@obsidian-para-skills
```

Verify in a FRESH session: all 10 skills listed; a vault prompt ("file this note
in my PARA vault") triggers `para-vault`.

## 5. Persist across machines

Add to `~/.claude/settings.json` → `extraKnownMarketplaces`:

```json
"obsidian-para-skills": {
  "source": { "source": "github", "repo": "mriechers/obsidian-PARA-skills" }
}
```

Optional: mirror into the-lodge `knowledge/claude-code-plugins/plugins-config.json`
(source of truth for `claude-plugins-sync.sh`) — see 10-coordination-tasks.md.

## 6. Update flow (subsequent releases)

1. Edit → bump `version` in BOTH JSON files (semver: new skill = minor,
   fixes = patch).
2. `tests/validate.sh` → commit → push.
3. `/plugin marketplace update obsidian-para-skills` →
   `/plugin update obsidian@obsidian-para-skills` → restart session.

## 7. Upstream sync flow

```
git fetch upstream
git merge upstream/main
```

Expected conflict surface: `README.md` + `.claude-plugin/*.json` only (keep our
packaging, take upstream skill changes wholesale). Re-run
`tests/validate.sh` (upstream-integrity check) after every merge, bump patch
version, push, update marketplace.

## 8. Rollback

```
/plugin uninstall obsidian@obsidian-para-skills
/plugin marketplace remove obsidian-para-skills
```

(Or `git revert` the release commit and push, then `/plugin marketplace update`.)
