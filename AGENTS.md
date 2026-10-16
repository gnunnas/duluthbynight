# Working context

Read `README.md`, `docs/roadmap.md`, `docs/supabase-website.md`, and `docs/campaign-loading.md` before changing campaign loading or authoring workflows. Earlier Phase 1/static-snapshot reports are historical; the production campaign uses Supabase Auth and RLS.

## Current site

- `index.html` is the public fictional forum. `campaign.html` is the authenticated campaign companion.
- Production must not fall back to `data.js`, `campaign-additions.js`, or other public campaign snapshots when Supabase fails.
- `supabase-session.js` handles authentication and mutations; `campaign-loader.js` owns the tab-local catalog/detail/editor cache; `supabase-data.js` adapts authorized rows; `campaign-model.js` validates and derives views; `app.js` renders routes and lazy popups.
- Login fetches a catalog, not every NPC's full entries or source archive. Details, ability rules, Coterie content, and source text load on demand. Search uses the RLS-filtered server RPC plus catalog connection matching.
- Storyteller dashboard uses the catalog; record editing loads the selected detail bundle. `editorRows()` is partial until `loadRevealData()` completes. Reveal previews must await the complete paged graph and compute bulk targets afterward. See `docs/scoped-record-editing.md`.
- Keep RPCs `SECURITY INVOKER`, existing RLS, revision conflicts, protected Storyteller notes, and shared Player notes intact. No service-role key in browser code.
- The large editor RPC timed out live after dataset growth. Full reveal review still reads all 24 authorized tables via paged REST (500 rows, stable order, three concurrent tables), publishing atomically. Ordinary editor entry/refresh no longer does this. Preserve complete archives/provenance for review and account invalidation. No new SQL is needed for scoped editing.
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

## Previous task handoff: summary editor (merged PR #33)

- Summary editor merged in PR #33 (`8df46f8`, fetched before the scoped-editing follow-up). Its website release was observed in the user’s Performance trace. Migration installation cannot be inferred from that trace.
- User reported being unable to edit a person's summary. The editor now has a top-level **Summary** textarea even when no `overview` item exists. The same control is available for other entry types, matching the earlier summary roadmap requirement.
- Apply `supabase/migrations/20261016001300_record_summaries.sql` as postgres before deploying this feature. Migration 013 installation is **unconfirmed**; the summary website release was observed in the trace. No campaign import or initial setup rerun is needed. Do not apply it automatically through the read-only reader.
- Store text in the existing `overview` item's **body**, not its JSON value and not a new summary field. The narrow SECURITY INVOKER `save_record_summary` RPC creates missing/private summaries. New text is Storyteller-only; never generate or reveal summaries automatically.
- Already shared summaries use `edit_campaign_rows` and existing reveal review. Clearing retains identity/history, marks the field unrecorded and leaves People cards blank. Stale revisions reject saves and retain the draft.
- Preserve complete paged data for reveal review, account-local cache, RLS, protected notes, revision/audit safeguards, existing field IDs, references and shared-summary review. Ordinary editing is scoped by the newer handoff below. Do not restore the oversized full-editor RPC.
- Changed implementation: `record-editor.js`, `supabase-session.js`, `styles.css`, `campaign.html`, migration 013. Release query string is `20261016-summary-editor`.
- Checks **passed**: full disposable PostgreSQL migration/permission suite; `summaries-browser.cjs`; existing `record-editor-browser.cjs`; `connection-labels-browser.cjs`. Coverage includes creation, edit/clear, card/profile display, blank-card behavior, private defaults, audit, stale drafts, shared review/cancel/save, role restrictions and responsive layout. No need to repeat checks for notes-only edits.
- Guide: `docs/record-summaries.md`. Roadmap summary editing is implemented locally rather than deferred. No live campaign data was changed.
- Earlier docs-only handoff `0e85392` on `document-connection-labels-handoff` was not merged when remote state was checked for this CPAP. Its connection-label guide, import rule and refreshed historical rollout notes are included in this branch; a separate docs PR is unnecessary.

## Previous task handoff: faster record editing (merged PR #34)

