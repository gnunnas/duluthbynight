# Campaign website roadmap

## Current priority: Storyteller use

Make the site functional for the campaign's Storyteller first: reliable record editing, linking, searching, notes and reveal controls. Player-character ownership and broader player editing are deferred; do not expand those permissions as part of routine Storyteller improvements.

## NPC import rules

- Check live records and aliases before each import. Reuse existing identities and fill out placeholders rather than creating duplicate people.
- Before creating a new record, ask what to load it as unless its type/nature is explicit or obvious from the supplied context (for example, someone under Kindred Relationships) or already established in an existing record.
- Do not infer Mortal, Ghoul, or Kindred from an occupation or a Thralls and Tools heading alone. Ask about unclear wording and conflicting facts; do not invent data.
- New people default to **For Real Dead? → No**, unless the user/source explicitly supplies another death status. Existing death statuses are retained when filling out a record.
- New NPC content remains Storyteller-only unless the user explicitly requests sharing. Keep private import artifacts outside the published website checkout.

## Planned: easy record summaries

- Add a clearly labeled Summary field for each campaign entry in Storyteller editing, including entries that do not yet have an overview field.
- Use the saved summary on record cards and detail pages so entries can replace “No summary recorded” with a useful introduction.
- Preserve summary reveal permissions and edit history; do not generate or reveal summaries automatically.

## Planned: membership role editing

- Add a simple Role field beside each person’s organization membership in Storyteller tools, such as Leader for An Tran’s Circle of Mercy membership.
- Allow adding, editing and clearing a role without SQL, including memberships that do not yet have a role entry.
- Reuse the existing relationship.role storage, audit history and reveal permissions. Keep the role attached to the specific membership connection.

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
