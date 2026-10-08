# Storyteller record editing and reveals

Apply `supabase/migrations/20261007000300_storyteller_record_editing.sql` once in the Supabase SQL editor after migrations 001 and 002. This does not reveal any existing lore. The website must also deploy the corresponding JavaScript changes.

Open **Storyteller → Campaign records & reveals**, search for a record and choose **Edit record & reveals**. Record pages also have this button. Expand an entry, change its fields, and save. This includes notes, aliases, relationships, places, artwork paths, death status, discipline definitions and selected abilities. Structured values (such as mechanic ratings and specialties) currently use JSON. Stable record IDs, types, bookmarks, campaign identity, revision numbers and audit metadata are intentionally not ordinary editable fields. Advanced field structure is available separately; the database continues to enforce valid references and hierarchy.

To link text, choose a campaign record under **Add a link to this field** and provide the exact words already present in its Text or text Value. This creates a reference, not a new relationship or geographic parent. Existing references can be edited under **Links in text**. A new reference starts private; revealing the containing field shares its active inline references and the referenced records' names.

## Share information with players

Imports started private, which explains the empty player homepage. Choose **Review homepage records** to review and share names and overview text for active threads and chronicle/session records. Or select records and choose **Review names + overviews**. Nothing is shared until you confirm the review.

Use **Reveal all** in a record editor to review sharing all its active details, aliases, connections, artwork, status and selected abilities at once. Protected Storyteller notes and entries beneath protected or archived sections/items are excluded. Required linked record names are included, but those other records’ full details and separate source archives are not automatically shared. This shares saved entries; save any drafts first.

On a record, select individual reveal checkboxes and choose **Review selected reveals**, or use **Share name + overview**. Changing Visibility to All campaign players also opens a review before saving. The review includes parent sections/items and linked record names necessary for access. Places also include their recorded place category, so cities and districts stay distinct from individual sites. Geographic containment is still revealed separately. Sharing a section does not automatically share its entries. Sharing a record name does not share all its details. Original source archives are not automatically revealed; they can be explicitly selected. Storyteller notes cannot be revealed.

Players see the same shared information. Existing shared Player notes remain editable by players and Storytellers once their record is accessible. Editing screens are Storyteller-only. Supabase permissions enforce this, independent of the interface.

A linked name can be visible while its details remain unknown. Use the linked record's editor to reveal those separately. Record archiving is controlled by the record’s Archived at timestamp (an ISO timestamp; clear it to restore). Restore any separately archived section or entry through Supabase Table Editor before revealing it; the reveal review refuses archived dependencies.

## Saving and history

Saves use the `edit_campaign_rows` RPC. It verifies the authenticated Storyteller, campaign ownership, permitted columns, stable identities, current revisions, note protections and database constraints. A batch is atomic: a conflict or invalid reference rolls back all its edits. Existing audit triggers record changes with actor and before/after values. Power definitions now also have revisions and update attribution.

A stale draft stays in the form after a conflict. Copy any text you need, then **Reload saved entries** to get the current version before trying again. If the save succeeds but the reload fails, reload before editing again.

This phase edits existing campaign entries and adds text links. Creating complete new NPC/location records or importing source notes is a separate authoring workflow. AI authoring remains deferred.

Local verification: `bash scripts/test-supabase-draft.sh`, plus `CAMPAIGN_TEST_URL=http://127.0.0.1:PORT node tests/record-editor-browser.cjs` and `tests/supabase-browser.cjs` against a local static server. The browser tests mock the API; SQL tests use a disposable database and enforce actual permissions.

Apply migration `20261007000400_record_edit_conflicts.sql` after 003. Revision mismatches now return HTTP 409 (`PT409`) instead of the retryable database serialization code `40001`. A failed reveal batch changes nothing. The reveal popup disables resubmission of a stale batch and provides **Reload and review again** for reveal-only operations; field-edit conflicts preserve drafts for manual review.
