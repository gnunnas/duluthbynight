# Campaign loading

## Current rollout status (2026-10-15)

The user reported running migration 010 successfully. The implementation and independent code review are complete on branch `lazy-load-campaign-pages` (implementation commit `d4db862`). Both review findings were fixed: ability popups now recover from newly added reference targets missing from cached metadata, and authorized Geography review warnings are retained in the catalog.

The branch was pushed. GitHub API access returned `Forbidden` during automatic PR creation, so a PR-creation link was provided instead. Subsequently, the user reported the live website loading in about 3 seconds (previously about 20), with first-time character loads under a second. This is user-reported behavior, not an independent timing measurement; the PR/merge state was not checked. Check current remote/PR/deployment state before continuing; the dated status may have changed. The migration installation is user-reported, not independently verified against the live database.

## Deploy in this order

1. In Supabase → SQL Editor, run the **entire** [migration 010](../supabase/migrations/20261015001000_campaign_lazy_loading.sql), from `begin;` through `commit;`. Existing migrations 001–009 must already be installed. No campaign reimport is needed.
2. Deploy this website version after the migration succeeds. The HTML uses a new release query string for the loader, login script, delayed app, and styles to bypass previously cached code.
3. Sign in and check Tonight, People → a character → an ability popup, Coterie, search, and Storyteller editing. Check a player account too. Use browser Network tools to confirm login requests `load_campaign_page` with `p_scope: "catalog"`; character/popup opens request `detail`. No full `content_items` or provenance table downloads should occur during normal login.

The migration adds read-only `SECURITY INVOKER` page/search functions and indexes. Existing row-level permissions remain authoritative. It changes no campaign entries, revelations, or account roles. Missing migration errors explicitly identify migration 010 rather than silently loading everything.

For readable completed threads and separate in-world dates, apply [migration 011 and the history update](chronicle-history.md) too. Its additional catalog fields do not load full recaps.

## What loads

- **Sign-in:** access checks in parallel, then one catalog request with record names, aliases, overview/type/date fields, portraits, relationships, geography, ability parent/level definitions, death status, authorized review warnings, and Tonight status. Lists and links use this catalog.
- **Record pages and Coterie:** full authorized sections/entries for the selected record only. Opening another character does not fetch every NPC.
- **Ability popup:** the selected ability's rules load on first open.
- **Imported source text:** loads only when its archive record is opened during normal browsing. It is absent from the initial catalog.
- **Search:** a debounced server query searches authorized names, entry title/body/value text, and selected abilities, returning matching record IDs. Unopened text remains searchable, including source archives. Protected fields cannot contribute results for players. The browser also matches the catalog’s clan and affiliation connections, preserving those searches without loading full profiles. Alias routes are not separate search documents.
- **Storyteller tools/editor:** deliberately fetch the complete authorized dataset on first entry so dependency review, cross-record choices, and bulk reveals remain complete. The client reads all 24 tables through RLS-filtered REST pages of 500 rows, in stable key order, with at most three tables loading concurrently. It publishes the result only after every table finishes. This screen may take longer; the initial play screens no longer pay that cost. Once loaded, it is retained for the session.

Record details are cached in memory within the signed-in tab, and duplicate concurrent requests share one fetch. Reload actions refresh the current scope; editing/reveal refreshes fetch the complete editor scope. Sign-out/session expiration clears the loader cache and rejects late responses. Nothing is cached in localStorage or IndexedDB. A browser reload starts a new session as before.

Pending navigation cannot replace a newer route. Failed page requests show a retry button; failed ability requests show an error and can be retried by reopening the popup. Cached records can reflect older edits made in another tab until reloaded.

## Editor timeout follow-up

As the imported dataset grew, the live `load_campaign_page` editor scope returned HTTP 500 / PostgreSQL `57014` (statement timeout) after about 8.2 seconds, while the catalog succeeded in about 3.4 seconds. The browser now uses the paged REST reads above for editor entry and refresh, rather than the single large editor RPC. Catalog and detail RPCs remain unchanged. This loading fix requires no SQL migration; migration 012 is independently needed only for saving the new personal connection labels.

A read-only live check fetched all 24 tables and 3,242 content items in 38 requests over about 20.6 seconds; the slowest individual request took about 3 seconds. Those measurements used the dedicated reader account and are not a deployed Storyteller timing guarantee. The goal is to avoid one oversized statement while preserving complete reveal dependencies. No archives or provenance tables are silently omitted. Concurrent authors can still change data while pages load; refresh if graph validation fails, and preserve optimistic revisions when saving.

Browser coverage in `tests/connection-labels-browser.cjs` refuses the full editor RPC, includes more than one page of data, verifies no partial editor result is published after a page failure, and verifies retry completes the dataset. Existing editor browser coverage waits for reload completion before opening a form.

## Validation and limits

```sh
node --test tests/campaign-loader.cjs tests/model.cjs tests/npc.cjs tests/watchtower.cjs tests/notes.cjs tests/supabase-adapter.cjs
bash scripts/test-supabase-draft.sh
CAMPAIGN_TEST_URL=http://127.0.0.1:8028 node tests/campaign-loading-browser.cjs
CAMPAIGN_TEST_URL=http://127.0.0.1:8028 node tests/supabase-browser.cjs
CAMPAIGN_TEST_URL=http://127.0.0.1:8028 node tests/record-editor-browser.cjs
CAMPAIGN_TEST_URL=http://127.0.0.1:8028 node tests/coterie-browser.cjs
CAMPAIGN_TEST_URL=http://127.0.0.1:8028 node tests/dead-links-browser.cjs
```

Start the static server separately with `python3 -m http.server 8028`. Browser tests use system Chromium and mocked API rows; the disposable PostgreSQL suite tests the actual RPCs under Storyteller, player, non-member, and anonymous permissions.

The archive-heavy database fixture reduced the initial JSON from 4,870,100 bytes to 320,386 bytes (about 93%). A read-only saved campaign export also projected cleanly for all 248 records: its initial payload fell from 4,035,508 to 822,909 bytes (about 80%). These are local payload measurements, not a promise of a particular live login time. Supabase latency, permission-query execution, authentication, and the homepage image still affect perceived loading. Measure the deployed site after migration before claiming a time improvement.
