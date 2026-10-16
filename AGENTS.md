# Working context

Read `README.md`, `docs/roadmap.md`, `docs/supabase-website.md`, and `docs/campaign-loading.md` before changing campaign loading or authoring workflows. Earlier Phase 1/static-snapshot reports are historical; the production campaign uses Supabase Auth and RLS.

## Current site

- `index.html` is the public fictional forum. `campaign.html` is the authenticated campaign companion.
- Production must not fall back to `data.js`, `campaign-additions.js`, or other public campaign snapshots when Supabase fails.
- `supabase-session.js` handles authentication and mutations; `campaign-loader.js` owns the tab-local catalog/detail/editor cache; `supabase-data.js` adapts authorized rows; `campaign-model.js` validates and derives views; `app.js` renders routes and lazy popups.
- Login fetches a catalog, not every NPC's full entries or source archive. Details, ability rules, Coterie content, and source text load on demand. Search uses the RLS-filtered server RPC plus catalog connection matching.
- Storyteller tools intentionally load the complete authorized editor bundle for accurate dependencies and bulk reveals. Preserve that behavior until the editor/reveal planner itself supports partial data.
- Keep RPCs `SECURITY INVOKER`, existing RLS, revision conflicts, protected Storyteller notes, and shared Player notes intact. No service-role key in browser code.
- The large editor RPC timed out live after dataset growth. Editor entry/refresh now reads all 24 authorized tables via paged REST (500 rows, stable order, three concurrent tables), then publishes the complete graph. Preserve complete archives/provenance and account invalidation. Catalog/detail RPCs stay lazy. This client fix needs no new SQL; see `docs/campaign-loading.md`. Deployment of this follow-up is not yet confirmed.
- Permanent-death Yes adds a small marker on People links and a translucent red X across the detail-page name; No, Unknown, and unavailable statuses stay unmarked. Preserve name readability and RLS filtering.
- Chronicle history uses `thread.status` (active/completed), not database archiving; keep completed records readable under existing RLS. Migration 011 includes completion and in-world dates in the lazy catalog. See `docs/chronicle-history.md`.
- Recap import artifacts live under `/workspace/session-reviews/` outside this published checkout; use the dedicated reader for comparisons, then prepare guarded SQL for manual application. Never publish private recaps or withheld original passages in Git.
- Preserve authorized Geography review warnings in the catalog. Popup detail loading must recover when a new linked record was created after login and is missing from cached metadata. Regression coverage is in `tests/campaign-loading-browser.cjs`.
- Clear account caches and reject late responses at sign-out/expiration. Do not persist campaign content in localStorage or IndexedDB.
- Keep campaign release query strings synchronized for styles, login, and loader; login passes its version to delayed `app.js`.

## Current handoff (2026-10-15, America/Chicago)

- Remote `origin/main` contains PR #32, merge `4574c4e`, including implementation commit `0f96693` from `connection-labels-and-editor-loading`. This was verified by fetching the remote. Browser deployment and migration 012 installation are **not yet confirmed**.
- The user previously reported applying migrations 010 and 011 and the private recap update. Do not rerun initial setup, migrations 010/011, or NPC/recap imports to fix editor loading.
- The old full editor RPC reproduced a live HTTP 500 / SQL `57014` timeout after about 8.2 seconds. Editor loads now use complete, paged RLS-filtered REST reads. This loading fix needs no new SQL. Catalog/detail RPCs remain in use for normal browsing.
- Migration `20261016001200_personal_connection_labels.sql` is needed only for **saving personal connection labels**. See `docs/personal-connection-labels.md` for storage, visibility, revisions, UI and rollout details.
- Release query string: `20261016-editor-batches`, including styles/model/loader/session/editor; session passes the version to delayed `app.js`. Keep these synchronized when changing the relevant assets.
- Validation passed before push: 36 unit checks, full disposable PostgreSQL migration/permission suite, existing editor/loading browser suites, and connection-label/paged-load/retry browser coverage. Read-only live pagination fetched all 24 tables in about 20.6 seconds; this is a reader-account measurement, not a deployed Storyteller timing guarantee.
- Both GitHub GraphQL and REST PR-creation attempts returned `Forbidden`; Git pushes work. Provide a compare/PR-creation link honestly when this happens. PR #32 was subsequently created/merged outside those failed tool calls. Do not auto-merge.
- Recap paragraph formatting shipped in PR #31 (merge `5b4a2d4`): saved newlines/blank lines display in session `recap` sections without bullet markers. No SQL required for that display change.

## User conventions

- Ask one actual clarification question at a time; do not bundle multiple questions into one prompt.
- **CPAP** means commit, push, and provide the pull-request link. It does not mean merge automatically.
- Follow the NPC import rules in `docs/roadmap.md`: reuse identities, ask about unclear classifications/text, invent no facts, default new people to permanent death No, and keep new imports Storyteller-only unless explicitly shared.
- Private NPC artifacts and credentials stay outside the published checkout. Never commit a live database export.

## Personal connection label editing

Migration `20261016001200_personal_connection_labels.sql` adds a narrow SECURITY INVOKER RPC for creating/updating private `relationship.details` fields on existing personal associations. The editor has **Personal connection labels**; the person being edited owns that label's perspective. Keep label projection scoped to that person. New labels stay private and shared-label edits use the existing reveal review. Unlabeled associations display “Associate”. Deployment/application of migration 012 is not yet confirmed; do not claim it is installed until verified.
