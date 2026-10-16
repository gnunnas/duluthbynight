# Storyteller record editing and reveals

Apply `supabase/migrations/20261007000300_storyteller_record_editing.sql` once in the Supabase SQL editor after migrations 001 and 002. This does not reveal any existing lore. The website must also deploy the corresponding JavaScript changes.

Open **Storyteller → Campaign records & reveals**, search for a record and choose **Edit record & reveals**. Record pages also have this button. Expand an entry, change its fields, and save. This includes notes, aliases, relationships, places, artwork paths, death status, discipline definitions and selected abilities. Structured values (such as mechanic ratings and specialties) currently use JSON. Stable record IDs, types, bookmarks, campaign identity, revision numbers and audit metadata are intentionally not ordinary editable fields. Advanced field structure is available separately; the database continues to enforce valid references and hierarchy.

To link text, choose a campaign record under **Add a link to this field** and provide the exact words already present in its Text or text Value. This creates a reference, not a new relationship or geographic parent. Existing references can be edited under **Links in text**. A new reference starts private; revealing the containing field shares its active inline references and the referenced records' names.

Collapsed **Connections** entries show the relationship and the other record, such as **Clan — Ventrue**, **Affiliated with — Camarilla**, or **Childe of — Horatio Ballard**. Direction follows the record being edited. The visibility badge remains beside the label, and the form still builds only when expanded. Reveal previews identify both endpoints. These headings do not create, edit or share relationship data.

## Portrait artwork

Portraits use `attachments` rows with `attachment_kind = portrait`, the person’s `record_id`, a null `item_id`, a `legacy_path` to the uploaded asset and descriptive `alt_text`. Uploading a file to GitHub’s `assets/` directory does not create its database attachment automatically. Check the existing record and attachments before preparing manual SQL; reuse an existing portrait instead of creating duplicates.

New portrait metadata defaults to Storyteller-only. Reveal the attachment under **Artwork** through the existing review when requested; sharing the person's name does not automatically share the portrait. Repeated portrait-path updates should preserve the attachment’s existing audience. GitHub-hosted image files themselves remain public; attachment visibility does not make an uploaded asset private. Keep character-specific manual SQL outside this published checkout and distinguish SQL supplied from SQL actually applied.

## Loading behavior

Opening an editor loads the selected record. Ordinary fields and advanced controls build when expanded. Reveal actions load the complete dependency graph before showing the confirmation; this first review may take longer. Saving/reloading refreshes the catalog and selected record. See [scoped editing, safety and performance](scoped-record-editing.md). No new migration is needed for this loading change.

## Share information with players

These are **reveal actions**: each opens a review, then the confirmation saves the visibility changes. Opening the review alone shares nothing. “Checked records” means records whose checkboxes are selected in the dashboard list.

Dashboard reveal buttons have short descriptions on mouse hover or keyboard focus, linked with `aria-describedby`. Escape dismisses the description. **Reveal selected names + summaries** shares checked records’ names/summaries and each person’s recorded Nature / type (Kindred, Ghoul, Mortal or Thin-blood), **Reveal homepage names + summaries** uses all non-archived thread/session records regardless of selections, and **Reveal selected details** reviews full saved details of checked records. Filter-hidden selections remain included. The earlier long Reveal all paragraph is now in contextual help; confirmation and reveal scope have not changed.

Imports started private, which explains the empty player homepage. Choose **Reveal homepage names + summaries** to review and share names and summary text for all non-archived threads and chronicle/session records. Or select records and choose **Reveal selected names + summaries**, which also includes the recorded Nature / type for selected people. Missing types are not invented; clan, organization memberships, stats, death status, other fields and protected notes are not added by this action. The record-level **Share name + overview** button and homepage action retain their existing scopes. Nothing is shared until you confirm the review.

