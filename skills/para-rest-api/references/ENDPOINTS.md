# ENDPOINTS — Local REST API (obsidian-local-rest-api v3.6.1)

Endpoint reference for the plugin version running in this vault. All calls are
**HTTPS on port 27124** with a **self-signed cert** (`curl -k`) and an
`Authorization: Bearer $KEY` header — see [`../SKILL.md`](../SKILL.md) §1–§2 and
[`../../para-vault/references/VAULT-CONFIG.md`](../../para-vault/references/VAULT-CONFIG.md)
§8 for the port, key reference, and auth details.

> **Verify at deploy.** This list reflects v3.6.1. The plugin serves its own live
> **OpenAPI spec** at `https://127.0.0.1:27124/` (open it with the bearer key) —
> confirm the exact endpoints, parameters, and codes against that spec at build
> time. **Do not invent endpoints beyond those listed here.**

## Endpoints

| Method | Path | Purpose |
|---|---|---|
| GET | `/` | Server status / health check. **Production-proven.** |
| GET | `/vault/<path>` | Read a note's raw markdown. |
| PUT | `/vault/<path>` | Create or **replace** a note (body = full file). **Production-proven.** |
| PATCH | `/vault/<path>` | Modify part of a note (heading/block/frontmatter target). |
| DELETE | `/vault/<path>` | Delete a note. Destructive — confirm the path first. |
| GET | `/vault/<dir>/` | List a directory (trailing slash). Returns child files/folders. |
| GET/POST | `/periodic/<period>/` | Daily/periodic-note endpoints (`daily`, `weekly`, …). |
| POST | `/search/` | Search the vault (query in the body). |

`<path>` is the vault-relative path with **every segment URL-encoded** — e.g.
`0 - INBOX/My Note.md` → `0%20-%20INBOX/My%20Note.md` (SKILL.md §4).

The two calls marked **production-proven** (health `GET /` and create/replace
`PUT /vault/<path>`) are exercised by the `/add-to-inbox` skill and the
vault-courier service. Treat the others as **available but verify against the live
OpenAPI spec** before depending on them.

## PATCH heading-targeting

`PATCH /vault/<path>` inserts or modifies content relative to a target instead of
replacing the whole file. Targeting is controlled by request headers, roughly:

- `Operation` — `append`, `prepend`, or `replace`.
- `Target-Type` — `heading`, `block`, or `frontmatter`.
- `Target` — the target value (e.g. a heading path like `Notes`, a block ref, or a
  frontmatter key).

Exact header names and delimiter syntax vary by plugin build — **confirm against
the live OpenAPI spec at `https://127.0.0.1:27124/` before use.** For simple
create/replace, prefer `PUT` with the full note body (SKILL.md §3).

## Response codes

| Code | Meaning | Handling |
|---|---|---|
| 200 | OK (GET/PATCH/DELETE succeeded, or PUT replaced). | Proceed. |
| 201 | Created (PUT created a new note). | Proceed. |
| 204 | No content (some DELETE/PATCH responses). | Success, empty body. |
| 400 | Bad request (malformed body/headers, bad PATCH target). | Fix the request. |
| 401 | Unauthorized — **bad or missing API key.** | Re-check the `op read` value; do not retry blindly. |
| 404 | Note or directory not found. | Verify the URL-encoded path. |
| 405 | Method not allowed for that path. | Check the method against this table. |

## Error handling

- **`401 Unauthorized`** → the bearer key is wrong or missing. Re-fetch it with
  `op read` (SKILL.md §2); never echo the key while debugging.
- **Connection refused / could not connect** → **Obsidian is not running** (or the
  plugin is disabled). Use the direct-file-write fallback (SKILL.md §6).
- **SSL / certificate errors** → the cert is self-signed; ensure `curl -k` (or a
  pinned cert). Never fall back to plain HTTP — the insecure port is disabled.
- **Path 404 on a path you expect to exist** → almost always an encoding mistake;
  re-check that every segment is URL-encoded (SKILL.md §4).
