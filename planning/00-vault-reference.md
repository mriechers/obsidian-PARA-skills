# 00 — Vault reference (single source of truth)

Verified against the live vault on 2026-07-09. Every other planning doc and the
shipped `skills/para-vault/references/VAULT-CONFIG.md` draw values from here —
copy from this file, never re-derive from the vault.

## 1. Vault identity

- Name: **MarkBrain**. Path: `/Users/mriechers/MarkBrain` (case-sensitive).
- Synced across machines with **Syncthing**. Conflict duplicates named
  `*sync-conflict-YYYYMMDD-*.md` exist (concentrated in INTERNET CLIPPINGS) —
  **never edit or index them**. Deletions propagate; fine for scratch files.
- `.agent-toolkit/` at vault root is a scraped documentation cache + intel dir —
  **not vault content**; exclude it from every grep/index/walk.
- `.obsidian/` holds config and plugins; `.stfolder`/`.stignore` are Syncthing's.

## 2. PARA folder layout

```
0 - INBOX/            capture + DAILY JOURNAL/ subfolder
1 - PROJECTS/         active projects; subfolders FREELANCE BIZ, JOB SEARCH, ME,
                      PBSWI, WONDER CABINET; PROJECT INDEX.base
2 - AREAS/            ongoing areas (many subfolders incl. MEETINGS, THERAPY,
                      INTERNET CLIPPINGS/YYYY/MM/DD date tree); AREAS INDEX.base
3 - RESOURCES/        ~40 topic subfolders incl. TEMPLATES/; RESOURCE INDEX.base
4 - ARCHIVE/          by year (2024/ 2025/ 2026/); 2026/ARCHIVE INDEX.base
5 - OUTBOX/           non-canonical addition; outbound drafts/pitches (sparse)
```

Investigation subfolders under `2 - AREAS/INVESTIGATIONS/*/` use `README.md` as
their folder-index note. Same-named "folder notes" are not used; `.base` files are
the index/MOC layer.

## 3. Frontmatter contract

Shared with the `/add-to-inbox` skill (the-lodge) and the vault-courier service —
any note an agent creates must follow it:

```yaml
---
tags:
  - all          # FIRST tag is always `all` (universal anchor)
  - some-topic   # then lowercase kebab-case topical tags
created: 2026-07-09          # YYYY-MM-DD, sometimes YYYY-MM-DD HH:mm
para: inbox                  # inbox | projects | areas | resources | archive
---
```

- **`para` is ground truth** for PARA membership — folder location can drift
  (real example: a note in `1 - PROJECTS/` carrying `para: resources`). The
  `.base` index views filter on `para`, not on folder.
- **`para_history`** (~1334 notes): append-only audit of PARA moves, written by
  the quick-para plugin — agents never hand-edit it. Entry schema:
  ```yaml
  para_history:
    - from: inbox
      to: areas
      date: 2026-07-02
      timestamp: 1783034439389
  ```
- **`status`** on projects/areas — observed vocabulary: `active`, `unprocessed`,
  `incubating`, `draft`, `waiting`, `parked`, `ready`, `prototyping`,
  `processed`, `planning`.
- Occasional fields: `type` (e.g. `recollection`), `description`/`summary`
  (surfaced as Bases columns), `source` (URL or producer name — vault-courier
  always adds it), `title`, `week_of`, `generated_sections` (journal hook).
- Readwise/clipping notes add: `content-type`, `intake`, `creator`, `published`,
  `sender`, `share-url`.
- **Unused**: `aliases` (0 hits in PARA folders), `node_type` (0 hits).
- Filenames: Title Case; sanitize `/\:*?"<>|`; collision → append ` (2)`, ` (3)`.

Verbatim samples from live notes:

```yaml
# Inbox capture (0 - INBOX/Notes for Claude.md)
tags: [all]
created: 2026-07-06 17:32
para: inbox

# Daily journal (0 - INBOX/DAILY JOURNAL/2026-07-08.md)
tags: [all, daily-journal]
para: inbox
created: 2026-07-08
generated_sections: ""

# Resource (3 - RESOURCES/Recollection - AI Agents Memory.md)
title: "Recollection: AI Agents and Memory Systems"
created: 2026-04-21
type: recollection
tags: [all, ai-memory, ai-agents, knowledge-management, recollection]
para: resources
```

## 4. Templates (Templater)

- Engine: **Templater** (`templater-obsidian`), `trigger_on_file_creation: true`.
  Core Templates plugin disabled. Template dir: `3 - RESOURCES/TEMPLATES/`
  (user scripts in `TEMPLATES/scripts/`).
- Folder→template map (from `.obsidian/plugins/templater-obsidian/data.json`):

