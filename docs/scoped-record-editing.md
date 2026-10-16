# Record editing without campaign-wide loading

## Why this changed

The user's October 15 Performance trace showed about 28.8 seconds fetching 38 editor requests, then a 5.6-second main-thread task. Seven sequential `content_items_sources` pages occupied about 24 seconds. Opening one character's editor was fetching the whole campaign, and closed field panels were still building every input and advanced selector.

This follow-up is on `faster-record-editor`, based on remote main after PR #33. It requires **website deployment only**, with release `20261016-scoped-editor`. No new SQL or campaign reimport is needed. The existing summary/connection save features still require migrations 013/012 respectively; their installation is separate from this loading change. Deployment of this follow-up is not yet confirmed.

## Release handoff

Implementation and checks are complete on `faster-record-editor`, packaged for the user-requested CPAP. Check remote state for PR/merge status. CPAP means commit, push and provide a PR link, without merging automatically. No database changes or deployment were performed for this follow-up.

Deploy the website files together, retaining the synchronized `20261016-scoped-editor` asset versions in `campaign.html` and the version passed to delayed `app.js`. Check character editing and reveal review separately after deployment. Keep full-review performance as a separate remaining task rather than describing all authoring as instantaneous.

## Loading boundaries

- Login and the Storyteller dashboard use the authorized catalog. The dashboard's filters, selections, names, roles and Tonight controls do not need every campaign entry.
- Opening **Edit record & reveals** loads the selected record's detail bundle. `record-editor` is a **client-only loader scope** translated to the existing `load_campaign_page` **detail** RPC; do not send the new scope to the SQL function.
- Source-note editors additionally fetch `sources` filtered by `note_record_id` with normal RLS and pagination. Other record editors do not fetch sources or attribution tables. Sources remain saved in the database; they have not been deleted or archived.
- Repeated opens reuse the signed-in tab's memory cache. Ordinary saves/reloads refresh the catalog and selected record, even if a previous review loaded everything. This keeps changed names, relationships and statuses current without redownloading the full editor graph. Catalog refresh remains a possible save-time cost.
- Summary and personal-connection controls remain immediately available. Other form controls are created when the corresponding row is expanded; advanced structural controls are created only when that subsection opens. Closing/reopening preserves draft controls. A render keeps row snapshots so later dependency loading cannot silently replace a form's revision.

## Reveal safety

`editorRows()` is now a **partial cache during ordinary editing**. Do not assume every content item, source, reference or provenance row is present.

Before any reveal preview, `loadRevealData()` requires Storyteller access and loads the existing complete, 24-table paged editor graph. This retains archives, attribution, references and the existing reveal planner. It never uses the oversized full-editor RPC. Every page must succeed before the new graph is published; failures retain the previous scoped data and drafts and block the preview. The completed projection must validate.

Compute bulk/record reveal targets **after** this load, not from the partial cache. Shared-summary, connection-label and generic field edits capture their original revisions before loading and reject newer saved revisions rather than silently rebasing drafts. The existing SQL optimistic revision checks remain authoritative at confirmation.

A full-data read does not rerender the editor or save anything. Navigation cancels a pending preview, including navigating away and back to the same record. Sign-out/expiration clears row snapshots, plans and caches, and rejects late responses. Confirmation remains explicit; protected notes and archived entries retain their existing exclusions. Players cannot initiate the full reveal-data read through the session API.

The first reveal review can still incur the old campaign-wide fetch cost. This change moves that cost out of ordinary editing; it does not claim to optimize provenance SQL. Full review data is reused until refresh. Further review-loading optimization must preserve complete dependency checks.

## Evidence and checks

A local Chromium comparison used the same **private saved campaign export**, mocked API responses without real network delay, and the before/after code:

| Opening Kevin's editor | Before | After |
|---|---:|---:|
| Additional API requests | 38 | 1 |
| Uncompressed response bytes | 5,446,789 | 145,659 |
| Editor inputs, selectors, textareas and options | 266,494 | 500 |
| Local time until heading appeared | 17,692 ms | 103 ms |

These are local rendering/fixture measurements, not deployed loading times or a live Storyteller benchmark. The uploaded trace measured a different machine and real network. The private export, trace and comparison script stay outside this published repository.

Verification:

```sh
node --test tests/campaign-loader.cjs tests/model.cjs tests/npc.cjs tests/watchtower.cjs tests/notes.cjs tests/supabase-adapter.cjs
CAMPAIGN_TEST_URL=http://127.0.0.1:8028 node tests/scoped-editor-browser.cjs
CAMPAIGN_TEST_URL=http://127.0.0.1:8028 node tests/record-editor-browser.cjs
node tests/summaries-browser.cjs
node tests/connection-labels-browser.cjs
CAMPAIGN_TEST_URL=http://127.0.0.1:8028 node tests/campaign-loading-browser.cjs
CAMPAIGN_TEST_URL=http://127.0.0.1:8028 node tests/supabase-browser.cjs
```

The new browser suite uses synthetic large-record data. It verifies no campaign-wide fetch on entry, detail failure/retry, lazy forms/advanced controls, draft retention, complete reveal waiting, navigation cancellation, stale shared drafts, source-note editing and responsive layout. Existing tests cover summaries, personal labels, atomic multi-page failures/retries, protected/bulk reveals, players and logout. No SQL changed, so the previously passing migration suite does not need rerunning for this client-only change.

After deployment, repeat a Performance trace of the first editor open. Expect a selected-record `detail` request, no unfiltered `content_items`/`*_sources` reads, and no several-second mass-form construction. Exercise reveal review separately and wait for its complete dependency check.