- Implementation `85d806b` from `faster-record-editor` merged in PR #34 (`f092412`), verified by fetch. The user reports a large improvement after deployment; no fresh live timing or database mutation is claimed. The earlier user trace confirms the summary-editor website release was deployed, but does not establish migration 013 installation.
- The user's Performance trace measured 28.8 seconds fetching all editing data plus a 5.6-second browser task. The slowest chain was seven attribution pages. This change removes the full-campaign fetch from editor entry and ordinary save/reload.
- `campaign-loader.js` separates selected-record editing from `reviewData()`. The client-only `record-editor` scope becomes the existing detail RPC in `supabase-session.js`; source-note definitions use a filtered REST query. No new migration.
- `record-editor.js` builds closed forms/advanced controls on expansion, preserves snapshots/drafts, and waits for complete data before constructing reveal previews. Always compute bulk targets after the full load. Never reveal based only on the scoped cache. Shared edit revisions must not be rebased after dependency loading.
- Failed multi-page review reads are atomic/retryable. Navigation, logout and session expiry reject late previews/data; logout clears form snapshots/plans. Full review remains potentially slow and is deliberately deferred, not removed.
- Release query string `20261016-scoped-editor`. Guide, measured comparison and validation commands: `docs/scoped-record-editing.md`. Private recordings/exports/benchmarks remain outside this checkout.
- Validation passed: 41 unit checks; scoped large-record browser suite; existing editor, summary, connection-label/pagination, lazy-loading and auth/player/logout browser suites. No SQL changed. Local private saved-data comparison: 38 requests/5.45 MB/266,494 controls-and-options before, one request/146 KB/500 after; 17.7 s vs 0.10 s locally with mocked network, not live timing.

## Previous task handoff: descriptive editor connection headings (merged PR #35)