| Folder | Template |
|---|---|
| `0 - INBOX` | `inbox-template.md` |
| `0 - INBOX/DAILY JOURNAL` | `journal-template.md` |
| `1 - PROJECTS - Action Needed` | `projects-template.md` |
| `1 - PROJECTS/CODING PROJECTS` | `coding-project-template.md` |
| `1 - PROJECTS/PBSWI/CHORES` | `PBSWI-dailies-weeklies-template.md` |
| `2 - AREAS - Tracking and Check-ins` | `areas-template.md` |
| `2 - AREAS/THERAPY` | `therapy-template.md` |
| `3 - RESOURCES` | `archive-template.md` |
| `3 - RESOURCES/VIPs` | `Important Details for NAME.md` |
| `4 - ARCHIVE` | `archive-template.md` |
| `/` (default) | `default-template.md` |

- The default/inbox/projects/areas/archive templates share a skeleton:
  frontmatter (`tags: [all]`, `created`) + `## 🗒 Tasks in this note` with the
  per-note rollup query (§7) + `## Resources` + `## Notes`.
  `projects-template.md` adds `status: active`. `coding-project-template.md`
  tags `[all, coding-projects]` and includes `## Research` ("For agents: these
  resources should be scraped…") and `## Notes from agents` with
  `<!-- AGENT NOTES START/END -->` markers.
- Folder-templates fire on **in-app file creation**. Whether they fire on
  REST-API-created files is unconfirmed — smoke test ② in
  [08-testing-spec.md](08-testing-spec.md) resolves it. Until then: notes created
  outside the app must carry the full frontmatter contract themselves.

## 5. Daily journal

- Location `0 - INBOX/DAILY JOURNAL/`, filename `YYYY-MM-DD.md` (~138 notes;
  cadence subfolders `3 - DAILY`, `2- WEEKLY`, `1 - MONTHLY` also exist).
- Because of Tasks' `useFilenameAsScheduledDate`, the filename IS the scheduled
  date for any task in the note.
- Structure (from `journal-template.md`): frontmatter
  (`tags: [all, daily-journal]`, `created`, `para: inbox`,
  `generated_sections: ""`), H1 `# Wednesday, July 8` (dddd, MMMM D), a
  "*What's on your mind this morning?*" free-form prompt area, then callout
  sections each wrapped in HTML comment markers the second-brain briefing engine
  injects into:

| Callout | Marker name |
|---|---|
| `> [!warning] Alignment` | `alignment` |
| `> [!example] Agenda` | `agenda` |
| `> [!tip] Pulse` | `pulse` |
| `> [!info]- Monthly Checkup` | `monthly-checkup` |
| `> [!info]- Comms` | `comms` |
| `> [!todo]- Task Radar` | `tasks` |
| `> [!abstract]- Project Radar` | `projects` |
| `> [!success]- Recent Wins` | `wins` |
| `> [!danger]- What the agents did at school today` | `agent-checkin` |

- Marker form: `<!-- SECTION:<name>:START -->` … `<!-- SECTION:<name>:END -->`.
  The `-` suffix on `[!info]-` means collapsed-by-default. Machine writes go
  strictly BETWEEN a section's own markers; markers are never deleted/reordered;
  callout `> ` line prefixes must be preserved.

## 6. Kanban (obsidian-kanban v2.0.51 + kanban-tag-sync)

- A board is a markdown file with `kanban-plugin: board` frontmatter (older docs
  say `basic`; live boards use `board`). Lanes are `## Heading` sections; cards
  are checklist items.
- Master board: **`0 - INBOX/Project Dashboard.md`** (frontmatter:
  `kanban-plugin: board`, `tags: [all]`, `para: inbox`). quick-para's
  `projectUpdates.kanbanFile` points here. Lane order:
  `INBOX` → `NEXT WEEK/HOLD` → `NOPE - SOMEONE ELSE'S PROBLEM` →
  `SOMEDAY - IS THIS STILL A PRIORITY?` → `THIS WEEK - MEETINGS AND CALLS` →
  `THIS WEEK - QUICK WINS` → `THIS WEEK - DEEP FOCUS` → `THIS WEEKEND` →
  `TOMORROW` → `TODAY` → `DOING` → `Done` → `Archive`.
- Card grammar: `- [ ] [[Note Title]] #context-tag @{YYYY-MM-DD}`.
  Context hashtags: `#pbswi`, `#me`, `#wonder-cabinet`, `#freelance-biz`,
  `#job-search`, `#backburner`, `#casi`, `#wpm`, `#pd`, `#coding-projects`
  (color/sort priority defined in the board's `%% kanban:settings %%` block).
  Done cards carry `✅ YYYY-MM-DD`.
- Plugin settings (`.obsidian/plugins/obsidian-kanban/data.json`): new-card
  notes → `0 - INBOX` with `3 - RESOURCES/TEMPLATES/default-template.md`;
  `move-task-metadata: true`, `move-tags: true`, `tag-action: kanban`,
  `show-relative-date: true`, `archive-with-date: true`, `max-archive-size: 30`.
- `kanban-tag-sync` keeps card hashtags ↔ note tags in sync — hashtag edits on
  cards propagate to notes; choose deliberately.

## 7. Tasks (obsidian-tasks-plugin v7.23.1)

- Format `tasksPluginEmoji`: `📅` due, `⏳` scheduled, `➕` created, `✅` done,
  `🔁` recurrence; priorities `🔺` highest `⏫` high `🔼` medium `🔽` low `⏬` lowest.
- **No global filter** (`globalFilter` empty): EVERY `- [ ]` checkbox in the
  vault is a task — agents must not write casual checkbox lists.
- `useFilenameAsScheduledDate: true`; `removeScheduledDateOnRecurrence: true`;
  auto-set created/done/cancelled dates (`setCreatedDate/setDoneDate/
  setCancelledDate: true`).
- Custom statuses beyond ` `/`x`: `/` In Progress, `-` Cancelled, `>`
  Rescheduled, `<` Scheduled, `!` Important, `?` Question, `*` Star, `n` Note,
  `l` Location, `i` Information, `I` Idea, `S` Amount.
- Kanban's `@{YYYY-MM-DD}` trailing dates also appear on card-tasks.
- Verbatim recurring-task samples:
  ```
  - [ ] Check schedule for bugs 🔁 every day ➕ 2026-07-03 📅 2026-07-04
  - [ ] [[Journal - Daily Process]] 🔁 every day ➕ 2026-07-03 📅 2026-07-04
  ```

Canonical query shapes (reuse verbatim; do not invent variants):

Per-note rollup (embedded in the default/project/area/archive templates):
````
```tasks
path includes {{query.file.path}}
not done
sort by due
sort by priority
```
````

"Today" board query (kanban + chores templates):
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

Per-PARA-folder rollup (parallel blocks exist for `2 - AREAS` and
`3 - RESOURCES` with `path does not include TEMPLATES`, and `4 - ARCHIVE`):
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

## 8. Local REST API (obsidian-local-rest-api v3.6.1)

- **HTTPS only** on **port 27124**; insecure HTTP port 27123 is DISABLED.
- Self-signed certificate → clients use `curl -k` (or pin the cert).
- Auth: `Authorization: Bearer <API key>`. **Key retrieval: 1Password `op` CLI**
  (v2.34.1 at `/opt/homebrew/bin/op`) — exact `op://<vault>/<item>/<field>`
  reference to be confirmed at build time (`op item list`). The Keychain
  retrieval documented in older ecosystem docs
  (`security find-generic-password -s 'developer.workspace.OBSIDIAN_LOCAL_REST_API_KEY' -w`)
  is **legacy — do not propagate**.
- Known-good calls (from /add-to-inbox + vault-courier usage):
  - Health: `GET https://localhost:27124/` (also 127.0.0.1)
  - Create/replace: `PUT /vault/<url-encoded vault path>.md` with markdown body
    (e.g. `PUT /vault/0%20-%20INBOX/My%20Note.md`) — paths with spaces MUST be
    URL-encoded.
- Desktop-only plugin; Obsidian must be running. Fallback when it isn't:
  direct file write to `/Users/mriechers/MarkBrain/0 - INBOX/` honoring the
  frontmatter contract (§3).

## 9. Related automation & hard rules

- **quick-para** plugin (custom): `para` property is authoritative
  (`tagging.propertyName: "para"`); writes `para_history`; auto-cancels open
  tasks when a note is archived (`tasks.autoCancelOnArchive: true`); project
  updates flow to `0 - INBOX/Project Dashboard.md`.
- **Dataview is installed but DISABLED** — skills must never suggest Dataview
  queries; **Bases** (`.base`) are the index layer: `1 - PROJECTS/PROJECT
  INDEX.base`, `2 - AREAS/AREAS INDEX.base`, `3 - RESOURCES/RESOURCE
  INDEX.base`, `4 - ARCHIVE/2026/ARCHIVE INDEX.base`, `0 - INBOX/Recently
  Saved.base` — all filter on the `para` property.
- **second-brain** plugin (custom): status panel / briefing trigger / inbox
  digest; the briefing engine owns journal section injection (§5).
- External consumers of the frontmatter contract (keep them aligned):
  - `/add-to-inbox` skill — canonical copy at
    `the-lodge/.claude/library/second-brain/skills/add-to-inbox/SKILL.md`
    (line 79 has the dangling `obsidian-vault` reference → becomes `para-vault`).
  - vault-courier — `second-brain/services/vault-courier/vault_courier/render.py`
    renders the contract + `source:` field; drains queued notes into the vault
    every 15 min via systemd timer on the homelab.
- Other enabled plugins for context: better-word-count, cmdr, readwise-official,
  ribbon-snippets, syncthing-integration. Installed-but-disabled: dataview,
  buttons, galaxy-brain, omnisearch, obsidian-meta-bind-plugin,
  obsidian-toggl-integration.