Person detail pages also have a Storyteller-only **Reveal character basics** button beside **Edit record & reveals**. It reviews sharing the displayed name, recorded nature/type, outgoing organization memberships/associations/affiliations and their recorded roles, clan connection, For Real Dead? row and eligible artwork. Linked organization/clan names and required parent sections are included. It does not select summaries, aliases, histories, stats, other personal connections, source archives or protected notes. Attachment fields with an eligible parent entry include that entry as a required dependency; the preview lists every change. Archived/protected entries and their descendants remain excluded, and missing facts are not created. This action uses the complete dependency load, existing atomic reveal RPC, revision checks, confirmation and refresh. No SQL migration is needed; deploy the website assets. It does not establish new membership inheritance rules or reveal other records’ full details.

Use **Reveal all** in a record editor to review sharing all its active details, aliases, connections, artwork, status and selected abilities at once. Protected Storyteller notes and entries beneath protected or archived sections/items are excluded. Required linked record names are included, but those other records’ full details and separate source archives are not automatically shared. This shares saved entries; save any drafts first.

On a record, select individual reveal checkboxes and choose **Review selected reveals**, or use **Share name + overview**. Changing Visibility to All campaign players also opens a review before saving. The review includes parent sections/items and linked record names necessary for access. Places also include their recorded place category, so cities and districts stay distinct from individual sites. Geographic containment is still revealed separately. Sharing a section does not automatically share its entries. Sharing a record name does not share all its details. Original source archives are not automatically revealed; they can be explicitly selected. Storyteller notes cannot be revealed.

Players see the same shared information. Existing shared Player notes remain editable by players and Storytellers once their record is accessible. Editing screens are Storyteller-only. Supabase permissions enforce this, independent of the interface.

A linked name can be visible while its details remain unknown. Use the linked record's editor to reveal those separately. Record archiving is controlled by the record’s Archived at timestamp (an ISO timestamp; clear it to restore). Restore any separately archived section or entry through Supabase Table Editor before revealing it; the reveal review refuses archived dependencies.

## Saving and history

Saves use the `edit_campaign_rows` RPC. It verifies the authenticated Storyteller, campaign ownership, permitted columns, stable identities, current revisions, note protections and database constraints. A batch is atomic: a conflict or invalid reference rolls back all its edits. Existing audit triggers record changes with actor and before/after values. Power definitions now also have revisions and update attribution.

A stale draft stays in the form after a conflict. Copy any text you need, then **Reload saved entries** to get the current version before trying again. If the save succeeds but the reload fails, reload before editing again.

This phase edits existing campaign entries and adds text links. Creating complete new NPC/location records or importing source notes is a separate authoring workflow. AI authoring remains deferred.

Local verification: `bash scripts/test-supabase-draft.sh`, plus `CAMPAIGN_TEST_URL=http://127.0.0.1:PORT node tests/record-editor-browser.cjs`, `CAMPAIGN_TEST_URL=http://127.0.0.1:PORT node tests/person-basics-reveal-browser.cjs`, and `tests/supabase-browser.cjs` against a local static server. The browser tests mock the API; SQL tests use a disposable database and enforce actual permissions.

Apply migration `20261007000400_record_edit_conflicts.sql` after 003. Revision mismatches now return HTTP 409 (`PT409`) instead of the retryable database serialization code `40001`. A failed reveal batch changes nothing. The reveal popup disables resubmission of a stale batch and provides **Reload and review again** for reveal-only operations; field-edit conflicts preserve drafts for manual review.

The dashboard’s **Reveal selected details** uses only checked records, including selections retained when a filter hides them. Filters do not select or reveal records. Its review includes full active details for those records while preserving protected Storyteller notes. Choose a type or search first to narrow the scope. Source-note records are included only if selected, so their full saved transcripts can be shared. Apply migration 006 to increase the atomic batch limit from 500 to 5,000 edits; larger batches are rejected without partial writes.

Use **Select all shown** above the dashboard list to check or uncheck every record matching the current search and type filter. With no filters, it selects the entire list. Hidden selections are retained and included in the selected count. A partial selection displays an indeterminate checkbox. Selecting records never saves or reveals them; use the review action separately.

The dashboard combines text search, record type and **Reveal status** (All statuses / Revealed / Not revealed). Revealed means an active record is accessible to players, not that all its individual fields are shared. Archived records count as not revealed. **Select all shown** respects all three filters.
