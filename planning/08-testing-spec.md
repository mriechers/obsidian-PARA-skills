# 08 — Testing spec (three layers)

Proportionate to a personal skills repo: a local validation script (no CI), a
packaging install check, and a short agent-in-the-loop smoke checklist.

## L1 — Static validation: `tests/validate.sh`

Runnable locally from repo root; exit non-zero on any failure. Checks:

1. Every `skills/*/SKILL.md` frontmatter parses as YAML.
2. Every **new** skill (`skills/para-*`) has EXACTLY two frontmatter keys:
   `name`, `description` — and `name` equals its directory name.
3. Every relative link in new skills (`references/…`, `../para-vault/…`)
   resolves to an existing file.
4. `jq empty` passes on `.claude-plugin/marketplace.json` and
   `.claude-plugin/plugin.json`; the `version` fields in both files match.
5. Forbidden-content greps over `skills/para-*` (case-insensitive), fail on hit:
   - `dataview` — allowed only on lines that prohibit it (e.g. matches
     `never`/`disabled`/`forbidden` on the same line)
   - `27123` (the disabled insecure port)
   - `find-generic-password` / `keychain` (legacy secret retrieval)
6. Upstream integrity (requires the `upstream` remote):
   `git diff --quiet upstream/main -- skills/obsidian-markdown skills/obsidian-bases skills/json-canvas skills/obsidian-cli skills/defuddle`
7. If the installed CLI supports it: `claude plugin validate .` (skip gracefully
   otherwise).

## L2 — Packaging validation

1. Local-path round trip:
   `/plugin marketplace add /Users/mriechers/Developer/personal/obsidian-PARA-skills`
   → `/plugin install obsidian@obsidian-para-skills` → confirm **all 10 skills**
   are listed and enabled in `/plugin` → exercise one trigger ("create a note in
   my PARA vault" should surface `para-vault`).
2. Remove the local marketplace, push to GitHub, repeat via
   `/plugin marketplace add mriechers/obsidian-PARA-skills` — this also proves
   the **private-repo gh-auth clone path** end to end.

## L3 — Behavioral smoke checklist (live vault)

A fixture vault would need all five plugin configs replicated — disproportionate;
the REST API only exists on the live instance anyway. Safety rules:

- All test artifacts prefixed **`_smoke-`**; the master Project Dashboard is
  NEVER touched; every test ends with cleanup (Syncthing propagates deletions —
  fine for scratch files); Obsidian must be running.

Each test = fresh-session prompt → expected artifact → verify → cleanup.

| # | Prompt (fresh session) | Expected | Verify | Cleanup |
|---|---|---|---|---|
| 1 | "Health-check the vault REST API" | Key via `op` (never Keychain), `curl -k https://127.0.0.1:27124/` returns OK JSON | command transcript | none |
| 2 | "Create a note titled _smoke-rest-test in my vault inbox via the REST API, about testing" | `PUT /vault/0%20-%20INBOX/_smoke-rest-test.md` with full contract | frontmatter: `all`-first tags, `created`, `para: inbox`; ALSO record whether Templater double-fired (open question) | `DELETE` the note (or rm file) |
| 3 | "Show me a tasks query for all open project tasks in my vault" | The canonical per-PARA rollup (`folder includes 1 - PROJECTS` … `group by filename` … `limit to 100 tasks`) | text matches VAULT-CONFIG §7 shape | none |
| 4 | "Create a kanban board _smoke-board with lanes Todo and Done, and add a card for _smoke-note tagged #me due next Monday" | `kanban-plugin: board` frontmatter; card `- [ ] [[_smoke-note]] #me @{YYYY-MM-DD}` | grammar + lane spacing | delete board + backing note |
| 5 | "Copy today's journal to _smoke-journal.md and add a line to its pulse section" | new text strictly between `SECTION:pulse` markers | diff vs original: all other markers/lines byte-identical, `> ` prefixes intact | delete copy |
| 6 | "Move _smoke-rest-test from inbox to projects" (run before test 2's cleanup) | agent updates `para: projects`, does NOT hand-write `para_history` | frontmatter diff | covered by test 2 cleanup |
| 7 | "Write me a Dataview query listing my projects" | agent declines Dataview, offers Bases instead | response text | none |

Pass bar: 7/7 with zero residue (`find ~/MarkBrain -name '_smoke-*'` empty and
dashboard untouched).
