# Working context

Read `README.md`, `docs/roadmap.md`, `docs/supabase-website.md`, and `docs/campaign-loading.md` before changing campaign loading or authoring workflows. Earlier Phase 1/static-snapshot reports are historical; the production campaign uses Supabase Auth and RLS.

## Current site

- `index.html` is the public fictional forum. `campaign.html` is the authenticated campaign companion.
- Production must not fall back to `data.js`, `campaign-additions.js`, or other public campaign snapshots when Supabase fails.
- `supabase-session.js` handles authentication and mutations; `campaign-loader.js` owns the tab-local catalog/detail/editor cache; `supabase-data.js` adapts authorized rows; `campaign-model.js` validates and derives views; `app.js` renders routes and lazy popups.
- Login fetches a catalog, not every NPC's full entries or source archive. Details, ability rules, Coterie content, and source text load on demand. Search uses the RLS-filtered server RPC plus catalog connection matching.
- Storyteller tools intentionally load the complete authorized editor bundle for accurate dependencies and bulk reveals. Preserve that behavior until the editor/reveal planner itself supports partial data.
- Keep RPCs `SECURITY INVOKER`, existing RLS, revision conflicts, protected Storyteller notes, and shared Player notes intact. No service-role key in browser code.
- Permanent-death Yes adds a small marker on People links and a translucent red X across the detail-page name; No, Unknown, and unavailable statuses stay unmarked. Preserve name readability and RLS filtering.
- Chronicle history uses `thread.status` (active/completed), not database archiving; keep completed records readable under existing RLS. Migration 011 includes completion and in-world dates in the lazy catalog. See `docs/chronicle-history.md`.
- Recap import artifacts live under `/workspace/session-reviews/` outside this published checkout; use the dedicated reader for comparisons, then prepare guarded SQL for manual application. Never publish private recaps or withheld original passages in Git.
- Preserve authorized Geography review warnings in the catalog. Popup detail loading must recover when a new linked record was created after login and is missing from cached metadata. Regression coverage is in `tests/campaign-loading-browser.cjs`.
- Clear account caches and reject late responses at sign-out/expiration. Do not persist campaign content in localStorage or IndexedDB.
- Keep campaign release query strings synchronized for styles, login, and loader; login passes its version to delayed `app.js`.

## Handoff as of 2026-10-15

The user reported applying migration `20261015001000_campaign_lazy_loading.sql` in Supabase. Do not ask them to rerun initial setup or reimport campaign data for this change. This is user-reported installation, not independent live verification.

Implementation and independent code review are complete on `lazy-load-campaign-pages` (implementation commit `d4db862`). The two review findings above were fixed and rechecked. At this handoff the branch was pushed, but automatic PR creation was blocked by GitHub API `Forbidden`; the user subsequently reported live login improving from about 20 seconds to 3 seconds, with first-time character details under a second. Live timing and PR/merge state were not independently verified. Inspect current GitHub/remote state before treating this dated status as current.

Local evidence: 39 unit checks, loading/login/editor/Coterie/death-marker browser checks, 98 historical snapshot routes, and the complete disposable PostgreSQL permission/migration suite passed. Saved-export initial payload fell from about 4.0 MB to 0.82 MB; this measures payload, not deployed login time. Commands and limitations are in `docs/campaign-loading.md`.

Chronicle-history follow-up: the user applied migration 011 and the private recap transaction. A fresh read-only check confirmed the completion status was saved. The website release is on `chronicle-completed-history`; do not rerun recap SQL to solve a deployment delay. Private session artifacts stay outside this repository.

## User conventions

- Ask one actual clarification question at a time; do not bundle multiple questions into one prompt.
- **CPAP** means commit, push, and provide the pull-request link. It does not mean merge automatically.
- Follow the NPC import rules in `docs/roadmap.md`: reuse identities, ask about unclear classifications/text, invent no facts, default new people to permanent death No, and keep new imports Storyteller-only unless explicitly shared.
- Private NPC artifacts and credentials stay outside the published checkout. Never commit a live database export.
