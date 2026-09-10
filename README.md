# Obsidian PARA Skills

Agent Skills for working in a [PARA](https://fortelabs.com/blog/para/)-organized
[Obsidian](https://obsidian.md/) vault. Written to the
[Agent Skills specification](https://agentskills.io/specification), so they run in any
skills-compatible agent — Claude Code, Codex, OpenCode.

This is a fork of **[kepano/obsidian-skills](https://github.com/kepano/obsidian-skills)**
by [Steph Ango](https://stephango.com/), which supplies five skills for Obsidian's file
formats and CLI. Those five are included here **unmodified**. What this fork adds is a
`para-*` suite for the layer above the file formats: how an actual vault is organized,
and how an agent should behave inside one.

## What's different about these skills

Most vault automation breaks the moment it meets a real vault, because it assumes a
structure the vault doesn't have. The `para-*` skills are built around three ideas that
came out of using them daily rather than designing them up front.

**One file holds everything vault-specific.** The skills teach *generic* PARA and
Obsidian-plugin patterns. Every value particular to one vault — folder names, tag
vocabulary, plugin settings, ports, secret references — lives in a single file,
[`skills/para-vault/references/VAULT-CONFIG.md`](skills/para-vault/references/VAULT-CONFIG.md).
Adapting the whole suite to a different vault means editing that one file. The skills
themselves stay untouched, which is also what makes upstream merges clean.

**A property, not a folder, is ground truth.** PARA membership is the `para` frontmatter
value, not where the file happens to sit. Folders drift; notes get dragged around; index
views filter on the property. Skills that trust the path get this wrong constantly.

**Documented failure modes, not just capabilities.** Each skill carries the traps that
actually bit — a `GOTCHAS.md` where one exists, and inline warnings where it matters. A
worked example: this vault runs the Tasks plugin with no global filter, so *every*
`- [ ]` checkbox in the vault is a live task, and an agent writing a casual checklist
silently creates real ones. That is the kind of thing a generic skill never warns you
about, and the kind of thing that costs an afternoon.

## Skills

### PARA suite

Added by this fork.

| Skill | Description |
|-------|-------------|
| [para-vault](skills/para-vault) | The entry point. PARA folder structure, the `para` property as ground truth, tag and status conventions, templates, and routing between file edits, CLI, and REST API. Read before any other vault operation — it owns `VAULT-CONFIG.md`, which the rest reference. |
| [para-tasks](skills/para-tasks) | Tasks-plugin syntax in a PARA vault: emoji dates and priorities, recurrence, custom checkbox statuses, and the vault's canonical `tasks` query blocks. |
| [para-kanban](skills/para-kanban) | Kanban-plugin boards: lanes as headings, cards as checklist items, wikilinks, context hashtags, and `@{date}` syntax. |
| [para-rest-api](skills/para-rest-api) | Reading and writing notes over the Local REST API plugin: bearer auth, self-signed HTTPS, URL-encoded vault paths. |
| [para-daily-journal](skills/para-daily-journal) | Daily notes that use HTML section markers for machine-injected content — how to write between the markers without destroying them. |

### Upstream skills

Included **byte-identical** from [kepano/obsidian-skills](https://github.com/kepano/obsidian-skills),
forked at [`a1dc48e`](https://github.com/kepano/obsidian-skills/commit/a1dc48e).
© [Steph Ango](https://stephango.com/), MIT.

| Skill | Description |
|-------|-------------|
| [obsidian-markdown](skills/obsidian-markdown) | [Obsidian Flavored Markdown](https://help.obsidian.md/obsidian-flavored-markdown) — wikilinks, embeds, callouts, properties |
| [obsidian-bases](skills/obsidian-bases) | [Obsidian Bases](https://help.obsidian.md/bases/syntax) (`.base`) — views, filters, formulas, summaries |
| [json-canvas](skills/json-canvas) | [JSON Canvas](https://jsoncanvas.org/) (`.canvas`) — nodes, edges, groups, connections |
| [obsidian-cli](skills/obsidian-cli) | The [Obsidian CLI](https://help.obsidian.md/cli), including plugin and theme development |
| [defuddle](skills/defuddle) | Clean markdown from web pages via [Defuddle](https://github.com/kepano/defuddle) |

## Installation

### Claude Code marketplace

```
/plugin marketplace add mriechers/obsidian-PARA-skills
/plugin install obsidian@obsidian-para-skills
```

### npx skills

```sh
npx skills add https://github.com/mriechers/obsidian-PARA-skills.git
```

Installing individual skills rather than the whole pack? You must also install
**`para-vault`** — every other `para-*` skill reads its `VAULT-CONFIG.md`.

### Manually

**Claude Code** — copy the repo contents into a `.claude/` folder at the root of your
vault (or whichever directory you point Claude Code at). See the
[Agent Skills docs](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview).

**Codex** — copy `skills/` into your Codex skills path, typically `~/.codex/skills`.

**OpenCode** — clone the whole repo into `~/.opencode/skills/`:

```sh
git clone https://github.com/mriechers/obsidian-PARA-skills.git ~/.opencode/skills/obsidian-PARA-skills
```

Clone the full repo, not just the inner `skills/` folder — OpenCode discovers
`SKILL.md` files at `~/.opencode/skills/<repo>/skills/<skill-name>/SKILL.md`. Skills
become available after a restart.

## Using these on your own vault

`VAULT-CONFIG.md` currently describes one real vault, which makes it a worked example
rather than a blank template. To adapt it:

1. Replace §1–2 with your vault's path and PARA folder names.
2. Rewrite §3 to your frontmatter vocabulary — especially the `para` property values and
   your anchor tag.
3. Update §4–7 for the plugins you actually run. Delete the sections for plugins you
   don't; the skills degrade gracefully when a section is absent.
4. §8 holds a secret *reference* (a 1Password `op://` path), never a secret. Keep it
   that way.

Nothing outside that file needs to change.

## Upstream sync

```sh
git remote add upstream https://github.com/kepano/obsidian-skills.git   # one-time
git fetch upstream
git merge upstream/main
```

The five upstream skill directories are kept byte-identical, so the expected conflict
surface is `README.md` and `.claude-plugin/` only. Resolve by keeping this fork's
packaging and taking upstream's skill changes wholesale.

## Development

Run `tests/validate.sh` before committing — static validation of frontmatter, links,
packaging, and forbidden content.

## License

MIT. Upstream skills © [Steph Ango](https://stephango.com/) (kepano); the `para-*`
skills © Mark Riechers. See [LICENSE](LICENSE).
