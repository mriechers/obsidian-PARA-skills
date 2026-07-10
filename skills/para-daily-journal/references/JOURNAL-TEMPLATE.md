# JOURNAL-TEMPLATE (annotated structural reference)

A snapshot of the daily-note skeleton from `journal-template.md`, annotated with
which automation writes each part and what an agent may touch. **Structural
reference only** — the live template in the vault (`3 - RESOURCES/TEMPLATES/journal-template.md`)
is authoritative; if the two disagree, trust the vault. Section names, callout
types, and values here mirror
[`../../para-vault/references/VAULT-CONFIG.md`](../../para-vault/references/VAULT-CONFIG.md) §5, which is the source of
truth for the catalog.

## Ownership at a glance

- **Human** — the free-form prompt area under the H1.
- **Agent** — appends into the `agent-checkin` section only, unless the user asks
  otherwise.
- **Briefing engine** (second-brain plugin) — owns every marked section; it
  injects *between* the markers and diffs against them. Don't hand-edit these.

Editing rules for any marked section are in [`../SKILL.md`](../SKILL.md) (the
section-marker protocol): write only between a section's own START/END markers;
never delete, rename, reorder, or duplicate a marker; keep the `> ` prefixes and
the `[!info]-` collapse syntax intact.

## Skeleton

The `←` lines are annotations, **not part of the file**.

```markdown
---
tags: [all, daily-journal]
created: 2026-07-08
para: inbox
generated_sections: ""
---

# Wednesday, July 8

*What's on your mind this morning?*
                         ← free-form; HUMAN writes here, outside all markers

<!-- SECTION:alignment:START -->
> [!warning] Alignment
<!-- SECTION:alignment:END -->
                         ← briefing engine: today's focus / alignment

<!-- SECTION:agenda:START -->
> [!example] Agenda
<!-- SECTION:agenda:END -->
                         ← briefing engine: calendar / agenda

<!-- SECTION:pulse:START -->
> [!tip] Pulse
<!-- SECTION:pulse:END -->
                         ← briefing engine: daily pulse

<!-- SECTION:monthly-checkup:START -->
> [!info]- Monthly Checkup
<!-- SECTION:monthly-checkup:END -->
                         ← briefing engine; collapsed by default (trailing `-`)

<!-- SECTION:comms:START -->
> [!info]- Comms
<!-- SECTION:comms:END -->
                         ← briefing engine; collapsed

<!-- SECTION:tasks:START -->
> [!todo]- Task Radar
<!-- SECTION:tasks:END -->
                         ← briefing engine; collapsed

<!-- SECTION:projects:START -->
> [!abstract]- Project Radar
<!-- SECTION:projects:END -->
                         ← briefing engine; collapsed

<!-- SECTION:wins:START -->
> [!success]- Recent Wins
<!-- SECTION:wins:END -->
                         ← briefing engine; collapsed

<!-- SECTION:agent-checkin:START -->
> [!danger]- What the agents did at school today
<!-- SECTION:agent-checkin:END -->
                         ← AGENT appends here (see SKILL.md); collapsed
```

Section order and callout types above are the snapshot as of the reference date;
re-read the live template if a section appears missing or renamed, and keep
VAULT-CONFIG §5 as the authoritative catalog.
