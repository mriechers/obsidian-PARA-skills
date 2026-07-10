# BOARDS — Kanban board format & safe edits

Companion to [../SKILL.md](../SKILL.md). Authoritative vault values (master board
path, full lane order, context-hashtag vocabulary, plugin settings) live in
[../../para-vault/references/VAULT-CONFIG.md](../../para-vault/references/VAULT-CONFIG.md) §6 —
cite them from there, do not restate them as fact here.

## Minimal example board (safe to copy)

A complete, valid board is just markdown: `kanban-plugin: board` frontmatter,
one `## Heading` per lane, `- [ ]` cards, and a trailing `%% kanban:settings %%`
JSON block. Copy this as a starter and rename the lanes/cards:

````markdown
---
kanban-plugin: board
tags:
  - all
para: inbox
---

## TODAY

- [ ] [[Fix deploy script]] #coding-projects @{2026-07-10}
- [ ] [[Reply to editor]] #wpm

## Done

- [x] [[Draft Q3 proposal]] #freelance-biz @{2026-07-09} ✅ 2026-07-10


%% kanban:settings
```
{"kanban-plugin":"board","new-note-folder":"0 - INBOX","new-note-template":"3 - RESOURCES/TEMPLATES/default-template.md","move-tags":true,"move-task-metadata":true,"tag-action":"kanban","show-relative-date":true,"archive-with-date":true,"max-archive-size":30}
```
%%
````

Notes on the structure:

- The settings values above mirror VAULT-CONFIG §6; they are the *board's* copy
  of the plugin config. Leave the whole `%% kanban:settings %%` block alone
  unless the task is explicitly to change board config.
- Keep the blank line between each lane's last card and the next `## Heading`;
  the plugin round-trips that spacing.
- Every card is a Tasks-plugin task in this vault (no global filter) — see
  [../../para-tasks/SKILL.md](../../para-tasks/SKILL.md). Don't add checkbox
  lines you don't mean as tasks.

## Master-dashboard semantics

The master board's lanes read left-to-right as a **priority/time funnel**. The
exact ordered lane names are in VAULT-CONFIG §6; grouped by role they are:

| Stage | Role |
|---|---|
| **Capture** | Un-triaged inbox lane — new cards land here first. |
| **Scheduling / hold** | "Next week / hold", "someday", and "not mine" lanes — parked or deferred work waiting on a decision. |
| **This-week buckets** | Meetings/calls, quick wins, deep focus — committed work for the current week. |
| **Imminent** | Weekend / tomorrow / today lanes — narrowing to the immediate horizon. |
| **Active** | The "doing" lane — in-flight right now. |
| **Complete** | The done lane — finished, awaiting sweep. |
| **Archive** | Swept-away completed cards, date-stamped. |

### Card lifecycle walk-through

A single card moves rightward as its state changes:

1. **Captured** — added to the inbox lane: `- [ ] [[Note Title]] #context-tag`.
2. **Scheduled** — moved to a this-week or someday lane; gain a date when you
   commit to one: `- [ ] [[Note Title]] #context-tag @{2026-07-14}`.
3. **Today** — moved to the today lane as the date arrives.
4. **Doing** — moved to the doing lane while in progress.
5. **Done** — checked off in the done lane; the plugin stamps completion:
   `- [x] [[Note Title]] #context-tag @{2026-07-14} ✅ 2026-07-15`.
6. **Archived** — swept to the Archive lane; with `archive-with-date` on the
   card keeps its date stamp so the archive stays chronological.

Moving a card = cut its `- [ ]` line from the source lane and append it under the
target lane's heading. Because `move-tags` and `move-task-metadata` are on, the
move can rewrite the note's tags and metadata — see the tag-sync caution below.

## Tag-sync & metadata caution

`kanban-tag-sync` mirrors card `#hashtags` into the linked note's frontmatter
`tags`, and `move-tags` can rewrite tags on a lane move. **A card-hashtag edit is
a note edit.** Add or remove context hashtags deliberately, and use only the
vocabulary in VAULT-CONFIG §6.

## Safe-edit rules

- **Append cards at the lane's end** — add a new `- [ ]` line as the last item
  under the target `## Heading`, preserving the trailing blank line before the
  next lane.
- **Never restructure the master board.** The dashboard is co-written by vault
  automation (quick-para project updates). Add or move individual cards, but do
  not rename, reorder, add, or delete lanes unless explicitly asked.
- **Don't touch `%% kanban:settings %%`** unless the task is to change board
  config; a malformed settings block breaks the board view.
- **Leave the archive to the plugin.** With `archive-with-date: true` and
  `max-archive-size: 30`, the plugin manages the date stamp and trims the archive
  itself — sweep cards via the Archive lane rather than hand-authoring archive
  entries or the internal archive block.
- **New-note side effect:** a card linking a nonexistent `[[note]]` spawns a
  backing note (new-note folder + template named in VAULT-CONFIG §6) when the
  link is followed. Link an existing note if you only want a card.
- Wikilink *syntax* → [../../obsidian-markdown/SKILL.md](../../obsidian-markdown/SKILL.md);
  task date/priority emoji and queries → [../../para-tasks/SKILL.md](../../para-tasks/SKILL.md).
