# planning/ — Build docs for the PARA skill augmentation

This folder is the orchestration entrypoint for extending this fork of
[kepano/obsidian-skills](https://github.com/kepano/obsidian-skills) with five new
skills that teach agents to work in a PARA-organized Obsidian vault. Everything a
build session needs is in these docs — **no re-exploration of the vault or the
repo is required**. Facts live in [00-vault-reference.md](00-vault-reference.md);
every other doc cites it rather than restating values.

## Goal

Ship five new skills alongside the five upstream skills, rebrand the packaging,
rewrite the README, validate everything, and deploy via the Claude Code plugin
marketplace — per the specs in this folder.

## Deliverables

| Deliverable | Spec |
|---|---|
| `skills/para-vault/` (flagship + shared VAULT-CONFIG) | [01-skill-para-vault.md](01-skill-para-vault.md) |
| `skills/para-tasks/` | [02-skill-para-tasks.md](02-skill-para-tasks.md) |
| `skills/para-kanban/` | [03-skill-para-kanban.md](03-skill-para-kanban.md) |
| `skills/para-rest-api/` | [04-skill-para-rest-api.md](04-skill-para-rest-api.md) |
| `skills/para-daily-journal/` | [05-skill-para-daily-journal.md](05-skill-para-daily-journal.md) |
| Rebranded `.claude-plugin/*.json` | [06-packaging-spec.md](06-packaging-spec.md) |
| Rewritten `README.md` | [07-readme-spec.md](07-readme-spec.md) |
| `tests/validate.sh` + test execution | [08-testing-spec.md](08-testing-spec.md) |
| Deployed marketplace | [09-deployment-runbook.md](09-deployment-runbook.md) |
| Out-of-repo follow-ups | [10-coordination-tasks.md](10-coordination-tasks.md) |

## Locked decisions (do not re-litigate)

1. Flagship skill is named **`para-vault`** (the-lodge's `/add-to-inbox` dangling
   `obsidian-vault` reference gets patched to this — coordination task, not here).
2. **Generic + config file**: skills teach generic PARA/plugin patterns; every
   Mark-specific value lives only in `skills/para-vault/references/VAULT-CONFIG.md`.
3. **Single plugin, extended**: new skills are sibling dirs in `skills/`; plugin
   `obsidian` bumps to **2.0.0**; marketplace renamed **`obsidian-para-skills`**;
   mriechers identity in packaging; kepano credited.
4. **Repo is private** — it must be private before any push of these docs.
5. Sibling skills all take the **`para-` prefix**.
6. **Secrets via 1Password `op` CLI** — the Keychain retrieval found in older
   ecosystem docs is legacy; never document it in new skills.

## Execution waves

- **Wave 1 — skills (parallelizable)**: build the five skills from specs 01–05.
  `para-vault` goes first (or stub its `VAULT-CONFIG.md` immediately) because the
  four siblings link to `../para-vault/references/VAULT-CONFIG.md`.
  Done when: each skill passes its spec's acceptance checklist.
- **Wave 2 — packaging + README (parallel)**: specs 06 and 07.
  Done when: both JSONs match the spec verbatim; README matches the outline.
- **Wave 3 — testing**: spec 08, layers L1 → L2 → L3 in order.
  Done when: validate.sh green, local + GitHub installs verified, smoke checklist
  passed with all `_smoke-` artifacts cleaned up.
- **Wave 4 — deployment + coordination**: specs 09 and 10.
  Done when: marketplace installed from GitHub, settings.json entry persisted,
  coordination tasks filed or completed in their home repos.

## Guardrails

- The five upstream skill dirs (`obsidian-markdown`, `obsidian-bases`,
  `json-canvas`, `obsidian-cli`, `defuddle`) stay **byte-identical** to upstream.
  Verify: `git diff --quiet upstream/main -- skills/<dir>` for each.
- `LICENSE` is untouchable. Divergence is allowed only in: `README.md`, the two
  `.claude-plugin/` JSONs, `planning/`, `tests/`, and new skill dirs.
- Never edit the live vault (`/Users/mriechers/MarkBrain`) except `_smoke-`
  prefixed scratch files during L3 tests; never touch the master Project Dashboard.
- Edits to the-lodge, second-brain, or `~/.claude/settings.json` are coordination
  tasks (spec 10) — they do not happen inside this repo.

## Authoring style (distilled from the upstream skills)

- `SKILL.md` ≤ ~150 lines, imperative, workflow-first, no marketing prose.
- Frontmatter: exactly two keys, `name` and `description`. `name` matches the
  directory name. `description` is third-person, states what the skill does and
  ends with "Use when …" trigger clauses.
- Depth goes in `references/*.md`, linked from SKILL.md with relative paths.
- No `scripts/` dirs; no executable content in skills.
- Cross-reference sibling and upstream skills instead of duplicating their content
  (the overlap rules are in each skill spec).
