# 04 — Skill spec: `para-rest-api`

Target: `skills/para-rest-api/SKILL.md` + `references/ENDPOINTS.md`.
Facts: [00-vault-reference.md](00-vault-reference.md) §8.

## Frontmatter (exact)

```yaml
---
name: para-rest-api
description: Read and write Obsidian vault notes over the Local REST API plugin using curl: bearer-token auth, HTTPS with a self-signed certificate, and URL-encoded vault paths. Use when Obsidian is running and notes must be created or read programmatically, or when another service needs HTTP access to the vault.
---
```

## SKILL.md outline

1. **Prerequisites** — desktop-only plugin; Obsidian must be running; HTTPS-only
   (the insecure HTTP port is disabled in this vault); self-signed cert →
   `curl -k` (or pin the cert).
2. **Auth** — `Authorization: Bearer <key>`; retrieve the key with the
   1Password CLI: `op read "op://<vault>/<item>/<field>"` — the exact reference
   lives in `../para-vault/references/VAULT-CONFIG.md` §8. NEVER echo the key
   into logs/output; never hardcode it.
3. **Core recipes** (complete copy-paste curl, port from config):
   - Health check: `curl -k https://127.0.0.1:27124/ -H "Authorization: Bearer $KEY"`
   - Create/replace: `curl -k -X PUT "https://127.0.0.1:27124/vault/0%20-%20INBOX/My%20Note.md" -H "Authorization: Bearer $KEY" -H "Content-Type: text/markdown" --data-binary @note.md`
   - Read: `GET /vault/<path>`; delete: `DELETE /vault/<path>` (confirm before
     destructive calls).
4. **URL-encoding rule** — vault paths contain spaces (`0 - INBOX`); always
   URL-encode path segments (`0%20-%20INBOX`).
5. **Frontmatter obligation** — API-created notes bypass in-app templating
   (unconfirmed whether folder-templates fire — check config note); ALWAYS
   include the full frontmatter contract in the PUT body → defer to `para-vault`.
6. **Fallback** — Obsidian not running → health check fails → write the file
   directly to the vault's inbox folder (path in config) with the same contract.
7. **When to use the CLI instead** — `obsidian-cli` skill covers app-side
   operations (daily notes, templates, search); REST is for services and
   headless flows.
8. Standalone-install caveat (needs `para-vault`).

## references/ENDPOINTS.md

- Endpoint reference for the plugin version in use (v3.6.1): `/` (status),
  `/vault/<path>` GET/PUT/PATCH/DELETE, `/vault/<dir>/` listing, `/periodic/…`
  daily-note endpoints, `/search/` — with the two production-proven calls
  (health, PUT create) marked as such; response codes; PATCH heading-targeting
  syntax; error handling (401 = bad key, connection refused = app closed).
- Note: verify endpoint list against the plugin's live OpenAPI docs
  (`https://127.0.0.1:27124/` serves them) during build; don't invent endpoints.

## Overlap rules

- No CLI duplication (`obsidian-cli`); no frontmatter contract duplication
  (`para-vault`); no generic markdown (`obsidian-markdown`).

## Acceptance checklist

- [ ] Frontmatter exactly `name` + `description`; `name` == dir name.
- [ ] Zero Keychain references; `op` CLI only; key never echoed in examples.
- [ ] Port/paths cited from VAULT-CONFIG (SKILL.md may show them in worked curl
      examples, flagged as "this vault's values — confirm in config").
- [ ] URL-encoding rule + frontmatter obligation both present.
- [ ] Links resolve; ≤ ~150 lines.
