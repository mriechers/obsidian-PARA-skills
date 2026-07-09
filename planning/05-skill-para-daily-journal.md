# 05 — Skill spec: `para-daily-journal`

Target: `skills/para-daily-journal/SKILL.md` + `references/JOURNAL-TEMPLATE.md`.
Facts: [00-vault-reference.md](00-vault-reference.md) §5.

Kept separate from `para-vault` deliberately: small skill, high blast-radius
protection — its description should trigger precisely on journal edits.

## Frontmatter (exact)

```yaml
---
name: para-daily-journal
description: Read and update daily journal notes that use HTML section markers for machine-injected content. Use when editing today's daily note, appending journal entries or tasks, injecting content into a journal section, or reading the daily journal folder.
---
```

## SKILL.md outline

1. **Where and what** — daily notes live in the journal folder (path in
   `../para-vault/references/VAULT-CONFIG.md` §5), named `YYYY-MM-DD.md`;
   H1 is the long date (`# Wednesday, July 8`); frontmatter per the contract
   plus a `generated_sections` hook.
2. **Filename = scheduled date** — any `- [ ]` task in a daily note is
   scheduled for that date automatically (see `para-tasks`).
3. **The section-marker protocol (SAFETY-CRITICAL)** — sections are callouts
   wrapped in `<!-- SECTION:<name>:START -->` / `<!-- SECTION:<name>:END -->`
   pairs. Rules:
   - Write ONLY between the target section's own START/END markers.
   - NEVER delete, rename, duplicate, or reorder markers.
   - NEVER modify other sections' content — an automated briefing engine owns
     injection and diffs against these markers.
   - Preserve the callout `> ` prefix on every line inside a callout; keep
     collapsed-callout syntax (`[!info]-`) intact.
4. **Section catalog** — table of section names and their callout types lives in
   VAULT-CONFIG §5; agent-facing notes usually belong in the agent-checkin
   section; free-form human notes go under the H1 prompt area, outside all
   markers.
5. **Appending an entry safely** — worked example: locate `END` marker of the
   target section, insert above it, keep `> ` prefixes.
6. Standalone-install caveat (needs `para-vault`).

## references/JOURNAL-TEMPLATE.md

Annotated snapshot of the journal template structure: full skeleton with every
callout + marker pair (from 00 §5's table), annotations explaining which
automation writes each section and what an agent may touch. Mark it as a
structural reference — the live template in the vault is authoritative.

## Overlap rules

- Callout syntax details → `obsidian-markdown` (CALLOUTS.md).
- Task syntax → `para-tasks`. Frontmatter → `para-vault`.

## Acceptance checklist

- [ ] Frontmatter exactly `name` + `description`; `name` == dir name.
- [ ] Marker rules stated as MUST/NEVER; example append shown.
- [ ] Section names cited from VAULT-CONFIG (reference file may snapshot them).
- [ ] Links resolve; ≤ ~120 lines (this one should be short).
