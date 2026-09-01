# VAULT-CONFIG — MarkBrain

The single source of truth for every vault-specific value the `para-*` skills
rely on. SKILL.md teaches generic PARA patterns; this file binds them to this
vault. Sibling skills cite it as `../para-vault/references/VAULT-CONFIG.md` — if a
sibling was installed standalone (per-skill copiers like `npx skills`), install
`para-vault` too so this file resolves.

## 1. Vault identity

- Name: **MarkBrain**. Path: `/Users/mriechers/MarkBrain` (case-sensitive).
- Synced across machines with **Syncthing**. Conflict duplicates are named
  `*sync-conflict-YYYYMMDD-*.md` (concentrated in `2 - AREAS/INTERNET CLIPPINGS`)
  — **never edit or index them**. Deletions propagate, so they are fine for
  scratch files.
- **Excluded from every grep / index / walk:**
  - `.agent-toolkit/` at vault root — a scraped documentation cache + intel dir,
    **not vault content**.
  - `.obsidian/` — config and plugins.
  - `.stfolder/`, `.stignore` — Syncthing's.

## 2. PARA folders

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

- Daily journal: `0 - INBOX/DAILY JOURNAL/`. Templates: `3 - RESOURCES/TEMPLATES/`.
- Internet clippings live under a `2 - AREAS/INTERNET CLIPPINGS/YYYY/MM/DD` date
  tree.
- Investigation subfolders under `2 - AREAS/INVESTIGATIONS/*/` use `README.md` as
  their folder-index note. Same-named "folder notes" are not used; `.base` files
  are the index/MOC layer.

## 3. Frontmatter values

Shared with the `/add-to-inbox` skill and the vault-courier service — any note an
agent creates must follow it. Property *syntax* → [obsidian-markdown](../../obsidian-markdown/SKILL.md);
worked examples → [FRONTMATTER.md](FRONTMATTER.md).

- **`tags`**: the **first tag is always `all`** (the universal anchor); then
  lowercase kebab-case topical tags.
- **`created`**: `YYYY-MM-DD`, sometimes `YYYY-MM-DD HH:mm`.
- **`para`** (derived cache — **the folder is ground truth**):
  `inbox | projects | areas | resources | archive`. quick-para computes this from
  the note's path and overwrites it; hand-editing it is reverted on the next
  pass *and* forges a `para_history` entry. Drift is real but rare (~70 notes,
  1.4%) and self-heals on reconciliation. The `.base` index views filter on
  `para`, so a drifted note is misfiled there until then — fix it by moving the
  file. See SKILL.md, "The folder is ground truth".
- **`status`** (projects/areas) — observed vocabulary: `active`, `unprocessed`,
  `incubating`, `draft`, `waiting`, `parked`, `ready`, `prototyping`,
  `processed`, `planning`.
- **`para_history`** (~1,955 notes, 3,254 usable entries): append-only audit of
  PARA moves, written by the quick-para plugin — **agents never hand-edit it**
  (schema in [FRONTMATTER.md](FRONTMATTER.md)). **Treat it as noisy**: measured
  2026-09-01, **71% of entries come from bulk reconciliation, not movement** —
  ten machine-written bursts, the largest 1,323 identical `areas → resources`
  entries inside one minute. Also: `date` is UTC and disagrees with US/Central
  after ~19:00 (derive the local day from `timestamp`); values are dirty in
  places (`from: project`, `from: 1 - PROJECTS`); sync-conflict copies duplicate
  entries; and deletes, renames, merges, and first classifications are never
  recorded at all.
- Occasional fields: `type` (e.g. `recollection`), `description` / `summary`
  (surfaced as Bases columns), `source` (URL or producer name — vault-courier
  always adds it), `title`, `week_of`, `generated_sections` (journal hook).
- Readwise / clipping notes add: `content-type`, `intake`, `creator`,
  `published`, `sender`, `share-url`.
- **Unused** — do not add: `aliases` (0 hits in PARA folders), `node_type` (0 hits).
- **Filenames**: Title Case; sanitize `/\:*?"<>|`; on collision append ` (2)`,
  ` (3)`.

## 4. Templates map

- Engine: **Templater** (`templater-obsidian`), `trigger_on_file_creation: true`.
  Core Templates plugin disabled. Template dir: `3 - RESOURCES/TEMPLATES/` (user
  scripts in `TEMPLATES/scripts/`).
