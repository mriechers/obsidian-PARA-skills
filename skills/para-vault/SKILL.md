---
name: para-vault
description: "Work with a PARA-organized Obsidian vault: folder structure as ground truth, the para frontmatter property as its derived cache, tag and status conventions, templates, and routing between file edits, CLI, and REST API. Use when creating, saving, moving, filing, or classifying notes in a PARA vault — including a bare 'save this to my vault' or 'drop this in Obsidian' with no folder given (default to the Inbox) — or before any other vault operation."
---

# PARA Vault Skill

Work with a PARA-organized Obsidian vault. **Read [references/VAULT-CONFIG.md](references/VAULT-CONFIG.md) before acting.** This skill teaches generic PARA patterns; the config file holds every value specific to this vault (paths, folder names, tag vocabulary, ports, board names) and is the binding source whenever the two disagree.

## PARA in one paragraph

PARA sorts every note into one of four buckets — **Projects** (active, goal-bound), **Areas** (ongoing responsibilities), **Resources** (reference material), **Archive** (inactive) — plus an **Inbox** for un-triaged capture. Each bucket is a numbered top-level folder (Inbox = 0, Projects = 1, … Archive = 4); a vault may extend the scheme (e.g. an Outbox). Exact folder names live in the config.

## The folder is ground truth; `para` is a derived cache

PARA membership is the note's **folder**. The frontmatter `para` value — `inbox | projects | areas | resources | archive` — is a cache the quick-para plugin derives from the path and overwrites to match:

```js
const oldParaLocation = frontmatter[propertyName];   // stale property value
frontmatter[propertyName] = paraLocation;            // derived from FOLDER PATH
if (oldParaLocation && oldParaLocation !== paraLocation) { /* append para_history */ }
```

**Do not hand-edit `para`.** The plugin reverts the edit on its next pass *and* appends a `para_history` entry recording your edit as a move that never happened. Measured against the live vault on 2026-09-01, 71% of the 3,254 recorded transitions were produced this way rather than by anyone moving anything.

The index views (Obsidian Bases) do filter on `para`, so a note whose property has drifted from its folder will be misfiled in those views until the plugin next reconciles it — but the fix is to move the file, not to edit the property.

## Frontmatter contract

Every note an agent creates or edits follows the contract (property *keys* below; the *values* live in the config):

- `tags` — a list whose **first entry is the anchor tag** defined in the config, then lowercase kebab-case topical tags.
- `created` — the creation date.
- `para` — one of the five categories above.
- `status` — optional, on projects/areas; use only the vocabulary listed in the config.
- `para_history` — **append-only, plugin-written. Never hand-edit or reorder it.**

Copy-paste examples per note type are in [references/FRONTMATTER.md](references/FRONTMATTER.md). Defer YAML and property *syntax* to the [obsidian-markdown](../obsidian-markdown/SKILL.md) skill (its PROPERTIES.md reference).

## Moving notes between PARA categories

To move a note between categories, **move the file** into the target PARA folder — or use the plugin's sidebar move button, which does the same thing. Do not edit the `para` property.

The plugin's `vault.on('rename')` handler fires on the move, derives the new category from the path, updates `para`, and appends the `para_history` entry. That is the only path that produces a truthful audit trail.

Editing `para` by hand does the opposite: the value is overwritten from the folder on the next pass, and the discrepancy is recorded as a fabricated transition. Two caveats worth knowing:

- **Renames are invisible.** A rename that does not change the folder appends nothing, and the old filename is recorded nowhere.
- **Auto-cancel-on-archive does not run.** The deployed build passes a fourth argument to a three-parameter `TaggingManager` constructor, so the task manager is silently dropped. The sidebar's confirmation dialog promises open tasks will be cancelled; nothing cancels them. Cancel them explicitly if that matters.

## Creating notes

- **Default destination — the Inbox.** When asked to "save this to the vault", "drop this in Obsidian", or add a note **without a specified folder or PARA category**, create a **new note in the Inbox** (path in the config) with the full frontmatter contract — `para: inbox`, anchor-tag-first `tags`, and `created`. Don't stop to ask where it goes: the Inbox is the un-triaged capture point, and classification happens later by changing `para`. Give the note a Title-Case filename derived from its content (sanitize/collision rules in the config), and create a **new** note rather than appending to an existing one. Only deviate when the user names a destination or the content plainly belongs elsewhere.
- **In-app creation** applies the matching folder-template automatically (template map in the config).
- **Out-of-app creation** (direct file write, REST API) does **not** fire templates — **read the matching template file** (via the config's template map, e.g. the Inbox template) and reproduce its body, then add the full frontmatter contract; build from the real template, never a remembered skeleton — it is the source of truth for note structure.

## Hygiene rules

- Never grep, index, or walk the config's excluded directories.
- Never edit sync-conflict files (pattern in the config) — they are sync duplicates and their deletions propagate.
- **Never suggest Dataview queries** — Dataview is disabled in this vault. **Bases** (`.base` files) is the index/MOC layer; defer `.base` syntax to the [obsidian-bases](../obsidian-bases/SKILL.md) skill.
- Don't write casual `- [ ]` checkbox lists — depending on the Tasks configuration every checkbox may be indexed as a live task. See [para-tasks](../para-tasks/SKILL.md).

## Access-method routing

| Situation | Method |
|---|---|
| Bulk/offline edits, agent has filesystem access | Direct file edit |
| Obsidian running, want app-side effects (templates, daily notes) | [obsidian-cli](../obsidian-cli/SKILL.md) skill |
| Programmatic create/read over HTTP, Obsidian running | [para-rest-api](../para-rest-api/SKILL.md) skill |

When Obsidian is not running the REST API is unavailable — fall back to a direct file write that honors the frontmatter contract (fallback path in the config).

## Sibling skills

- [para-tasks](../para-tasks/SKILL.md) — task syntax, custom statuses, and the canonical queries.
- [para-kanban](../para-kanban/SKILL.md) — the master board, lane order, and card grammar.
- [para-rest-api](../para-rest-api/SKILL.md) — Local REST API calls against the vault.
- [para-daily-journal](../para-daily-journal/SKILL.md) — daily-note structure and the machine-written section markers.
