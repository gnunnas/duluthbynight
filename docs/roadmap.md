# Campaign website roadmap

## Current priority: Storyteller use

Make the site functional for the campaign's Storyteller first: reliable record editing, linking, searching, notes and reveal controls. Player-character ownership and broader player editing are deferred; do not expand those permissions as part of routine Storyteller improvements.

## Implemented: faster campaign loading

Catalog-first login, on-demand character/ability/source details, tab-local caching, and permission-filtered server search are implemented. Storyteller editing now loads the selected record and builds forms on expansion. Complete dependency data loads before reveal review. See [scoped editing](scoped-record-editing.md) for performance evidence and the remaining first-review loading cost. See [loading architecture and rollout status](campaign-loading.md) before modifying these paths. Migration 010 was reported applied by the user on 2026-10-15; the user subsequently reported live login improving from about 20 seconds to 3 seconds, with initial character details taking under a second. These are user-reported timings.

## Implemented: readable Chronicle history

Completed threads remain readable without database archiving. Chronicle links to completed threads and prior session recaps; session pages distinguish play dates from in-world dates. See [Chronicle history](chronicle-history.md) and migration 011.

## NPC import rules

- Check live records and aliases before each import. Reuse existing identities and fill out placeholders rather than creating duplicate people.
- Before creating a new record, ask what to load it as unless its type/nature is explicit or obvious from the supplied context (for example, someone under Kindred Relationships) or already established in an existing record.
- Ask only one actual clarification question at a time. When appropriate, offer a short set of mutually exclusive answers with the recommended choice first, clearly marked **Recommended**, plus a concise reason or tradeoff for each. Treat the recommendation as guidance rather than an assumed answer, and allow an exact or different answer when the supplied choices do not fit.
- Do not infer Mortal, Ghoul, or Kindred from an occupation or a Thralls and Tools heading alone. Ask about unclear wording and conflicting facts; do not invent data.
- New people default to **For Real Dead? → No**, unless the user/source explicitly supplies another death status. Existing death statuses are retained when filling out a record.
- New NPC content remains Storyteller-only unless the user explicitly requests sharing. Keep private import artifacts outside the published website checkout.
- Every person, including placeholders, gets an empty shared Player notes panel. Migration 014 backfills missing panels and provisions future people at transaction end. Keep lore private, preserve existing player text, and reuse existing note rows when filling placeholders. See [Player notes provisioning](person-player-notes.md).
- When supplied facts give a personal association a clear description, store a concise person-scoped `relationship.details` label using only those facts. Do not infer a reciprocal label or feelings. Unspecified associations remain “Associate”. See [connection labels](personal-connection-labels.md).
- End every manual NPC import SQL file with a final `SELECT` that returns a short, human-readable success message after `COMMIT`. This gives the Supabase SQL Editor a visible confirmation row instead of only “Success. No rows returned.” The import must remain repeat-safe; the message confirms execution, not that new rows were necessarily inserted on a rerun.

## Record summary editing

- The editor now includes a clearly labeled Summary textarea for each campaign entry, including entries without an existing overview field. Apply migration 013 to save missing/private summaries; deployment is not yet confirmed.
- Reuse `overview` body text for cards and detail pages. Clearing a person's summary leaves the People card blank.
- New summaries are Storyteller-only; already shared summaries use reveal review before changes are saved. Preserve edit history and reject stale revisions. Do not generate or reveal summaries automatically.
- See [summary editing and migration](record-summaries.md).

## Implemented: person basics reveal

Person detail pages have a Storyteller-only **Reveal character basics** action that reviews the name, recorded memberships and roles, death status, artwork, nature/type and clan. It waits for complete dependencies and uses the existing atomic reveal confirmation. Missing information stays absent; other lore and protected notes remain outside the selected scope. See [scope, safeguards and deployment](storyteller-record-editing.md). Website deployment is required; no new migration.

## Implemented: organization type editing

The organization editor has a plain-text Organization type field for custom labels and missing type fields. It reuses `organization.kind`, preserves visibility/audit/revisions, and reviews shared edits. Apply migration 015, then deploy the website; installation/deployment are unconfirmed. See [organization type editing](organization-type-editing.md). Browse categories and memberships are unchanged.

## Planned: membership role editing

- Add a simple Role field beside each person’s organization membership in Storyteller tools, such as Leader for An Tran’s Circle of Mercy membership.
- Allow adding, editing and clearing a role without SQL, including memberships that do not yet have a role entry.
- Reuse the existing relationship.role storage, audit history and reveal permissions. Keep the role attached to the specific membership connection.

## Personal connection labels

Implemented in PR #32; migration 012 application and website deployment still need confirmation. See [usage and storage](personal-connection-labels.md).

- Apply migration 012 to enable saving descriptive labels for existing person-to-person associations from **Edit record & reveals → Personal connection labels**.
- Labels describe the connection from the person being edited. They do not automatically appear on the other person's profile, change the connection type, or infer facts from imported prose.
- New labels are Storyteller-only. Reveal the saved `relationship.details` field through the existing reveal review when desired. Editing an already shared label also requires that review.
- Clearing a label restores “Associate”; explicit sire/employer connection types retain their structural labels. Saves preserve audit history and reject stale revisions.

## Planned: NPC discipline ability picker

- After ability descriptions are imported, add a Storyteller dropdown and Add ability button beneath each NPC discipline, similar to the Coterie entry controls.
- Offer existing abilities for that discipline, grouped by level. Support multiple selected abilities without a fixed count limit.
- Remove assignments without deleting the underlying ability records.
- Reuse existing selected-power storage, audit history, and Storyteller authorization. Preserve NPC and ability reveal permissions.
- Keep assigned abilities clickable to open the existing dismissible popup during play.
- Empty discipline catalogs should show that no abilities are recorded; do not invent ability names or descriptions.

## Deferred: player-character ownership and editing

- Add an explicit NPC / Player character classification to person records, separate from mortal / Kindred nature.
- Assign a player character to a campaign member's account independently of classification.
- Let the assigned player view and edit authorized character-sheet fields, including attributes, skills, disciplines and ambitions.
- Keep Storyteller notes and unrevealed secrets protected. Other players continue to see shared reveals only.
- Storytellers retain access to all records and character fields. Preserve audit history for player edits.
- Implement actual Supabase authorization and RLS; a PC label alone must not grant editing privileges.
- Decide the exact editable field scope and assignment-management interface before implementation.

## Other deferred work

AI-assisted authoring within the website remains a long-term goal. Complete record creation and source-import workflows are separate from the current existing-record editor.
