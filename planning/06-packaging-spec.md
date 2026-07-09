# 06 — Packaging spec (single plugin, extended)

Locked decision: extend the existing `obsidian` plugin rather than adding a
second one. New skills are sibling dirs in `skills/`; upstream skill dirs stay
byte-identical; packaging JSONs and README are the only rebranded files.

## Target directory layout

```
obsidian-PARA-skills/
├── .claude-plugin/
│   ├── marketplace.json      ← rebranded (below)
│   └── plugin.json           ← rebranded (below)
├── LICENSE                   ← UNTOUCHED (MIT, kepano)
├── README.md                 ← rewritten per 07-readme-spec.md
├── planning/                 ← these docs
├── tests/
│   └── validate.sh           ← per 08-testing-spec.md
└── skills/
    ├── defuddle/             ← upstream, byte-identical
    ├── json-canvas/          ← upstream, byte-identical
    ├── obsidian-bases/       ← upstream, byte-identical
    ├── obsidian-cli/         ← upstream, byte-identical
    ├── obsidian-markdown/    ← upstream, byte-identical
    ├── para-vault/           ← NEW (flagship + VAULT-CONFIG)
    ├── para-tasks/           ← NEW
    ├── para-kanban/          ← NEW
    ├── para-rest-api/        ← NEW
    └── para-daily-journal/   ← NEW
```

## `.claude-plugin/marketplace.json` (exact target content)

Marketplace renamed `obsidian-skills` → **`obsidian-para-skills`**: avoids a
name collision if upstream's marketplace is ever added on the same machine, and
matches the repo name. Install string becomes
`/plugin install obsidian@obsidian-para-skills`.

```json
{
  "name": "obsidian-para-skills",
  "owner": {
    "name": "Mark Riechers",
    "url": "https://github.com/mriechers"
  },
  "plugins": [
    {
      "name": "obsidian",
      "source": "./",
      "description": "Claude Skills for Obsidian — upstream skills by Steph Ango (kepano) plus PARA vault workflow skills",
      "version": "2.0.0"
    }
  ]
}
```

## `.claude-plugin/plugin.json` (exact target content)

Version **2.0.0** — major bump: identity change + five new skills.

```json
{
  "name": "obsidian",
  "version": "2.0.0",
  "description": "Create and edit Obsidian vault files including Markdown, Bases, and Canvas, plus PARA vault workflow skills for tasks, kanban, the Local REST API, and daily journals. Use when working with .md, .base, or .canvas files in an Obsidian vault.",
  "author": {
    "name": "Mark Riechers",
    "url": "https://github.com/mriechers"
  },
  "repository": "https://github.com/mriechers/obsidian-PARA-skills",
  "license": "MIT",
  "keywords": [
    "obsidian",
    "markdown",
    "bases",
    "canvas",
    "pkm",
    "notes",
    "para",
    "tasks",
    "kanban",
    "rest-api"
  ]
}
```

Upstream attribution moves to README (spec 07) — plugin.json `author` reflects
the fork maintainer; kepano remains in LICENSE and README.

## Divergence policy

- **Allowed to diverge from upstream**: `README.md`, both `.claude-plugin/`
  JSONs, `planning/`, `tests/`, new `skills/para-*` dirs.
- **Forbidden**: the five upstream skill dirs, `LICENSE`.
- Verify before every release:
  `git diff --quiet upstream/main -- skills/obsidian-markdown skills/obsidian-bases skills/json-canvas skills/obsidian-cli skills/defuddle`
  (requires `git remote add upstream https://github.com/kepano/obsidian-skills.git`).
- Upstream merges: `git fetch upstream && git merge upstream/main` — expected
  conflict surface is README + packaging JSONs only; resolve keeping our
  packaging, adopting upstream skill changes wholesale.
