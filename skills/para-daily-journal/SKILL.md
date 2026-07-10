---
name: para-daily-journal
description: "Read and update daily journal notes that use HTML section markers for machine-injected content. Use when editing today's daily note, appending journal entries or tasks, injecting content into a journal section, or reading the daily journal folder."
---

# PARA Daily Journal

Read and edit daily notes in this PARA vault. Daily notes carry **HTML section
markers** that an automated briefing engine (the second-brain plugin) injects
into — edit them wrong and you silently corrupt the next briefing. Treat this
skill as safety-critical.

Vault-specific values (journal folder, filename pattern, H1 format, the full
section catalog, the `generated_sections` hook) live in
[`../para-vault/references/VAULT-CONFIG.md`](../para-vault/references/VAULT-CONFIG.md) §5 — cite it, don't re-derive.
Annotated skeleton: [`references/JOURNAL-TEMPLATE.md`](references/JOURNAL-TEMPLATE.md).

Defer callout syntax to [`../obsidian-markdown`](../obsidian-markdown/SKILL.md)
(its CALLOUTS.md), task syntax to [`../para-tasks`](../para-tasks/SKILL.md), and
frontmatter to [`../para-vault`](../para-vault/SKILL.md).

## Where and what

- Daily notes live in the journal folder (path in VAULT-CONFIG §5), one file per
  day named `YYYY-MM-DD.md`.
- H1 is the long date — `# Wednesday, July 8` (`dddd, MMMM D`).
- Frontmatter follows the contract (`tags: [all, daily-journal]`, `created`,
  `para: inbox`) plus a `generated_sections: ""` hook the briefing engine reads.
  Exact values: VAULT-CONFIG §5.
- Under the H1 is a free-form "*What's on your mind this morning?*" prompt area,
  then a stack of callout sections wrapped in markers (below).

## Filename = scheduled date

The filename **is** the scheduled date: because Tasks sets
`useFilenameAsScheduledDate`, any `- [ ]` task you add to a daily note is
scheduled for that date automatically — no `⏳` needed. Every `- [ ]` is a live
task vault-wide, so never write casual checkboxes here. See
[`../para-tasks`](../para-tasks/SKILL.md).

## The section-marker protocol (SAFETY-CRITICAL)

Each callout section is wrapped in a marker pair:

```
<!-- SECTION:<name>:START -->
> [!type] Title
> …callout body…
<!-- SECTION:<name>:END -->
```

The briefing engine owns injection and **diffs against these markers**. You MUST
obey every rule:

- **MUST** write only *between* the target section's own `START` and `END`
  markers.
- **NEVER** delete, rename, duplicate, or reorder any marker.
- **NEVER** modify a section you were not asked to touch — the engine may
  overwrite or conflict on the next briefing.
- **MUST** keep the callout `> ` prefix on every line inside a callout, blank
  lines included (write them as `>`).
- **MUST** preserve collapsed-callout syntax (`[!info]-`) exactly — the trailing
  `-` means collapsed-by-default; don't drop it or flip it to `+`.
- **NEVER** add content above the first marker or between sections, except in the
  free-form prompt area under the H1.

## Section catalog

The full table of section names ↔ callout types is in VAULT-CONFIG §5 and is
snapshotted with annotations in
[`references/JOURNAL-TEMPLATE.md`](references/JOURNAL-TEMPLATE.md). Routing:

- **Agent-written notes** usually belong in the **`agent-checkin`** section
  (`> [!danger]- What the agents did at school today`).
- **Free-form human notes** go under the H1 prompt area, *outside* all markers.
- Briefing-owned sections (alignment, agenda, pulse, the radars, …) belong to the
  engine — leave them to it unless the user explicitly asks otherwise.

## Appending an entry safely

To add a line to a section (example: `agent-checkin`):

1. Locate that section's own `<!-- SECTION:agent-checkin:END -->` marker.
2. Insert your line **above** the END marker, below the existing body.
3. Prefix every inserted line with `> ` so it stays inside the callout.

Before → after:

```
<!-- SECTION:agent-checkin:START -->
> [!danger]- What the agents did at school today
> - Filed 2 clippings to Resources.
<!-- SECTION:agent-checkin:END -->
```

becomes

```
<!-- SECTION:agent-checkin:START -->
> [!danger]- What the agents did at school today
> - Filed 2 clippings to Resources.
> - Archived the Q2 launch note.
<!-- SECTION:agent-checkin:END -->
```

The markers, the callout header, and the existing line are untouched; only a
`> `-prefixed line was inserted just before `END`.

## Standalone-install note

If you installed `para-daily-journal` on its own (per-skill copiers like
`npx skills`), also install **`para-vault`** so
[`../para-vault/references/VAULT-CONFIG.md`](../para-vault/references/VAULT-CONFIG.md) resolves — the journal path,
H1 format, and section catalog live there.
