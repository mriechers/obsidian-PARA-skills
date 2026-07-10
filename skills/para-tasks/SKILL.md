---
name: para-tasks
description: "Create and query tasks with the Obsidian Tasks plugin in a PARA vault: emoji-format dates and priorities, recurrence, custom checkbox statuses, and the vault's canonical tasks query blocks. Use when adding todos, due dates, recurring tasks, priorities, or writing or editing ```tasks queries."
---

# PARA Tasks

Author and query tasks with the **obsidian-tasks-plugin** in this PARA vault.
Vault-specific values (plugin version, statuses, canonical queries) live in
[`../para-vault/references/VAULT-CONFIG.md`](../para-vault/references/VAULT-CONFIG.md) §7 — cite it, don't re-derive.
Query cookbook + anti-patterns: [`references/QUERIES.md`](references/QUERIES.md).

For generic checkbox markdown, assume the reader knows it — don't restate it.
For CLI task commands (`obsidian tasks daily todo`, etc.), defer to
[`../obsidian-cli`](../obsidian-cli/SKILL.md).

## Every checkbox is a task ⚠️

This vault runs **NO global filter** (`globalFilter` empty). EVERY `- [ ]`
checkbox anywhere in the vault is indexed as a task and pollutes every `tasks`
query. Consequences:

- **Only** write `- [ ]` when you mean a real, queryable task.
- For non-task lists (steps, options, agenda bullets), use plain `-` bullets —
  never `- [ ]`.
- A stray checklist in a note bleeds into per-note rollups and PARA-folder
  rollups across the vault.

## Emoji grammar

Format is `tasksPluginEmoji`. Metadata trails the task text on one line:

| Emoji | Meaning | Emoji | Meaning |
|---|---|---|---|
| `📅` | due date | `🔺` | priority: highest |
| `⏳` | scheduled date | `⏫` | priority: high |
| `➕` | created date | `🔼` | priority: medium |
| `✅` | done date | `🔽` | priority: low |
| `🔁` | recurrence rule | `⏬` | priority: lowest |

Verbatim example (a recurring task):

```
- [ ] Check schedule for bugs 🔁 every day ➕ 2026-07-03 📅 2026-07-04
```

## Filename-as-scheduled-date

`useFilenameAsScheduledDate: true` — in a daily note (`0 - INBOX/DAILY
JOURNAL/YYYY-MM-DD.md`), the **filename is the scheduled date** for every task
in it.

- Don't add a redundant `⏳` scheduled date to tasks inside a daily note.
- `removeScheduledDateOnRecurrence: true` — recurrence drops the scheduled date
  when the next instance spawns; don't hand-add it back.

## Auto-set dates — don't fight the plugin

The plugin writes these itself; never hand-type them:

- `➕` created date on new tasks (`setCreatedDate`).
- `✅` done date on completion (`setDoneDate`).
- cancelled date on `- [-]` (`setCancelledDate`).

Archiving a note auto-cancels its open tasks (quick-para
`tasks.autoCancelOnArchive`) — expect `- [-]` on archive.

## Custom statuses

Beyond ` ` (todo) and `x` (done), this vault defines extended checkbox
characters. VAULT-CONFIG §7 holds the authoritative set:

| Char | Status | Char | Status |
|---|---|---|---|
| `/` | in progress | `*` | star |
| `-` | cancelled | `n` | note |
| `>` | rescheduled | `l` | location |
| `<` | scheduled | `i` | information |
| `!` | important | `I` | idea |
| `?` | question | `S` | amount |

Written as `- [/] …`, `- [!] …`, etc. Any non-blank status still counts as a
task in queries — `not done` excludes only `x` and cancelled.

## Canonical queries

The vault has **three** standard `tasks` query shapes — per-note rollup, "today"
board, and per-PARA-folder rollup. They live VERBATIM in
[`../para-vault/references/VAULT-CONFIG.md`](../para-vault/references/VAULT-CONFIG.md) §7 (repeated with a "when to
use" note in [`references/QUERIES.md`](references/QUERIES.md)). **Reuse them; do not invent variants.**

- The default/project/area/archive **templates already embed the per-note
  rollup** under `## 🗒 Tasks in this note` — never paste a second one into a
  note that has it.
- Every folder rollup excludes `TEMPLATES` and `Daily and Weekly Tasks` — keep
  those guards when you copy a shape.

**Dataview is DISABLED** — never write Dataview (` ```dataview `) task queries.
`tasks` blocks and `.base` views are the only query layers.

## Kanban interplay

Kanban cards are tasks too: a card `- [ ] [[Note]] #tag @{YYYY-MM-DD}` carries a
`@{…}` date the Kanban plugin manages, and it surfaces in `tasks` queries. For
card grammar and the board, see [`../para-kanban`](../para-kanban/SKILL.md).

## Standalone-install note

If you installed `para-tasks` on its own (per-skill copiers like `npx skills`),
also install **`para-vault`** so
[`../para-vault/references/VAULT-CONFIG.md`](../para-vault/references/VAULT-CONFIG.md) resolves — this skill's
canonical queries and status set live there.