- `descriptive-editor-connections` includes fetched remote main `f16e07d` (portrait asset upload following PR #34). The user reports a large editing-speed improvement after deployment.
- Collapsed relationship entries now show the relationship type and other record using the edited record's perspective (forward/reverse labels). Generic selectors and reveal previews show both endpoints. Visibility badges, lazy forms, scoped loading and reveal authorization remain unchanged.
- Files: `record-editor.js`, synchronized `campaign.html` assets, existing editor browser assertions and `docs/storyteller-record-editing.md`. Release `20261016-connection-headings`; no SQL or live data changes. Packaged for user-requested CPAP; deployment remains unconfirmed.
- Verification: existing full editor browser suite passed, including new clan/affiliation/association labels, reverse sire direction, lazy controls, reveal review, conflicts, and mobile/desktop layout. JavaScript syntax and diff whitespace checks passed.

## Latest portrait request and documentation handoff

- Kevin Jackson's new image is in remote main upload `f16e07d` at `assets/kevin jackson.png` (case-sensitive). This asset commit is included in the branch base for the connection-heading CPAP.
- A read-only check before preparing SQL found existing `person:kevin-jackson` with player-visible identity and no attachment rows. Supplied portrait SQL uses `attachment:kevin-jackson:portrait`, URL `assets/kevin%20jackson.png`, alt text Kevin Jackson and initial audience Storyteller-only. Its repeat-path update preserves existing visibility. User execution/reveal is **not confirmed**; do not claim the portrait is installed or shared.
- Manual portrait SQL is recorded outside the published checkout at `/workspace/npc-imports/kevin-jackson/portrait.sql`; no database writes were performed. General attachment/reveal workflow is in `docs/storyteller-record-editing.md`.
- Descriptive connection headings and these documentation updates are packaged on `descriptive-editor-connections` for the user-requested CPAP; check remote state for PR/merge status. Deployment remains unconfirmed. No additional JavaScript or SQL changes were needed for this documentation request.

## Previous task handoff: Storyteller reveal action help (merged PR #36)

- Branch `storyteller-reveal-help` starts from fetched remote main `cf28043` (PR #35). Connection headings are merged; Kevin portrait SQL execution/reveal remains unconfirmed.
- Dashboard's three reveal actions now have hover/focus descriptions (`aria-describedby`, tooltip role, Escape dismissal) instead of the large permanent Reveal all paragraph. A short introduction remains. Scope is unchanged: checked names/summaries, all non-archived thread/session names/summaries, or checked full details. Filter-hidden selections remain included; every action still requires review and confirmation.
- Files: `record-editor.js`, `styles.css`, synchronized `campaign.html` release `20261016-reveal-help`, and authoring docs. No SQL or data changes. Packaged for user-requested CPAP; deployment remains unconfirmed.
- Verification passed: existing editor/reveal browser suite with hover, keyboard focus, Escape dismissal, unchanged bulk selection/confirmation, and mobile/desktop layout assertions. Syntax/whitespace checks passed.
- Button labels clarify the action: **Reveal selected names + summaries**, **Reveal homepage names + summaries**, **Reveal selected details**. “Review” describes the confirmation step, not a separate read-only feature. “Checked” means dashboard checkboxes, including filter-hidden selections.

## Current task handoff: omit empty organization parents

- Branch `hide-empty-organization-parent` starts from fetched remote main `5a03e8d` (PR #36).
- Organization detail pages omit the Parent organization fact when no visible parent resolves. Existing visible parents still display as links; organization type and hierarchy behavior are unchanged. No database changes or inferred parent relationships.
- Files: `app.js`, synchronized `campaign.html` release `20261016-organization-parent`. Included in user-requested CPAP; deployment remains unconfirmed.
- Verified in a local browser with mocked authorized rows: Anarchs has no Parent organization field; Night Forum retains its Anarchs parent link. JavaScript syntax and whitespace checks passed.

## Current addition: alphabetical reference lists

- On the same local `hide-empty-organization-parent` branch, Places, Organizations, Clans and Disciplines sort by displayed name with case-insensitive English/numeric collation. Sorting copies view arrays; stored ordering is not changed. Geographic groups, subgroup hierarchy, organization category filters, People sorting and Chronicle chronology are preserved.
- Sorting applies at initial model setup and every refreshed projection, including place children and organization subgroups. Release `20261016-alphabetical-lists` supersedes `20261016-organization-parent`; includes the pending empty-parent-field change. No SQL. Both changes included in user-requested CPAP; deployment remains unconfirmed.
- Verification passed in a local mocked browser: all four directory grids and Twig child groups sort alphabetically, with the no-parent omission/existing-parent link still correct. Syntax and whitespace checks passed.

## Current addition: People filter defaults

- People initially selects Kindred. Other known filters are Mortal, Ghoul, then Thin-blood, with All last. Available additional types stay before Thin-blood/All. A user's chosen filter persists within the signed-in tab as before.
- Thin-Blood/Thin-blood/Thin Blood spellings are grouped as Thin-blood for filter selection only, so Nora, Tom and Jessica do not split into duplicate filter options. No saved classifications, audiences or database rows are changed.
- Same local branch includes parent omission and alphabetical reference lists. Release `20261016-people-filters`; no SQL. Included in user-requested CPAP; deployment remains unconfirmed.
- Verification passed: local People filter check (Kindred default, All last, both Thin-blood spellings included, tab-local chosen selection), summary/browser-card suite and death-marker/browser suite. Existing card tests explicitly select All when testing unclassified fixtures. Syntax and whitespace checks passed.

Final release for these three display changes: `20261016-people-filters`. Earlier intermediate release names are historical. Branch `hide-empty-organization-parent` packages all three changes; check remote state for PR/merge status. No SQL migration or live data update is required.

## Previous task: include person types in selected-name reveals (merged PR #38)

- Branch `reveal-selected-person-types` starts from fetched remote main `213c79e` (PR #37). The preceding directory/filter changes are merged.
- Storyteller **Reveal selected names + summaries** now includes active `person.nature` fields for selected person records, using recorded values only. It still loads full dependencies, preserves hidden checked selections and requires confirmation. Other fields, clans, affiliations, death status and protected notes remain outside this action.
- The helper's include-nature flag is opt-in for this dashboard button only. Homepage and record-level Share name + overview keep their existing scope. Field label is Nature / type; hover description explains inclusion. No SQL/data changes. Release `20261016-reveal-person-types`, packaged for user-requested CPAP; check remote state for PR/merge status. Deployment remains unconfirmed.
- Verification passed: existing editor browser suite plus Kindred/Ghoul/Mortal/Thin-blood reveal preview and confirmation, cancellation without writes, filter-hidden checked people, absent-type preservation and unrelated-field privacy. Syntax and whitespace checks passed.

## Current task: Player notes for every person

- Branch `automatic-person-player-notes` is based on fetched remote main `6db7b85` (PR #38). The user requires every person to have editable shared Player notes, including future additions/placeholders.
- A read-only October 16 audit found 107 people: 30 complete panels, 77 missing, no anomalous existing note structures or archived people. Audit data stays at `/tmp/person-player-notes-audit.json`, outside the checkout. This is not a live repair claim.
- Migration `20261016001400_person_player_notes.sql` backfills missing empty shared panels and creates a deferred after-insert person trigger. Existing text/IDs/revisions/audit remain unchanged. Inserts within a transaction may supply custom notes before the default runs; imports filling existing placeholders must reuse the note row.
- Functions are SECURITY INVOKER with explicit Storyteller helper checks; no RLS/table grant changes. Private/archived people stay hidden, player editing stays body-only with revisions/audit. Unexpected archived/nested/nonshared existing notes abort safely instead of revealing/moving text. Defaults do not prevent intentional later archiving.
- Migration 014 was subsequently reported applied; see the verified read-only backfill follow-up below. No website code deployment/reimport is needed for the Player notes panels. The separate Carol-specific Player notes SQL is unnecessary after this migration, but her regular-Notes/location update is separate and must not be inferred complete.
- Guide: `docs/person-player-notes.md`; NPC import rules updated in `docs/roadmap.md`. Generic migration/tests/docs contain no private NPC SQL. Packaged with the person-basics reveal on `automatic-person-player-notes` for the user-requested CPAP; check remote PR/merge status before treating it as merged.
- Verification passed: full disposable PostgreSQL schema/import/permissions suite, including repeat migration/backfill, existing player text/audit preservation, custom import IDs, authenticated defaults, private/archived owner isolation, player body-only edits/conflicts and role denial. Existing auth/shared-notes browser suite passed. No tests connect to live Supabase.
- Live installation follow-up (October 16): user reported applying migration 014. Fresh read-only audit verified 107/107 people have complete shared Player notes panels, zero missing/structural issues, 77 new empty root notes and no queried text/metadata changes to any of the 50 previously existing Player notes rows (30 people plus other record types). Carol is included. No live write/test character was created; automatic trigger behavior was verified locally, not by inspecting the deployed trigger definition. Audit before/after files remain outside the repo.

## Current addition: person character-basics reveal

- Person detail pages now show a Storyteller-only **Reveal character basics** button beside the editor link. It selects the display name, recorded nature, outgoing organization member/associate/affiliation edges plus their relationship.role fields, clan edge, death-status row and eligible attachments. Existing dependency review includes linked names/parent sections and any eligible attachment parent entry. Summaries/aliases/stats/history/other personal connections/source archives/protected or archived descendants stay outside the selected scope.
- Targets are computed after the full reveal data load, preserving scoped ordinary browsing/editing. Uses existing confirmation, atomic edit RPC, revision conflicts, refresh and role permissions. Missing fields stay absent. It does not reveal organization pages or create/change memberships or inheritance rules.
- Website release `20261016-person-basics-reveal`; no new SQL. Files: app.js, record-editor.js, synchronized campaign.html, guide and dedicated browser coverage. Deployment is unconfirmed. Existing pending migration 014/docs/tests remain separate earlier work; do not discard them.
- Verify with `CAMPAIGN_TEST_URL=http://127.0.0.1:8028 node tests/person-basics-reveal-browser.cjs` and the existing editor/browser suite. See docs/storyteller-record-editing.md for scope and limits.
- Validation passed: dedicated person-basics browser suite (including full-load late dependencies, cancellation, conflict/retry, intended field scope, protected/archived exclusions, repeat/no-op, mobile/desktop and player/non-person control exclusion), existing full editor/reveal browser suite, JavaScript syntax and diff whitespace. These tests use mocked API responses; no live visibility change was made.

## CPAP packaging (October 16, 2026)

- Branch `automatic-person-player-notes` packages migration 014, its tests/import guidance and the person-detail **Reveal character basics** button together. Remote main was fetched and still pointed at `6db7b85` before packaging. Do not merge automatically.
- The Player notes backfill is already user-applied and verified read-only; do not tell this user to rerun it just to deploy the reveal button. Existing private campaign SQL/exports remain outside the repository and are not included in this PR.
- The website change requires deployment of `campaign.html`, `app.js` and `record-editor.js`; synchronized release is `20261016-person-basics-reveal`. It needs no additional migration. Website deployment remains unconfirmed until observed or reported.
- GitHub API PR creation has previously returned Forbidden while pushes work; if it fails again, provide the branch’s PR-creation link and state that the PR was not created.
- CPAP result: implementation commit `cf4a330` pushed successfully to `origin/automatic-person-player-notes`. `gh pr create` returned `Post https://api.github.com/graphql: Forbidden`; no PR was created by that call. Manual creation link: https://github.com/gnunnas/duluthbynight/pull/new/automatic-person-player-notes . No merge or deployment was performed.
