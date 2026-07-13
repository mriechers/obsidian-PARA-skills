---
name: para-rest-api
description: "Read and write Obsidian vault notes over the Local REST API plugin using curl: bearer-token auth, HTTPS with a self-signed certificate, and URL-encoded vault paths. Use when Obsidian is running and notes must be created or read programmatically, or when another service needs HTTP access to the vault."
---

# PARA REST API

Read and write the vault over the **Local REST API** plugin (obsidian-local-rest-api
v3.6.1) with `curl`. Use for headless flows and external services. For app-side
work (daily notes, templates, search) use the [`obsidian-cli`](../obsidian-cli)
skill instead — REST is for services and scripts, not interactive editing.

All vault-specific values (port, key reference, inbox path, endpoints) live in
[`../para-vault/references/VAULT-CONFIG.md`](../para-vault/references/VAULT-CONFIG.md)
§8. Full endpoint catalog: [`references/ENDPOINTS.md`](references/ENDPOINTS.md).
The curl recipes below show **this vault's concrete values — confirm them in
VAULT-CONFIG §8 before relying on them.**

## 1. Prerequisites

- **Desktop-only plugin**: the REST API runs inside the Obsidian desktop app.
  Obsidian must be **running** for any call to succeed (see §6 Fallback).
- **HTTPS only** on port **27124**. The plugin serves a **self-signed
  certificate**, so clients must pass `curl -k` (or pin the cert). Do not expect
  plain HTTP.

## 2. Auth — bearer token via 1Password

Every request carries `Authorization: Bearer <key>`. Retrieve the key **only**
through the 1Password `op` CLI — never hardcode it, never commit it, never echo
it into logs or terminal output:

```bash
KEY="$(op read "op://<vault>/<item>/<field>")"   # exact op:// ref → VAULT-CONFIG §8
```

- The exact `op://<vault>/<item>/<field>` reference for this vault is recorded in
  VAULT-CONFIG §8 — copy it from there.
- Keep the key in the `$KEY` shell variable and reference `"$KEY"` in headers.
  **Never** print it: avoid `set -x`, `curl -v`, and `echo "$KEY"`, which would
  leak it into logs or scrollback.

## 3. Core recipes

Health check (run this first — proves the app is up and the key is valid):

```bash
curl -k https://127.0.0.1:27124/ -H "Authorization: Bearer $KEY"
```

Create or replace a note (PUT replaces the whole file; body is the full note):

```bash
curl -k -X PUT "https://127.0.0.1:27124/vault/0%20-%20INBOX/My%20Note.md" \
  -H "Authorization: Bearer $KEY" \
  -H "Content-Type: text/markdown" \
  --data-binary @note.md
```

Read a note:

```bash
curl -k "https://127.0.0.1:27124/vault/0%20-%20INBOX/My%20Note.md" \
  -H "Authorization: Bearer $KEY"
```

Delete a note — **destructive; confirm the exact path with the user before
running**:

```bash
curl -k -X DELETE "https://127.0.0.1:27124/vault/0%20-%20INBOX/My%20Note.md" \
  -H "Authorization: Bearer $KEY"
```

Port `27124` and the `0%20-%20INBOX` path are **this vault's values — confirm in
VAULT-CONFIG §8.** Response codes and the full endpoint list are in
[`references/ENDPOINTS.md`](references/ENDPOINTS.md).

## 4. URL-encoding rule

Vault paths contain spaces and PARA folder prefixes (`0 - INBOX`, `1 - PROJECTS`).
**Always URL-encode every path segment** in the request URL: a space becomes
`%20`, so `0 - INBOX/My Note.md` → `0%20-%20INBOX/My%20Note.md`. Un-encoded spaces
break the request. Encode the path, not the header or body.

## 5. Frontmatter obligation

API-created notes are written by the plugin, **not** through Obsidian's in-app
note-creation flow, so they do not go through interactive templating. Templater's
folder-templates **do not fire** on REST-created files (verified against this
vault), so nothing fills in the frontmatter for you — a note that reaches the
vault must already satisfy the full frontmatter contract. **Always include the
complete frontmatter block in the PUT body** — `tags` (first tag `all`),
`created`, `para`, and any status/type fields the target folder expects.

Do not restate the contract here — defer to
[`../para-vault/references/VAULT-CONFIG.md`](../para-vault/references/VAULT-CONFIG.md)
§3 for the field list and rules, and to [`obsidian-markdown`](../obsidian-markdown)
for property syntax.

**No destination given?** Default to a **new note in the Inbox** with `para: inbox`
— PUT to the Inbox path (VAULT-CONFIG §2). This mirrors
[`para-vault`](../para-vault/SKILL.md)'s default-destination rule; don't invent a
folder or append to an unrelated note.

### Verify after create (Templater does not double-fire)

Testing against this vault confirmed Templater folder-templates **do not** fire
on REST-created files: a PUT into a template-covered folder (`0 - INBOX`) stores
exactly the body you send — no injected template skeleton, no doubled
frontmatter. A quick verify step is still cheap insurance:

1. PUT the note with the full frontmatter contract in the body (§5).
2. **GET the note back** and confirm it has **exactly one** frontmatter block
   matching the contract (your PUT body, unchanged).
3. In the unlikely event a second `---` block or duplicated headings appear,
   **reconcile**: re-issue the PUT with the canonical single-frontmatter body
   (PUT replaces the whole file), then GET and re-verify.

## 6. Fallback — Obsidian not running

The plugin only answers while the desktop app is open. If the §3 health check
fails with **connection refused**, Obsidian is not running and REST is
unavailable. Fall back to a **direct file write** into the vault's inbox folder
(`/Users/mriechers/MarkBrain/0 - INBOX/` — **this vault's value, confirm in
VAULT-CONFIG §8**), honoring the **same frontmatter contract** (§5). The file is
picked up when Obsidian next launches (and syncs via Syncthing). Templater does
not fire on external writes, so no double-fire concern applies to the fallback —
but the note still must carry the full contract itself.

## 7. When to use the CLI instead

REST is for **services and headless/scripted flows** — another process needs HTTP
access, or Obsidian may be running unattended. For **app-side operations** (daily
notes, running templates, interactive search, plugin dev) use the
[`obsidian-cli`](../obsidian-cli) skill, which drives the running app directly.

Never suggest **Dataview** queries — it is installed but disabled vault-wide; the
`.base` files are the index layer (see VAULT-CONFIG §9).

## Standalone-install caveat

This skill depends on [`para-vault`](../para-vault) for every vault-specific value
(the `op://` key reference, port, inbox path, endpoints, and the frontmatter
contract). If it was installed on its own, install `para-vault` too so
`../para-vault/references/VAULT-CONFIG.md` resolves.
