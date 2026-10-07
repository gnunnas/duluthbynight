# Detailed and minor NPC layout

Alan Sovereign's supplied OneNote note was explicitly authorized for public publication. Its text and recorded mechanics are authored in `campaign-additions.js`, separately from the reproducible Phase 1 baseline. Other previously supplied dossiers are not imported by this change.

## Presentation

- Overview: nature/type, clan, ambition, Humanity, generation, Blood Potency, Health, Willpower, and any recorded affiliation status. Short facts use two columns even on mobile; ambition spans the width.
- Mechanics: distinct Attributes, Skills, and Disciplines boxes. Individual entries have a name and rating; skills can have multiple specialties.
- Connections: separate boxes for groups/associates, political affiliations, and places. Lists remain separate even when they have one entry. Known roles are displayed with their organization connections.
- Narratives: optional sections for convictions, touchstones, Mask and Mien, Thralls and Tools, Relationships, Plots and Schemes, Whispers, Domain and Haven, Mortal History, Vampire History, and custom sections.
- Nested entries preserve a scheme's notes together. Attitude descriptions retain Alan's perspective and are not automatically mirrored onto the other person's page.
- Structural personal links, such as sire or employer, appear with an authored connection when possible; generic bottom sections do not repeat links already displayed.
- Sparse records do not acquire empty mechanics/history sections or a mandatory summary paragraph.

## Field structures

Each mechanic is an independently addressable content item:

```js
{
  itemKind: 'mechanic',
  fieldKey: 'mechanics.skill',
  title: 'Finance',
  value: { rating: 5, specialties: ['Stock Market'] },
  valueType: 'rating'
}
```

Discipline entries use a distinct structured value:

```js
{
  fieldKey: 'mechanics.discipline',
  title: 'Dominate',
  value: { rating: 4, referenceRecordId: null, abilities: [] },
  valueType: 'discipline_rating'
}
```

An ability may later have `name`, optional `notes`, and an optional `recordId` pointing to a real reference record. The UI renders supplied names/notes and functional links when such records exist. The original Alan note does not list selected powers. A later explicit user instruction assigns the supplied level 1 Auspex power Heightened Senses to Alan; other selected-power arrays remain empty. Selected powers open in a dismissible reference dialog while preserving the NPC page.

Narrative entries use `title`, `body`, optional `parentItemId`, and explicit references. `titleRecordId` links a heading; `links: [{text, recordId}]` links exact text within a paragraph. Text is escaped before rendering; authoring does not require raw HTML. References and ratings are validated.

## Import choices

- All nine attributes, sixteen listed skills with specialties, and four discipline ratings are transcribed. Unlisted skills are not filled with zeroes.
- Notes, nested scheme bullets, touchstones, histories, and rumors remain separately addressable. The OneNote creation date is source metadata, not an in-world event.
- Referenced people receive minimal shells. Ingrid's Ghoul nature is explicitly recorded in the note. Names alone do not imply clan, nature, or new backstory.
- The note's Camarilla connection has its own organization identity; it is not silently merged with Duluth Camarilla.
- The East Duluth townhouse and The L(oop) have location records, with no invented geographic parent. The old East Duluth house mentioned in rumors is not automatically equated with the townhouse.
- Alan's claim to The L(oop) is asserted, not assumed recognized or exclusive. It does not create property ownership relationships.
- The supplied portrait is not recreated or substituted with invented artwork.
- Individual schemes remain nested note entries in this increment. Promoting them to independent scheme records can happen later without losing their text or provenance.

There are still no authenticated/private-data permissions or editing forms. Publication of this particular note was authorized; that authorization does not turn other source notes into public imports.

## Validation

`tests/npc.cjs` loads the baseline plus additions and checks exact ratings, specialties, optional sections, sparse linked records, relationship direction, rumor state, claims, references, and the absence of invented abilities. The browser suite checks the detailed page, separation of overview/list fields, mechanic counts, section presence, selected-ability rendering using a temporary fixture, escaped text, sparse NPC pages, and the existing campaign routes at mobile and desktop widths.
