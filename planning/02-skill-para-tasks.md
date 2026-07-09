# 02 — Skill spec: `para-tasks`

Target: `skills/para-tasks/SKILL.md` + `references/QUERIES.md`.
Facts: [00-vault-reference.md](00-vault-reference.md) §7.

## Frontmatter (exact)

```yaml
---
name: para-tasks
description: Create and query tasks with the Obsidian Tasks plugin in a PARA vault: emoji-format dates and priorities, recurrence, custom checkbox statuses, and the vault's canonical tasks query blocks. Use when adding todos, due dates, recurring tasks, priorities, or writing or editing ```tasks queries.
---
```

## SKILL.md outline

1. **Emoji grammar** — one table: `📅` due, `⏳` scheduled, `➕` created,
   `✅` done, `🔁` recurrence; priorities `🔺⏫🔼🔽⏬`. One verbatim example line
   (from 00 §7).
2. **Every checkbox is a task** — this vault runs NO global filter; a casual
   `- [ ]` list pollutes every task query. Use plain `-` bullets for non-tasks.
3. **Filename-as-scheduled-date** — daily-note filenames double as the scheduled
   date (`useFilenameAsScheduledDate`); don't add redundant `⏳` in daily notes;
   recurrence drops the scheduled date on spawn.
4. **Auto-set dates** — the plugin writes ➕/✅/cancelled dates itself; don't
   fight it.
5. **Custom statuses** — table of the extended checkbox characters and meanings
   (config holds the authoritative set): `/` in-progress, `-` cancelled,
   `>` rescheduled, `<` scheduled, `!` important, `?` question, `*` star,
   `n` note, `i` info, `I` idea.
6. **Canonical queries** — the three vault-standard shapes (per-note rollup /
   today / per-PARA-folder rollup) live VERBATIM in
   `../para-vault/references/VAULT-CONFIG.md` §7 — reuse them, don't invent
   variants. Templates already embed the per-note rollup: never duplicate it
   into a note that has one.
7. **Kanban interplay** — one line: cards are tasks too; `@{YYYY-MM-DD}` dates
   come from the Kanban plugin → see `para-kanban`.
8. Standalone-install caveat (needs `para-vault` for the config).

## references/QUERIES.md

- The three canonical blocks copied verbatim with a "when to use" line each.
- Query-language quick reference actually used in this vault: `path includes`,
  `folder includes`, `not done`, `(due today) OR (due before tomorrow)`,
  `group by filename`, `sort by due/priority/description`, `hide …` directives,
  `short mode`, `limit to 100 tasks`, `{{query.file.path}}` placeholder.
- Anti-patterns: inventing new query shapes when a canonical one fits; querying
  without excluding `TEMPLATES`; forgetting `not done`; Dataview-style queries
  (forbidden — Dataview is disabled).

## Overlap rules

- CLI task commands (`obsidian tasks …`) → defer to `obsidian-cli`.
- Generic checkbox markdown → assumed knowledge; don't restate.

## Acceptance checklist

- [ ] Frontmatter exactly `name` + `description`; `name` == dir name.
- [ ] The no-global-filter warning is prominent (top 3 sections).
- [ ] Canonical queries referenced from VAULT-CONFIG, not restated in SKILL.md
      (QUERIES.md may carry them verbatim).
- [ ] No Dataview mentions except prohibition; links resolve; ≤ ~150 lines.
