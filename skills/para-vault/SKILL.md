---
name: para-vault
description: "Work with a PARA-organized Obsidian vault: folder structure, the para frontmatter property as ground truth, tag and status conventions, templates, and routing between file edits, CLI, and REST API. Use when creating, saving, moving, filing, or classifying notes in a PARA vault — including a bare 'save this to my vault' or 'drop this in Obsidian' with no folder given (default to the Inbox) — or before any other vault operation."
---

# PARA Vault Skill

Work with a PARA-organized Obsidian vault. **Read [references/VAULT-CONFIG.md](references/VAULT-CONFIG.md) before acting.** This skill teaches generic PARA patterns; the config file holds every value specific to this vault (paths, folder names, tag vocabulary, ports, board names) and is the binding source whenever the two disagree.

## PARA in one paragraph

PARA sorts every note into one of four buckets — **Projects** (active, goal-bound), **Areas** (ongoing responsibilities), **Resources** (reference material), **Archive** (inactive) — plus an **Inbox** for un-triaged capture. Each bucket is a numbered top-level folder (Inbox = 0, Projects = 1, … Archive = 4); a vault may extend the scheme (e.g. an Outbox). Exact folder names live in the config.

## The `para` property is ground truth

PARA membership is the frontmatter `para` value — `inbox | projects | areas | resources | archive` — **not the note's folder**. Folders drift (a note can sit in the Projects folder while carrying `para: resources`); the index views (Obsidian Bases) filter on `para`, not on path. When filing or classifying, set `para` correctly and treat folder location as a hint, not the truth.

## Frontmatter contract

Every note an agent creates or edits follows the contract (property *keys* below; the *values* live in the config):

- `tags` — a list whose **first entry is the anchor tag** defined in the config, then lowercase kebab-case topical tags.
- `created` — the creation date.
- `para` — one of the five categories above.
- `status` — optional, on projects/areas; use only the vocabulary listed in the config.
- `para_history` — **append-only, plugin-written. Never hand-edit or reorder it.**

Copy-paste examples per note type are in [references/FRONTMATTER.md](references/FRONTMATTER.md). Defer YAML and property *syntax* to the [obsidian-markdown](../obsidian-markdown/SKILL.md) skill (its PROPERTIES.md reference).

## Moving notes between PARA categories

To move a note between categories, **change its `para` value** — do not just drag the file. The vault's PARA automation (named in the config) then maintains `para_history` and auto-cancels open tasks when a note is archived. Moving the file without updating `para` leaves it misfiled from the indexes' point of view; updating `para` by hand without the automation loses the audit trail. Prefer the automation over a raw property edit whenever Obsidian is running.

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
