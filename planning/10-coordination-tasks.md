# 10 — Coordination tasks (outside this repo)

None of these edits happen in this repo. File or execute them in their home
repos during Wave 4.

## 1. the-lodge: fix the dangling `/add-to-inbox` skill reference

- File: `the-lodge/.claude/library/second-brain/skills/add-to-inbox/SKILL.md`,
  line 79: `- For full vault structure and advanced operations, invoke the
  \`obsidian-vault\` skill` — `obsidian-vault` does not exist.
- Edit: point it at **`para-vault`** (installed via the `obsidian-para-skills`
  marketplace).
- Propagate: the packaged copy at
  `the-lodge/org-marketplaces/mriechers/plugins/add-to-inbox/skills/add-to-inbox/SKILL.md`
  must get the same edit (or be regenerated from the library source).

## 2. Secrets migration: Keychain → 1Password

- User standard: secrets come from **1Password via the `op` CLI**, not macOS
  Keychain. `/add-to-inbox` currently documents
  `security find-generic-password -s 'developer.workspace.OBSIDIAN_LOCAL_REST_API_KEY' -w`
  — legacy.
- Once the exact `op://` item reference for the Obsidian Local REST API key is
  confirmed (see 11-open-questions.md), update `/add-to-inbox` (both copies, as
  in task 1) and grep the-lodge + second-brain for other
  `find-generic-password` references to migrate.
- Decide: delete the Keychain entry, or keep it as a fallback until every
  consumer is migrated. Recommend keeping until vault-courier and any homelab
  services are confirmed migrated, then delete.

## 3. `~/.claude/settings.json`: marketplace entry

Add under `extraKnownMarketplaces` (exact JSON in
[09-deployment-runbook.md](09-deployment-runbook.md) §5). Verify the entry still
resolves after the repo is private (it rides on gh/git credentials).

## 4. the-lodge: plugins-config mirror

`the-lodge/knowledge/claude-code-plugins/plugins-config.json` is the
source-of-truth for `scripts/claude-plugins-sync.sh`. Recommend: add the
`obsidian-para-skills` marketplace + enabled `obsidian` plugin there so other
machines pick it up via the sync script.

## 5. Deploy-channel decision: marketplace vs `/sync` symlinks

These skills could also be symlinked into `~/.claude/skills/` by the-lodge's
`sync_user_skills.sh`. Recommend **marketplace-only** as the canonical channel
for this repo to avoid double-loading and version drift; ensure the sync
script's discovery (which walks `~/Developer/**/.claude/skills`) does NOT pick
up this repo's `skills/` — its layout (`skills/` at root, not `.claude/skills/`)
should already exclude it; verify once after the first `/sync skills` run.

## 6. vault-courier alignment

`second-brain/services/vault-courier/vault_courier/render.py` renders the same
frontmatter contract plus a `source:` field. No change needed — but when
`para-vault` ships, confirm VAULT-CONFIG §3 documents the `source:` field so the
skill and the service never contradict each other. Any future contract change
must update both.

## 7. Housekeeping

- `~/.claude/ARCHIVE/skills/add-to-inbox/` (and `… copy/`) are stale duplicates —
  ignore them; do not edit or resurrect.
- When everything ships: update the memory file
  `~/.claude/projects/-Users-mriechers-Developer-personal/memory/obsidian-vault-skill-gap.md`
  to record the gap as closed by `para-vault`.
