# Obsidian PARA Skills

Agent Skills for use with Obsidian, following the [Agent Skills specification](https://agentskills.io/specification) so they can be used by any skills-compatible agent, including Claude Code, Codex, and OpenCode. This repository is a fork of [kepano/obsidian-skills](https://github.com/kepano/obsidian-skills) extended with a set of `para-*` skills for working in a [PARA](https://fortelabs.com/blog/para/)-organized vault.

> **Attribution.** The five upstream skills (`obsidian-markdown`, `obsidian-bases`, `json-canvas`, `obsidian-cli`, `defuddle`) are included **unmodified** from [kepano/obsidian-skills](https://github.com/kepano/obsidian-skills) (MIT, © [Steph Ango](https://stephango.com/)), forked at commit [`a1dc48e`](https://github.com/kepano/obsidian-skills/commit/a1dc48e). The `para-*` skills are additions by Mark Riechers.

## Vault-specific values

The `para-*` skills teach **generic** PARA and Obsidian-plugin patterns. Every value specific to one vault — folder names, tag vocabulary, plugin settings, ports, secret references — lives in a **single file**: [`skills/para-vault/references/VAULT-CONFIG.md`](skills/para-vault/references/VAULT-CONFIG.md). To reuse these skills on a different vault, adapt that one file; the skills themselves stay unchanged.

## Installation

### Marketplace (primary)

```
/plugin marketplace add mriechers/obsidian-PARA-skills
/plugin install obsidian@obsidian-para-skills
```

> This is a **private repository**. The machine needs `gh auth login` **and** `gh auth setup-git` (or SSH-agent git credentials) so the marketplace clone can authenticate.

### npx skills

```
npx skills add git@github.com:mriechers/obsidian-PARA-skills.git
```

SSH form only — an unauthenticated HTTPS clone won't reach a private repo. If you install individual skills rather than the whole pack, you must also install **`para-vault`**: the other `para-*` skills reference its `VAULT-CONFIG.md`.

### Manually

#### Claude Code

Add the contents of this repo to a `/.claude` folder in the root of your Obsidian vault (or whichever folder you're using with Claude Code). See more in the [official Claude Skills documentation](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview).

#### Codex

Copy the `skills/` directory into your Codex skills path (typically `~/.codex/skills`). See the [Agent Skills specification](https://agentskills.io/specification) for the standard skill format.

#### OpenCode

Clone the entire repo into the OpenCode skills directory (`~/.opencode/skills/`):

```sh
git clone git@github.com:mriechers/obsidian-PARA-skills.git ~/.opencode/skills/obsidian-PARA-skills
```

Do not copy only the inner `skills/` folder — clone the full repo so the directory structure is `~/.opencode/skills/obsidian-PARA-skills/skills/<skill-name>/SKILL.md`.

OpenCode auto-discovers all `SKILL.md` files under `~/.opencode/skills/`. No changes to `opencode.json` or any config file are needed. Skills become available after restarting OpenCode.

## Skills

### Upstream skills (© Steph Ango)

Included unmodified from [kepano/obsidian-skills](https://github.com/kepano/obsidian-skills).

| Skill | Description |
|-------|-------------|
| [obsidian-markdown](skills/obsidian-markdown) | Create and edit [Obsidian Flavored Markdown](https://help.obsidian.md/obsidian-flavored-markdown) (`.md`) with wikilinks, embeds, callouts, properties, and other Obsidian-specific syntax |
| [obsidian-bases](skills/obsidian-bases) | Create and edit [Obsidian Bases](https://help.obsidian.md/bases/syntax) (`.base`) with views, filters, formulas, and summaries |
| [json-canvas](skills/json-canvas) | Create and edit [JSON Canvas](https://jsoncanvas.org/) files (`.canvas`) with nodes, edges, groups, and connections |
| [obsidian-cli](skills/obsidian-cli) | Interact with Obsidian vaults via the [Obsidian CLI](https://help.obsidian.md/cli) including plugin and theme development |
| [defuddle](skills/defuddle) | Extract clean markdown from web pages using [Defuddle](https://github.com/kepano/defuddle), removing clutter to save tokens |

### PARA skills (© Mark Riechers)

| Skill | Description |
|-------|-------------|
| [para-vault](skills/para-vault) | Work with a PARA-organized Obsidian vault: folder structure, the `para` frontmatter property as ground truth, tag and status conventions, templates, and routing between file edits, CLI, and REST API. Use when creating, moving, filing, or classifying notes in a PARA vault, or before any other vault operation. |
| [para-tasks](skills/para-tasks) | Create and query tasks with the Obsidian Tasks plugin in a PARA vault: emoji-format dates and priorities, recurrence, custom checkbox statuses, and the vault's canonical `tasks` query blocks. Use when adding todos, due dates, recurring tasks, priorities, or writing or editing `tasks` queries. |
| [para-kanban](skills/para-kanban) | Read and edit Obsidian Kanban plugin boards: markdown files with `kanban-plugin` frontmatter, lanes as headings, and cards as checklist items with wikilinks, context hashtags, and `@{date}` syntax. Use when adding cards, moving cards between lanes, or editing kanban board files, especially a PARA project dashboard. |
| [para-rest-api](skills/para-rest-api) | Read and write Obsidian vault notes over the Local REST API plugin using curl: bearer-token auth, HTTPS with a self-signed certificate, and URL-encoded vault paths. Use when Obsidian is running and notes must be created or read programmatically, or when another service needs HTTP access to the vault. |
| [para-daily-journal](skills/para-daily-journal) | Read and update daily journal notes that use HTML section markers for machine-injected content. Use when editing today's daily note, appending journal entries or tasks, injecting content into a journal section, or reading the daily journal folder. |

## Upstream sync

This fork tracks [kepano/obsidian-skills](https://github.com/kepano/obsidian-skills). To pull upstream changes:

```sh
git remote add upstream https://github.com/kepano/obsidian-skills.git   # one-time
git fetch upstream
git merge upstream/main
```

The five upstream skill directories are kept **byte-identical** to upstream, so the expected conflict surface is `README.md` and `.claude-plugin/` only — resolve by keeping this fork's packaging and taking upstream's skill changes wholesale.

## Development

- `planning/` holds the build docs for the `para-*` skills.
- Run `tests/validate.sh` before committing (static validation of frontmatter, links, packaging, and forbidden content).
- Release and update steps are in [`planning/09-deployment-runbook.md`](planning/09-deployment-runbook.md).

## License

MIT. Upstream content © [Steph Ango](https://stephango.com/) (kepano); PARA additions © Mark Riechers. See [LICENSE](LICENSE).
