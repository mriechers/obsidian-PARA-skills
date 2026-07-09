# 01 — Skill spec: `para-vault` (flagship)

Target: `skills/para-vault/SKILL.md` + `references/VAULT-CONFIG.md` +
`references/FRONTMATTER.md`. Facts: [00-vault-reference.md](00-vault-reference.md).

## Frontmatter (exact)

```yaml
---
name: para-vault
description: Work with a PARA-organized Obsidian vault: folder structure, the para frontmatter property as ground truth, tag and status conventions, templates, and routing between file edits, CLI, and REST API. Use when creating, moving, filing, or classifying notes in a PARA vault, or before any other vault operation.
---
```

## SKILL.md outline (~120 lines, generic PARA — no hardcoded vault values)

1. **PARA in one paragraph** — Inbox/Projects/Areas/Resources/Archive as
   numbered top-level folders; an Outbox extension may exist.
2. **Read the config first** — every vault-specific value (paths, folder names,
   tag vocab, ports) lives in [references/VAULT-CONFIG.md](#vault-config) —
   read it before acting. State plainly: this skill's rules are generic; the
   config is the binding source for this vault.
3. **The `para` property is ground truth** — PARA membership = frontmatter
   `para` value (inbox/projects/areas/resources/archive), not folder location;
   folders can drift; index views (Obsidian Bases) filter on `para`.
4. **Frontmatter contract** — anchor-tag-first `tags` list, `created` date,
   `para`, optional `status` (vocab in config), `para_history` is append-only
   and plugin-written — never hand-edit. Defer YAML/properties syntax to the
   `obsidian-markdown` skill (its PROPERTIES.md reference).
5. **Moving notes between PARA categories** — update `para`; the vault's
   automation (quick-para) maintains `para_history` and auto-cancels open tasks
   on archive; never just move the file and call it done.
6. **Creating notes** — in-app creation gets folder-templates automatically;
   out-of-app creation (direct write, REST API) must apply the matching template
   content and full frontmatter contract manually (template map in config).
7. **Hygiene rules** — never index/grep the config's excluded dirs; never edit
   sync-conflict files; NEVER suggest Dataview (disabled in this vault) — Bases
   is the index layer (defer syntax to `obsidian-bases`).
8. **Access-method routing table**:

   | Situation | Method |
   |---|---|
   | Bulk/offline edits, agent has filesystem | direct file edit |
   | Obsidian running, want app-side effects (templates, daily notes) | `obsidian-cli` skill |
   | Programmatic create/read over HTTP, Obsidian running | `para-rest-api` skill |
9. **Sibling skills** — one line each pointing at `para-tasks`, `para-kanban`,
   `para-rest-api`, `para-daily-journal`.

## references/VAULT-CONFIG.md {#vault-config}

THE single vault-specific file. Sibling skills cite it as
`../para-vault/references/VAULT-CONFIG.md` and carry the note: *"if this skill
was installed standalone (per-skill copiers like `npx skills`), install
`para-vault` too."* Nine H2 sections, values copied verbatim from
[00-vault-reference.md](00-vault-reference.md):

1. **Vault identity** — name, path, Syncthing (`*sync-conflict-*` = never edit),
   exclusions (`.agent-toolkit/`).
2. **PARA folders** — exact numbered folder names incl. `5 - OUTBOX`,
   DAILY JOURNAL and TEMPLATES locations, INTERNET CLIPPINGS date tree.
3. **Frontmatter values** — `all`-first tag rule, kebab-case topics, `para`
   enum, `status` vocabulary, unused fields (aliases, node_type), vault-courier's
   `source:` field, filename sanitization rules.
4. **Templates map** — the full folder→template table (00 §4).
5. **Daily journal** — path/filename pattern, H1 format, full section-marker
   table (00 §5), `generated_sections` hook.
6. **Kanban** — master board path, full lane order, context hashtag vocabulary,
   plugin settings that matter (new-card folder/template, tag-action, tag-sync).
7. **Tasks** — settings (no global filter, filename-as-scheduled-date, auto
   dates), custom status characters, the three canonical queries VERBATIM (00 §7).
8. **REST API** — port 27124 HTTPS-only, `curl -k`, `op` CLI key retrieval
   (exact `op://` ref — resolve at build time; see 11-open-questions), known
   endpoints, desktop-only + fallback.
9. **Related automation** — quick-para behaviors, Dataview-disabled rule, Bases
   index files, /add-to-inbox + vault-courier as contract consumers.

## references/FRONTMATTER.md

Worked, copy-paste-ready frontmatter examples: one per PARA type (inbox capture,
project w/ `status`, area, resource w/ `type`, archived note), the daily-journal
frontmatter, a clipping/Readwise note, and the `para_history` entry schema with
the "plugin-written, never hand-edit" warning. Source all from 00 §3/§5.

## Overlap rules

- No wikilink/callout/properties syntax here → `obsidian-markdown`.
- No `.base` syntax → `obsidian-bases`; this skill only states "Bases = index
  layer, Dataview = forbidden".
- No CLI/REST command details → `obsidian-cli` / `para-rest-api`.

## Acceptance checklist

- [ ] Frontmatter has exactly `name` + `description`; `name` == dir name.
- [ ] SKILL.md ≤ ~150 lines; zero Mark-specific values outside references/.
- [ ] VAULT-CONFIG.md contains all nine sections with values matching 00.
- [ ] All relative links resolve; no mention of Dataview except the prohibition.
- [ ] No Keychain retrieval anywhere; `op` CLI only.
