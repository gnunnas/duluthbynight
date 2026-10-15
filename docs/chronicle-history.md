# Chronicle and completed history

Apply [migration 011](../supabase/migrations/20261015001100_chronicle_history_catalog.sql) after migration 010, then deploy the website changes. This read-only RPC replacement adds `thread.status` and `session.inWorldDate` to the catalog; it retains SECURITY INVOKER, existing table RLS, and authenticated-only execution. It changes no campaign entries or reveals.

## Rollout status (2026-10-15)

The user applied migration 011 and the approved private recap transaction. A fresh read-only database check confirmed the shared completion status was saved. These website changes are being released separately; this project does not need another SQL run for this release. Check current deployment state before diagnosing an active-list display as a data problem.

## Browsing

- **Tonight** and **Chronicle → Active threads** show unresolved threads.
- **Chronicle → Completed threads** opens `#threads?view=completed`. Completed threads remain readable through their existing URLs, related-record links, and authorized search results.
- **Chronicle → Past session recaps** opens `#chronicle?view=past`. Chronicle itself shows the latest session; older recaps remain available in history.
- Imported OneNote/source archives remain separate from the Chronicle listing. History links do not grant access to hidden records.

## Storage

`thread.status` is a root content-item fact with value `active` or `completed`. A missing, hidden, or unrecognized value displays as Active. Closing a thread must not set the record's `archived_at`: database archiving continues to have its existing permission semantics and hides archived records from players. Completion is a story state, independent of archiving.

The status section and item must be shared when players should see completion. The thread record must also already be shared. Existing field editing can update an authored status item; adding a dedicated status picker for arbitrary threads is separate work.

`session.date` describes the play date. Its optional `iso` value provides an explicit sort key for newest-first history. Dates without a recorded ISO key retain their relative order after dated sessions; do not infer a missing year from a stable record ID. `session.inWorldDate` is independent and can retain month precision when no exact day was supplied. Both dates display on session pages. This does not rewrite dates on older sessions.

The catalog contains these small fields so list/history navigation needs no editor bundle or full recap download. Full session text still loads only when opening that session. Keep the model script's release version synchronized with the campaign app, loader, login script, and styles when changing projections.

## Recap updates

Review the live database and existing identities before proposing changes. Ask one actual clarification question at a time. Distinguish an assigned task from a completed one, observed actions from ability ratings, and a goal from established ownership. Do not update the boon ledger unless requested.

Private original text, user corrections, live snapshots, session import SQL, and previews belong outside the website checkout. Publish only the approved edited recap in Supabase, preserving withheld passages in a Storyteller-only source record. Keep newly shared NPC facts separate from their existing private sections.

The current recap workflow uses the dedicated read-only database account, so applying the private transaction requires Supabase SQL Editor. A transaction should guard expected revisions, reuse existing IDs, reject duplicate identities, preserve audit attribution, and be safe to rerun without overwriting later edits. Never put a live campaign export or private recap into a public migration.

## Checks

```sh
node --test tests/chronicle.cjs tests/campaign-loader.cjs tests/model.cjs tests/npc.cjs tests/watchtower.cjs tests/notes.cjs tests/supabase-adapter.cjs
CAMPAIGN_TEST_URL=http://127.0.0.1:8028 node tests/chronicle-browser.cjs
bash scripts/test-supabase-draft.sh
```

These tracked tests use public snapshots and synthetic history fixtures. Actual recap import checks and role-specific browser previews remain with their private session artifacts outside this checkout.
