# 03 — Skill spec: `para-kanban`

Target: `skills/para-kanban/SKILL.md` + `references/BOARDS.md`.
Facts: [00-vault-reference.md](00-vault-reference.md) §6.

## Frontmatter (exact)

```yaml
---
name: para-kanban
description: Read and edit Obsidian Kanban plugin boards: markdown files with kanban-plugin frontmatter, lanes as headings, and cards as checklist items with wikilinks, context hashtags, and @{date} syntax. Use when adding cards, moving cards between lanes, or editing kanban board files, especially a PARA project dashboard.
---
```

## SKILL.md outline

1. **Board anatomy** — a board is plain markdown: `kanban-plugin: board`
   frontmatter, lanes as `## Heading`, cards as `- [ ]` items, `%% kanban:settings %%`
   JSON block at the bottom. Edit as markdown; preserve blank-line spacing
   between lane sections.
2. **Card grammar** — `- [ ] [[Note Title]] #context-tag @{YYYY-MM-DD}`;
   done cards gain `✅ YYYY-MM-DD`. Context hashtags act as project/context
   routing labels (vocabulary in config).
3. **Lane lifecycle pattern** — inbox lane → scheduling lanes → today/doing →
   done → archive; the vault's master dashboard lane order is in
   `../para-vault/references/VAULT-CONFIG.md` §6.
4. **Tag sync caution** — a tag-sync companion plugin propagates card hashtags
   to the linked notes' tags (and `move-tags` rewrites tags on lane moves) —
   add/remove hashtags deliberately.
5. **Every card is a task** — no global Tasks filter in this vault, so cards
   appear in task queries; see `para-tasks` for date/priority emoji semantics.
6. **New-card side effects** — creating a card with a wikilink to a nonexistent
   note spawns a backing note per plugin settings (folder + template in config).
7. **Master-dashboard care** — the dashboard is also written to by vault
   automation (quick-para project updates); edit conservatively, never
   restructure lanes without being asked.
8. Standalone-install caveat (needs `para-vault`).

## references/BOARDS.md

- A complete minimal example board (frontmatter, two lanes, cards, settings
  block) safe to copy.
- Master-dashboard semantics: what each lane means (from config lane order),
  card lifecycle walk-through (captured → scheduled → today → doing → done →
  archive with date).
- Safe-edit rules: append cards at lane end; don't touch `%% kanban:settings %%`
  unless asked; archive section format (`archive-with-date` on).

## Overlap rules

- Wikilink syntax → `obsidian-markdown`. Task emoji/queries → `para-tasks`.

## Acceptance checklist

- [ ] Frontmatter exactly `name` + `description`; `name` == dir name.
- [ ] Card grammar shown with a verbatim example.
- [ ] Tag-sync and every-card-is-a-task warnings present.
- [ ] Lane names cited from VAULT-CONFIG, not hardcoded in SKILL.md.
- [ ] Links resolve; ≤ ~150 lines.
