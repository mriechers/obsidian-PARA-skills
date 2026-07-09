# 11 — Open questions (resolve during build)

1. **Exact 1Password reference for the REST API key.** Confirm with
   `op item list` / `op item get` (with Mark present or via a named item he
   provides) and record the `op://<vault>/<item>/<field>` string in
   `skills/para-vault/references/VAULT-CONFIG.md` §8. Until confirmed, specs use
   a placeholder. Related: 10-coordination-tasks.md §2 (legacy Keychain entry).

2. **Do Templater folder-templates fire on REST-created files?** Resolved by
   smoke test ② (08-testing-spec.md). If they DO fire, `para-rest-api` must warn
   about double-frontmatter (template + PUT body) and recommend a strategy
   (create-then-verify, or write bodies without frontmatter into
   template-covered folders). If they don't, current spec stands.

3. **`/sync` symlink channel.** Recommendation is marketplace-only
   (10-coordination-tasks.md §5); confirm the-lodge's skill-discovery walk
   really does skip this repo's root-level `skills/` layout.

4. **`claude plugin validate`.** Check whether the installed Claude Code version
   ships a validator; wire into `tests/validate.sh` if so.

5. **npx-skills flow for a private repo.** The README spec documents the SSH
   form; verify `npx skills add git@github.com:…` actually works against a
   private repo before advertising it, or drop that section.

6. **Later candidates (not this build):** vault-specific companion notes for
   `defuddle`/`obsidian-cli` usage in this ecosystem; conventions for
   `5 - OUTBOX` once it sees real use; a `para-meetings` skill if the MEETINGS
   area develops agent workflows.
