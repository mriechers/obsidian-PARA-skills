# Tasks query cookbook

The three canonical `tasks` query shapes for this vault, plus the query-language
subset actually used here. Authoritative copies live in
[`../../para-vault/references/VAULT-CONFIG.md`](../../para-vault/references/VAULT-CONFIG.md) §7 — these are repeated for
convenience with a "when to use" note each. **Reuse a canonical shape; do not
invent variants.**

## Canonical query blocks

### 1. Per-note rollup

**When to use:** listing the open tasks that live in the current note. Already
embedded by the default/project/area/archive templates under `## 🗒 Tasks in
this note` — don't add a second one to a templated note.

````
```tasks
path includes {{query.file.path}}
not done
sort by due
sort by priority
```
````

### 2. "Today" board query

**When to use:** a dashboard of what's due today or overdue, drawn from the
daily/weekly task notes. Used by the kanban + chores templates.

````
```tasks
path includes Daily and Weekly Tasks
not done
(due today) OR (due before tomorrow)
hide recurrence rule
hide edit button
sort by description
```
````

### 3. Per-PARA-folder rollup

**When to use:** a grouped rollup of every open task in one PARA folder.
Parallel blocks exist for `2 - AREAS` and `3 - RESOURCES` (each adds
`path does not include TEMPLATES`) and `4 - ARCHIVE`. Swap the `folder includes`
line for the target folder.

````
```tasks
folder includes 1 - PROJECTS
not done
path does not include Daily and Weekly Tasks
group by filename
sort by priority
sort by due
hide postpone button
short mode
limit to 100 tasks
```
````

## Query-language quick reference

Instructions actually used in this vault:

| Instruction | Purpose |
|---|---|
| `path includes <text>` | match tasks whose file path contains `<text>` |
| `folder includes <folder>` | scope to a folder subtree (e.g. `1 - PROJECTS`) |
| `path does not include <text>` | exclude a subtree — e.g. `TEMPLATES` |
| `not done` | drop completed and cancelled tasks |
| `(due today) OR (due before tomorrow)` | today + overdue |
| `group by filename` | group results per source note |
| `sort by due` / `sort by priority` / `sort by description` | ordering (stack multiple; first is primary) |
| `hide recurrence rule` / `hide edit button` / `hide postpone button` | trim result-card UI |
| `short mode` | compact one-line rendering |
| `limit to 100 tasks` | cap result count |
| `{{query.file.path}}` | placeholder → the querying note's own path |

## Anti-patterns

- **Inventing a new query shape** when a canonical one fits. Start from one of
  the three above.
- **Omitting the exclusions.** A folder rollup that forgets
  `path does not include TEMPLATES` pulls in template boilerplate; forgetting
  `path does not include Daily and Weekly Tasks` double-counts board tasks.
- **Forgetting `not done`** — every query above needs it, or completed tasks
  flood the results.
- **Dataview queries.** Dataview is installed but DISABLED; a
  ` ```dataview ` block is forbidden — never write one. Use `tasks` blocks
  (here) or `.base` views for indexes.