- Folder → template map (from `.obsidian/plugins/templater-obsidian/data.json`):

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
  `projects-template.md` adds `status: active`. `coding-project-template.md` tags
  `[all, coding-projects]` and adds `## Research` and `## Notes from agents` with
  `<!-- AGENT NOTES START/END -->` markers.
- Folder-templates fire on **in-app file creation**. Firing on REST-API-created
  files is unconfirmed — until confirmed, notes created outside the app must carry
  the full frontmatter contract (§3) themselves.

## 5. Daily journal

- Location `0 - INBOX/DAILY JOURNAL/`, filename `YYYY-MM-DD.md` (~138 notes;
  cadence subfolders `3 - DAILY`, `2- WEEKLY`, `1 - MONTHLY` also exist).
- Because Tasks sets `useFilenameAsScheduledDate: true`, the filename **is** the
  scheduled date for any task in the note.
- Structure (from `journal-template.md`): frontmatter (`tags: [all, daily-journal]`,
  `created`, `para: inbox`, `generated_sections: ""`), H1 `# Wednesday, July 8`
  (`dddd, MMMM D`), a "*What's on your mind this morning?*" free-form prompt area,
  then callout sections each wrapped in HTML-comment markers the briefing engine
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
  strictly BETWEEN a section's own markers; markers are never deleted or
  reordered; callout `> ` line prefixes must be preserved. `generated_sections` is
  the journal's injection hook.

## 6. Kanban

- Plugin: obsidian-kanban v2.0.51 + kanban-tag-sync. A board is a markdown file
  with `kanban-plugin: board` frontmatter (older docs say `basic`; live boards use
  `board`). Lanes are `## Heading` sections; cards are checklist items.
- Master board: **`0 - INBOX/Project Dashboard.md`** (frontmatter:
  `kanban-plugin: board`, `tags: [all]`, `para: inbox`). quick-para's
  `projectUpdates.kanbanFile` points here. Actual lane order (verified
  2026-09-01):
  `INBOX` → `NOPE` → `THIS WEEK - MEETINGS AND CALLS` →
  `THIS WEEK - QUICK WINS` → `THIS WEEK - DEEP FOCUS` → `THIS WEEKEND` →
  `TOMORROW` → `TODAY` → `DOING` → `Done` → `Archive`.
- **`NEXT WEEK/HOLD`, `NOPE - SOMEONE ELSE'S PROBLEM`, and
  `SOMEDAY - IS THIS STILL A PRIORITY?` are not lanes.** They are hand-typed
  **divider cards** inside the single `## NOPE` lane, written as
  `- [ ] ### Next week/hold`, `- [ ] ### Someday - still a priority?`, and
  `- [ ] ### Someone else's problem`. A parser must treat a card whose text
  begins with `###` as a section marker, not a note reference. None of the
  parked cards carry an `@{date}` — the board's only eight date stamps are all
  in `Done`/`Archive` — so "how long has this been parked?" has to come from
  file mtime.
- Card grammar: `- [ ] [[Note Title]] #context-tag @{YYYY-MM-DD}`. Done cards
  carry `✅ YYYY-MM-DD`.
