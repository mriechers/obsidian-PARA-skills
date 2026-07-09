# 07 — README rewrite spec

Replace the current upstream README with the outline below. Keep the terse,
practical, doc-style tone of the original — no badges, no screenshots.

## Outline (section order)

1. **Title + intro** — `# Obsidian PARA Skills`. Two sentences: Agent Skills for
   Obsidian following the [Agent Skills specification](https://agentskills.io/specification);
   a fork of [kepano/obsidian-skills](https://github.com/kepano/obsidian-skills)
   extended with skills for working in a PARA-organized vault.

2. **Attribution note** (blockquote) — the five upstream skills are included
   **unmodified** from kepano/obsidian-skills (MIT, © Steph Ango); the `para-*`
   skills are additions by Mark Riechers.

3. **Vault-specificity note** — the `para-*` skills teach generic PARA/plugin
   patterns; all vault-specific values live in ONE file:
   `skills/para-vault/references/VAULT-CONFIG.md`. To reuse these skills on
   another vault, adapt that single file.

4. **Installation**
   - **Marketplace** (primary):
     ```
     /plugin marketplace add mriechers/obsidian-PARA-skills
     /plugin install obsidian@obsidian-para-skills
     ```
     Note: this is a **private repo** — the machine needs `gh auth login` +
     `gh auth setup-git` (or SSH-agent git credentials) so the marketplace clone
     can authenticate.
   - **npx skills**: `npx skills add git@github.com:mriechers/obsidian-PARA-skills.git`
     (SSH form only — HTTPS without auth won't reach a private repo). Caveat:
     per-skill installers must also take `para-vault`, since sibling skills
     reference its VAULT-CONFIG.
   - **Manually** — keep the three upstream subsections (Claude Code vault-root
     `.claude` folder; Codex `~/.codex/skills`; OpenCode full-repo clone into
     `~/.opencode/skills/`) with URLs re-pointed to
     `mriechers/obsidian-PARA-skills` and the OpenCode full-repo warning kept.

5. **Skills** — two tables:
   - *Upstream skills (Steph Ango)* — the existing five rows verbatim from the
     current README (links + descriptions unchanged).
   - *PARA skills* — five rows; descriptions = each skill's frontmatter
     `description` (specs 01–05), linked to `skills/para-*` dirs.

6. **Upstream sync** — the fork tracks kepano/obsidian-skills:
   `git remote add upstream https://github.com/kepano/obsidian-skills.git`,
   `git fetch upstream && git merge upstream/main`; upstream skill dirs are kept
   byte-identical; expected conflict surface is README + `.claude-plugin/` only.

7. **Development** — `planning/` holds the build docs; run `tests/validate.sh`
   before committing; release/update steps in
   `planning/09-deployment-runbook.md`.

8. **License** — MIT. Upstream content © Steph Ango (kepano); PARA additions ©
   Mark Riechers.

## Acceptance

- [ ] No remaining `kepano/obsidian-skills` install commands (attribution links
      are fine); no `obsidian@obsidian-skills` install string anywhere.
- [ ] Both tables render; all skill links resolve to real dirs.
- [ ] Private-repo auth note present in the marketplace section.
