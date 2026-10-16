# Record summaries

The editor has a **Summary** textarea near the top of **Edit record & reveals**, including for people and other records that have no summary entry yet. Previously, the generic field editor could only edit an existing overview, and many imports had none.

Apply [migration 013](../supabase/migrations/20261016001300_record_summaries.sql) in Supabase SQL Editor as postgres before deploying this change. It adds a narrow `save_record_summary` SECURITY INVOKER RPC, retaining existing RLS and audit triggers. No campaign reimport or automatic summaries are needed. Installation and deployment have not yet been confirmed.

## Current handoff

The summary editor merged in PR #33 (`8df46f8` on remote main, verified before the scoped-editing follow-up). The user’s uploaded trace confirms the `20261016-summary-editor` website release was running. Migration 013 installation remains unconfirmed; the trace does not prove it. Full PostgreSQL checks and the summary, existing editor, and connection-label browser suites passed. Notes-only updates do not require rerunning these checks.

## Behavior

- Enter text and choose **Save summary**. New summaries are Storyteller-only, even if the name is shared.
- Find the saved **Summary** entry below to reveal it through the existing review process when ready.
- Already shared summaries use **Review and save summary**, preserving the normal review before changes become visible to players. Cancel saves nothing.
- Clear the textarea to remove displayed summary text. This preserves the existing item and history. People cards stay blank rather than showing “No summary recorded.”
- Stale saves reject the change and retain the draft. Copy drafts before reloading. Existing record visibility, other fields and notes are not changed by saving a private summary.

## Storage and safeguards

Summaries remain `content_items` with `field_key = overview`, using `body`, as already read by the catalog, record cards and detail pages. No second summary storage or model projection was added. A missing summary gets a private overview section if necessary. Existing fields and section identities are reused.

The RPC validates Storyteller access, an active record, the expected revision and one active overview entry. It rejects an unexpected parent structure or ambiguous multiple summaries rather than choosing arbitrarily. Empty creation is a no-op. Clearing sets knowledge state to unrecorded; updates retain audit attribution. Revealed summaries are edited through `edit_campaign_rows` and reveal review instead of the private-save RPC. The migration grants no new table permissions and creates no campaign content by itself.

The summary feature originally shipped with release `20261016-summary-editor`. The newer [scoped editor](scoped-record-editing.md) loads only the selected record for private summary saves and waits for full paged dependencies before reviewing shared edits. It does not restore the oversized editor RPC or change initial login loading.

## Verification

```sh
bash scripts/test-supabase-draft.sh
node tests/summaries-browser.cjs
CAMPAIGN_TEST_URL=http://127.0.0.1:8028 node tests/record-editor-browser.cjs
node tests/connection-labels-browser.cjs
```

PostgreSQL coverage includes creation, edits/clears, private defaults on a shared person, stale revisions, audit, revealed-summary review guard and player/anonymous denial. Browser coverage includes an initially missing summary, card/profile updates, clearing without a placeholder, draft retention, shared review/cancel/save and responsive layout. Tests use synthetic/public fixtures.