- Context hashtags: `#pbswi`, `#me`, `#wonder-cabinet`, `#freelance-biz`,
  `#job-search`, `#backburner`, `#casi`, `#wpm`, `#pd`, `#coding-projects`
  (color/sort priority defined in the board's `%% kanban:settings %%` block).
- Plugin settings (`.obsidian/plugins/obsidian-kanban/data.json`): new-card notes
  → `0 - INBOX` with `3 - RESOURCES/TEMPLATES/default-template.md`;
  `move-task-metadata: true`, `move-tags: true`, `tag-action: kanban`,
  `show-relative-date: true`, `archive-with-date: true`, `max-archive-size: 30`.
- `kanban-tag-sync` keeps card hashtags ↔ note tags in sync — hashtag edits on
  cards propagate to notes; choose deliberately.

## 7. Tasks

- Plugin: obsidian-tasks-plugin v7.23.1, format `tasksPluginEmoji`: `📅` due,
  `⏳` scheduled, `➕` created, `✅` done, `🔁` recurrence; priorities `🔺` highest
  `⏫` high `🔼` medium `🔽` low `⏬` lowest.
- **No global filter** (`globalFilter` empty): EVERY `- [ ]` checkbox in the vault
  is a task — agents must not write casual checkbox lists.
- `useFilenameAsScheduledDate: true`; `removeScheduledDateOnRecurrence: true`;
  auto-set created/done/cancelled dates (`setCreatedDate` / `setDoneDate` /
  `setCancelledDate: true`).
- Custom statuses beyond ` `/`x`: `/` In Progress, `-` Cancelled, `>` Rescheduled,
  `<` Scheduled, `!` Important, `?` Question, `*` Star, `n` Note, `l` Location,
  `i` Information, `I` Idea, `S` Amount.
- Kanban's `@{YYYY-MM-DD}` trailing dates also appear on card-tasks.

Canonical query shapes (reuse verbatim; do not invent variants):

**Per-note rollup** (embedded in the default/project/area/archive templates):

````
```tasks
path includes {{query.file.path}}
not done
sort by due
sort by priority
```
````

**"Today" board query** (kanban + chores templates):

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

**Per-PARA-folder rollup** (parallel blocks exist for `2 - AREAS` and
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

## 8. REST API

- Plugin: obsidian-local-rest-api v3.6.1. **HTTPS only on port `27124`.**
- Self-signed certificate → clients use `curl -k` (or pin the cert).
- Auth: `Authorization: Bearer <API key>`. **Key retrieval: 1Password `op` CLI**
  (v2.34.1 at `/opt/homebrew/bin/op`), personal account `my.1password.com`:

  ```
  op://Workspace-Personal/Obsidian Local REST API Key/credential
  ```

  Retrieve into a shell variable — never echo the key into logs or output:

  ```
  KEY="$(op read 'op://Workspace-Personal/Obsidian Local REST API Key/credential')"
  ```

  The item is an API Credential; the key is its `credential` field. If `op`
  reports multiple accounts, add `--account my.1password.com` (or set
  `OP_ACCOUNT`); the vault name is currently unambiguous so the bare reference
  resolves too.

- Known-good calls (from `/add-to-inbox` + vault-courier usage):
  - Health: `GET https://localhost:27124/` (also `127.0.0.1`).
  - Create/replace: `PUT /vault/<url-encoded vault path>.md` with a markdown body
    (e.g. `PUT /vault/0%20-%20INBOX/My%20Note.md`) — paths with spaces MUST be
    URL-encoded.
- Desktop-only plugin; Obsidian must be running. **Fallback** when it isn't:
  direct file write to `/Users/mriechers/MarkBrain/0 - INBOX/` honoring the
  frontmatter contract (§3). Command details → [para-rest-api](../../para-rest-api/SKILL.md).

## 9. Related automation

- **quick-para** plugin (custom): `para` property is authoritative
  (`tagging.propertyName: "para"`); writes `para_history`; auto-cancels open tasks
  when a note is archived (`tasks.autoCancelOnArchive: true`); project updates flow
  to `0 - INBOX/Project Dashboard.md`.
- **Dataview is installed but DISABLED** — skills must **never** suggest Dataview
  queries. **Bases** (`.base`) is the index layer; all Base views filter on the
  `para` property. Index files: `1 - PROJECTS/PROJECT INDEX.base`,
  `2 - AREAS/AREAS INDEX.base`, `3 - RESOURCES/RESOURCE INDEX.base`,
  `4 - ARCHIVE/2026/ARCHIVE INDEX.base`, `0 - INBOX/Recently Saved.base`.
  `.base` syntax → [obsidian-bases](../../obsidian-bases/SKILL.md).
- **second-brain** plugin (custom): status panel / briefing trigger / inbox
  digest; the briefing engine owns journal section injection (§5).
- **Contract consumers** (keep aligned): the `/add-to-inbox` skill and
  **vault-courier** (renders the frontmatter contract + `source:` field, drains
  queued notes into the vault every 15 min via a systemd timer on the homelab).
- Other enabled plugins for context: better-word-count, cmdr, readwise-official,
  ribbon-snippets, syncthing-integration. Installed-but-disabled: dataview,
  buttons, galaxy-brain, omnisearch, obsidian-meta-bind-plugin,
  obsidian-toggl-integration.
