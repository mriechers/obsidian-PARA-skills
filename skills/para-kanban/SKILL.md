---
name: para-kanban
description: "Read and edit Obsidian Kanban plugin boards: markdown files with kanban-plugin frontmatter, lanes as headings, and cards as checklist items with wikilinks, context hashtags, and @{date} syntax. Use when adding cards, moving cards between lanes, or editing kanban board files, especially a PARA project dashboard."
---

# PARA Kanban Skill

Read and edit Obsidian **Kanban plugin** boards as plain markdown. This skill
teaches the board format and safe-edit workflow; every vault-specific value —
the master board path, the full lane order, and the context-hashtag vocabulary —
lives in [../para-vault/references/VAULT-CONFIG.md](../para-vault/references/VAULT-CONFIG.md) §6.
Read that section before editing a real board. Worked example and dashboard
semantics are in [references/BOARDS.md](references/BOARDS.md).

## Board anatomy

A board is a normal markdown file — nothing binary. It has four parts:

- **Frontmatter** with `kanban-plugin: board` (older docs say `basic`; live
  boards use `board`). The board also carries the usual note frontmatter.
- **Lanes** are `## Heading` sections, one per column, in left-to-right order.
- **Cards** are `- [ ]` checklist items under a lane heading.
- A trailing `%% kanban:settings %%` block holding the board's JSON config
  (lane colors, sort, hashtag priorities).

Edit it as markdown. **Preserve the blank-line spacing** between lane sections
and leave the settings block untouched unless asked to change board config.

## Card grammar

A card is one checklist line:

```
- [ ] [[Note Title]] #context-tag @{YYYY-MM-DD}
```

- `[[Note Title]]` — a wikilink to the backing note. Wikilink *syntax* →
  [obsidian-markdown](../obsidian-markdown/SKILL.md).
- `#context-tag` — a **context hashtag** that routes the card to a project or
  context (color/sort priority set in `%% kanban:settings %%`). Use only the
  vocabulary listed in VAULT-CONFIG §6 — do not invent tags.
- `@{YYYY-MM-DD}` — the Kanban date. It also renders as a task date; emoji/query
  semantics → [para-tasks](../para-tasks/SKILL.md).

Done cards gain a trailing `✅ YYYY-MM-DD`:

```
- [x] [[Note Title]] #context-tag @{YYYY-MM-DD} ✅ YYYY-MM-DD
```

## Lane lifecycle pattern

Cards flow left to right: an **inbox** lane (un-triaged capture) → **scheduling**
lanes (this week / someday / hold) → **today / doing** → **done** → **archive**.
The master dashboard's exact lane names and order are in VAULT-CONFIG §6 — cite
them from there; **never hardcode the lane list here**. To move a card, cut its
line from one lane and append it under the target lane heading (append at the
lane's end).

## Tag-sync caution

A companion plugin (**kanban-tag-sync**) keeps card hashtags in sync with the
linked notes' tags: a hashtag you add to or remove from a card **propagates to
the backing note's frontmatter tags**. Moving a card between lanes can also
rewrite tags when `move-tags` is on. **Add or remove card hashtags
deliberately** — an edit here is an edit to the note.

## Every card is a task

This vault has **no global Tasks filter**, so *every* `- [ ]` checkbox — every
Kanban card included — is indexed as a live task and shows up in task queries.
Don't add throwaway checkbox cards you don't mean as tasks. Date/priority emoji
and query semantics live in [para-tasks](../para-tasks/SKILL.md).

## New-card side effects

Creating a card whose `[[wikilink]]` points at a **nonexistent** note makes the
plugin spawn a backing note when the link is followed — into the new-card folder
using the template named in VAULT-CONFIG §6. If you only want a card and not a
new note, link an existing note.

## Master-dashboard care

The master board is also written by vault automation (quick-para pushes project
updates into it). **Edit conservatively**: append or move individual cards, but
**never restructure, rename, or reorder lanes** unless explicitly asked. Don't
touch the `%% kanban:settings %%` block. Treat the lane skeleton as owned by the
automation.

## Standalone-install caveat

This skill depends on `para-vault` for its config: the lane order, board path,
hashtag vocabulary, and plugin settings all resolve through
[../para-vault/references/VAULT-CONFIG.md](../para-vault/references/VAULT-CONFIG.md).
If a per-skill installer pulled `para-kanban` in on its own, install `para-vault`
too so that path resolves.
