# Campaign field model and migration plan

Status: **Phase 1 static normalization implemented; Phases 2 and 3 remain proposed**.

See [Phase 1 migration report](phase-1-migration-report.md) for the concrete outputs, retained source, validation, and open questions. The field vocabulary below includes future capabilities, not a claim that all detail interfaces or permissions exist today.

This document defines a flexible model for Duluth by Night and a staged migration from the current static website. The design does not authorize importing the supplied OneNote screenshots or publishing their contents. Phase 1 implements the public data foundation and route adapter without introducing a database; future phases remain separate. Private notes in those examples are deliberately not reproduced here.

## 1. Decisions and scope

Preserve the existing mobile-first Lake Superior / industrial Duluth / Vampire noir design and hash-based record links. The data model should support both a two-bullet NPC and a substantial dossier without requiring empty sections or a different template.

Use these primary record types:

- **Person:** NPC or player character, with optional identity, description, mechanics, and notes.
- **Place:** geographic area, individual site, or nested space.
- **Clan:** lineage record and campaign-specific clan notes.
- **Organization:** sect, crew, council, cult, family, business, institution, or another recorded organization type. Replace the separate group/faction storage, while retaining useful presentation categories.
- **Thread:** an active or historical campaign concern.
- **Scheme:** an individual plan or project. It can belong in an NPC's Plots and Schemes section and connect to a thread without being the same thing as that thread.
- **Session:** a chronicle record with recap and sources for discoveries.
- **Event:** an occurrence that may appear in several histories, with an exact, approximate, or unknown campaign date.

Each can have optional sections, individual content items, typed connections, names, and attachments. Standard templates are suggestions, not required forms. Do not derive campaign lore from game defaults, real-world geography, note indentation, or a person's associations.

Confirmed campaign corrections and rules to preserve:

- Duluth → Eldes Corner → Nopeming Sanatorium.
- Twig → The Watchtower and Twig → Bliss. These corrections are already present in the local working tree; do not lose them during migration.
- Canal Park and The Rack are **one place with contextual names**. Canal Park is the mortal/common name; The Rack is the Kindred name. Retain the existing `rack` route key.
- Night Forum members are Anarchs; not every Anarch is a Night Forum member. Represent that implication explicitly.
- Territory describes a region. Domain describes a claim over an area, which can be a building, street, region, or city.
- Clan identity, organizational membership, political affiliation, ownership, residence, and domain are different facts.

Remaining geographic questions do not block this design: the parent of Canal Park/The Rack needs confirmation, as does whether West Duluth is the primary parent of Eldes Corner. The current `rack` placement under Downtown is a legacy value, not a newly validated decision. Keep Twig's current top-level placement unless the user supplies its containing geography.

## 2. Common records and identity

### Record shell

| Field | Required | Meaning |
| --- | --- | --- |
| `id` | Yes | Immutable, globally unique record ID. |
| `recordType` | Yes | One of the types above. |
| `campaignId` | Yes in the database; dataset-level in static exports | Campaign boundary; all references must stay within it. |
| `displayName` | Yes | A safe label for the record's intended audience; not necessarily a legal or true name. |
| `routeKey` | Yes, for navigable records | Stable URL key within its route collection. Derived at creation; not changed automatically when names change. |
| `accessPolicyId` | Future permission boundary | Controls whether the record shell itself is readable. No private shell is shipped to the static client. |
| `createdAt`, `updatedAt` | System-managed | Editorial timestamps, never in-world birth/founding dates. |
| `schemaVersion` | Dataset-level | Version of the interchange model; used for migration. |

For the static migration, use globally unique IDs such as `person:kyra`, `place:bliss`, and `organization:bliss`. The last two are distinct records even though their existing route keys match. Keep old route keys and provide redirects. Later Supabase can retain these text IDs or map them to UUIDs through a persisted one-to-one mapping; no externally referenced ID is silently regenerated.

A person's only necessary authored input is a display name. An ID and route key can be generated. Everything else is optional. Missing information does not establish absence. Do not require a full character sheet or invent an NPC importance ranking.

### Names and identities

Store alternate names as individual entries, not a slash-separated string:

| Field | Meaning |
| --- | --- |
| `id`, `recordId` | Stable name-entry ID and owning record. |
| `text` | Name or alias. |
| `nameKind` | `common`, `legal`, `alias`, `mask`, `title`, `true_name`, or `unspecified`. |
| `context` | Optional recorded usage: mortal, Kindred, professional, historic, etc. Context is not an access policy. |
| `validFrom`, `validUntil` | Optional date expressions. |
| `accessPolicyId` | Future entry-level permission. |
| `detailsItemId` | Optional explanation kept separately from the name's existence. |

Search all readable names and send every name to the same record. A mask name can be known while its purpose is unknown. Reused names do not mean reused identities: two people named the same thing have separate IDs.

For Canal Park/The Rack, retain `place:rack` and `routeKey: rack`; propose `displayName: Canal Park · The Rack` with two name entries and their recorded contexts. The final UI can choose a shorter label without creating a second place.

## 3. Flexible sections, facts, and attachments

### Section

Fields: `id`, `recordId`, optional `templateKey`, `heading`, `sortOrder`, and future `accessPolicyId`.

A section organizes entries. Its title must not reveal hidden material. A section appears only when the audience has readable content, unless the author explicitly supplies a readable empty-state note. No mandatory empty sections for minor NPCs.

### Content item

| Field | Meaning |
| --- | --- |
| `id`, `recordId`, `sectionId` | Stable identity, owning campaign record, and placement. |
| `subjectRef` | Optional typed reference to the relationship, claim, office, appointment, or name this item explains. Both subject and owning record must be readable before displaying the item. |
| `parentItemId` | Optional nested bullet/entry; must share the owning record and have no cycle. |
| `itemKind` | `fact`, `note`, `rumor`, `theory`, `conditional_development`, `directory_entry`, `mechanic`, or `custom`. |
| `fieldKey` | Optional stable semantic key such as `person.nature`, `person.ambition`, or `place.kind`. |
| `title` | Optional short heading. |
| `value`, `valueType`, `qualifier` | Optional structured value; qualifier preserves “effective,” “approximately,” and similar distinctions. |
| `body` | Optional prose/ordered rich-text content. Never execute arbitrary imported HTML. |
| `knowledgeState` | `recorded`, `unknown`, `not_applicable`, `rumor`, `disputed`, or `theory`. `recorded` means the note asserts it, not that an NPC's belief is objectively true. |
| `perspectiveRecordId` | Optional person/organization whose belief or description this represents. |
| `sourceRefs` | Optional links to sessions, events, or securely stored source material. |
| `validFrom`, `validUntil`, `lastConfirmedInSessionId` | Optional history/currentness information. |
| `sortOrder`, `accessPolicyId` | Ordering and future permissions. |

An absent item means unrecorded, while an explicit `unknown` or `not_applicable` item conveys a deliberate statement. Avoid generic blank “Unknown” blocks for every possible field. Never convert “unknown” to zero, “independent” to missing, or approximate dates to invented exact dates.

Use `subjectRef: {kind, id}` with validated subjects; it is not an arbitrary URL or an unvalidated string. The UI can display an authorized relationship detail from either endpoint, but its original owning record remains the authorization boundary. Shared notes may instead belong to a separately permissioned source item. Do not duplicate secret explanations into both endpoint records.

Each fact is an independent item when it may need its own reveal boundary. Do not put private information beside public values inside one freely readable JSON object. The future database may use a separate row per structured attribute/skill if those values need separate permissions. The interface can still display them together as a character sheet.

### Date expression

Fields: `text`, `precision` (`exact`, `year`, `range`, `approximate`, `unknown`), optional `start`, `end`, and `calendar` (`campaign`, `real_world`, or a named campaign system). Structured dates are optional; original wording remains available. Support dates outside ordinary application timestamp ranges, including BCE, as text or explicit year-era values. An exact ISO date is appropriate only when established.

OneNote creation/modification timestamps belong to source metadata, not campaign histories. Do not infer the session year from a display string if the source does not establish it; preserve the existing session ID and date string with any provenance caveat.

### Sources and provenance

A source record has `id`, `sourceKind` (`session`, `event`, `note`, `user_confirmation`, or `other`), optional `recordId`, optional safe label, original editorial date metadata, and future `accessPolicyId`. External locator/raw source content is separately permissioned, not embedded in public links. A `sourceRef` is `{sourceId, optional locator}`; a locator can be an entry ID or a nonsecret passage reference, and must not contain private note text. Missing source means unrecorded provenance. A source being readable does not automatically reveal every fact attributed to it, or vice versa.

### Attachment

Fields: `id`, owning `recordId` or `itemId`, `mediaType`, `storageKey`, optional `caption`, `altText`, `sortOrder`, and future `accessPolicyId`.

Supports portraits, maps, floor plans, documents, and custom diagrams. An image can reveal more than its caption; protect the asset itself and any thumbnails. Link repeated attachments rather than copying them. Static assets contain only approved public material; future private assets require protected storage and authorized delivery.

## 4. Record-specific field vocabulary

These are optional semantic fields/sections. Revealable values use content items, name entries, or relationship rows; the following tables do not imply one public row containing every field.

### People

| Category | Fields / content |
| --- | --- |
| Identity | Names, pronouns, optional NPC/player-character designation, portraits. |
| Classification | Recorded nature/type; optional subtype; clan connection or explicit clan status; affiliation status. |
| Campaign status | Recorded current status with provenance; no interpretation of strikethrough as death. |
| Description | Appearance, mannerisms, conditional appearance, voice, short summary. |
| Motivations | Ambition; separate convictions; touchstone relationships and contextual notes. |
| Mechanics | Humanity, generation with qualifiers, blood potency, Health/Willpower, attributes, skills/specialties, disciplines/powers, merits/flaws when supplied. |
| Connections | People, organizations, offices, places, clan, domain claims, threads, schemes, sessions, and events. |
| Histories | Mortal and vampire history entries; shared events only where useful. |
| Flexible sections | Mask and Mien, Thralls and Tools, Relationships, Plots and Schemes, Whispers, or custom headings. |

Keep the current Kindred/Mortal/Ghoul/Thin-Blood labels during migration; do not impose a deeper nature hierarchy without campaign direction. Caitiff can be an explicit clan status without creating an ordinary clan membership. A rumor about ancestry does not replace a recorded clan or clan status.

An alias, a public persona, a disguise, and a true name may differ. Conditional appearance should carry its condition in the entry. Do not infer clan, lineage, age, political affiliation, employment, or ownership from another connection.

### Places

| Category | Fields / content |
| --- | --- |
| Classification | `place.kind`: city, community, district, neighborhood, suburb, territory, street, building, business site, floor, room, network, or supplied custom kind. |
| Geographic hierarchy | One primary `contained_in` connection when known. No stored duplicate child list. |
| Names | Contextual names/aliases on one record. |
| Overview | Summary, appearance, atmosphere, recorded address/directions, optional coordinates. |
| Area information | Feeding conditions, customs, hazards, facilities, access conditions; flexible entries. |
| Important connections | NPCs/organizations, key locations, nearby sites, connected routes, scenes, histories, threads. |
| Domain and property | Separate claims, ownership, management, residence, haven use, and access relationships. |
| Detail modules | Tenant/floor directory, security, resources/mechanics, maps and floor plans, custom sections. |

A floor, room, tenant, or officer does not need a full record until it needs an independent detail page or connections. Start with entries. A directory entry may link to a tenant organization, a site it occupies, and an optional floor record. Promoting an entry to a record preserves its provenance and replaces its old reference with a linked entry; do not clone the same information into two authoritative copies.

A business organization and its premises are distinct when both are useful, even when they share a name. This is why the existing Bliss group and Bliss place must retain distinct identities.

### Clans

Fields/content: name, aliases, optional campaign summary, individual campaign notes, linked internal organizations, related threads/events/sessions. Member lists derive from readable clan relationships. Internal groups are organizations; joining a clan does not automatically join one of its groups. Use campaign notes rather than automatically importing generic game lore.

### Organizations

Fields/content: names, organization kind (sect, crew, council, cult, family, business, institution, unspecified/custom), summary, recorded operating areas, individual notes/history, related organizations, offices, and membership connections.

The kind affects browsing, not the allowed relationships. A roster can be grouped by recorded clan or location as a display choice; those headings are not automatically organizational branches. Global and local organizations have separate records only when campaign data establishes both. A political organization is not forced into one geographic parent.

### Threads, schemes, sessions, and events

- **Thread:** name, summary, optional recorded status, related records, developments/questions, and sources. No automatic “active” status assigned to every imported concern.
- **Scheme:** title, plan entries, recorded intent/status, optional owner/participants/targets and sources. Only readable schemes appear on an NPC's page. A scheme can connect to a thread but remains individually revealable.
- **Session:** title, original date expression, recap entries, encountered/referenced records, discoveries, and optional event links. In-world timing and actual play date are separate when both exist.
- **Event:** title, date expression, notes, participants, locations, and source sessions. Histories can reference a shared event or remain narrative entries; never require an event record for every bullet.

A secret objective and a publicly observed activity can be distinct entries about the same scheme. Do not expose the objective by revealing the activity.

## 5. Typed relationships

### Relationship record

Fields: `id`, `relationshipType`, `fromRecordId`, `toRecordId`, optional `contextRecordId`, `knowledgeState`, optional `perspectiveRecordId`, `validFrom`, `validUntil`, optional `lastConfirmedInSessionId`, `sourceRefs`, and future `accessPolicyId`.

Notes are separate content items attached to the relationship, with their own future permission boundaries. `contextRecordId` identifies the relevant office, organization, place, or scheme where appropriate. An untyped association is valid; never manufacture a more specific type during migration.

The relationship-type registry defines allowed endpoint types, forward label, reverse label, whether the relationship is symmetric, and any cardinality/inheritance rules. A single row generates both displayed directions. Directed facts do not automatically imply reciprocal attitudes.

| Stored direction | Forward display | Reverse display | Rule |
| --- | --- | --- | --- |
| Person → person: `associated_with` | Associated with | Associated with | Symmetric; exact meaning unknown. |
| Person → person: `sire_of` | Sire of | Childe of | Directional; only when established. |
| Person → person: `employs` | Employs | Employed by | Directional. |
| Person → person: `owes_boon_to` | Owes a boon to | Is owed a boon by | Separate outstanding/resolved details; do not infer debt size. |
| Person → person: `regards_as_rival` | Regards as a rival | Regarded as a rival by | One-sided perspective; do not infer mutual hostility. |
| Person → person: `has_touchstone` | Touchstone | Touchstone of | No inference of the touchstone's knowledge. |
| Person → clan: `clan_member_of` | Clan | Recorded members | Recorded lineage/classification, not organizational membership. |
| Person → organization: `member_of` | Member of | Members | Can participate in explicit inheritance. |
| Person → organization: `associate_of` | Associated with | Associates | Does not automatically inherit membership. |
| Person → organization: `affiliated_with` | Affiliated with | Affiliates | Political or other affiliation, not necessarily formal membership. |
| Place → place: `contained_in` | Within | Contains | Primary geographic hierarchy; at most one active primary parent. |
| Place → place: `near` | Near | Near | Symmetric; no invented distance. |
| Place → place: `overlaps` | Overlaps | Overlaps | Symmetric; does not create a breadcrumb parent. |
| Place → place: `connected_to` | Connected to | Connected to | Type-specific notes for tunnel/route etc.; directional routes use a separate type. |
| Person → place: `associated_with_place` | Associated place | Associated people | Meaning unknown. |
| Person → place: `resides_at` | Resides at | Residents | Does not imply ownership or domain. |
| Person → place: `works_at` | Works at | Workers | Separate from employing organization. |
| Person → place: `visits` | Visits | Visitors | Optional temporal context. |
| Person → place: `uses_as_haven` | Haven | Haven users | Separate from ownership/domain. |
| Person/organization → place: `owns` | Owns | Owners | Multiple owners possible; history retained. |
| Person/organization → place: `manages` | Manages | Managed by | Separate from owning. |
| Organization → place: `operates_at` | Operates at | Organizations operating here | Does not establish geographic scope or ownership. |
| Organization → place: `headquartered_at` | Headquarters | Headquarters of | Only when recorded. |
| Organization → place: `operates_in` | Operating area | Organizations active here | Scope, not containment. |
| Organization → organization: `subgroup_of` | Subgroup of | Subgroups | Does not inherit person membership unless a rule says so. |
| Organization → organization: `affiliated_with` | Affiliated with | Affiliations | No automatic command structure or membership implication. |
| Organization → clan: `internal_group_of` | Associated clan | Internal groups | Organizational and lineage records remain distinct. |
| Area place → place: `key_location` | Key locations | Featured in areas | Curated relevance, not physical containment. |
| Scheme → person/organization: `targets` | Targets | Targeted by schemes | No reverse intention inferred. |
| Scheme → person/organization: `participant` | Participants | Participating schemes | Do not infer author or leader. |
| Scheme → person/organization: `planned_by` | Planned by | Plans | Only when known. |
| Scheme → thread: `contributes_to` | Related thread | Schemes | No automatic shared visibility. |
| Session → record: `references` | Referenced records | Session references | Migration default; not proof of physical attendance. |
| Thread → record: `involves` | Related records | Related threads | Migration default; no specific role inferred. |
| Event → record: `involves` | Related records | Events | Participants/locations can use more specific types when established. |
| Any compatible records: `related_to` | Related | Related | Last-resort explicit association with endpoint validation. |

Relationship types can be extended through a controlled vocabulary. For example, “front person” may start as a relationship detail; the author should decide whether it means public representative, manager, employee, or something else before it is mapped to a stricter type. Descriptive labels such as “Threat” or “Grateful” can be perspective notes, independent of a structural relationship.

### Memberships and offices

Membership connections can carry an optional role entry, but a **formal office** gets a distinct record/table:

- Office: `id`, `organizationId`, `title`, optional `jurisdictionPlaceId` and notes.
- Appointment: `id`, `officeId`, `personId`, optional dates, sources, and future access policy.

One person can hold several offices. An office can have historical or simultaneous appointments. Do not impose uniqueness for current holders unless that office's rules establish it. Appointment does not silently create clan membership, residence, or organizational membership. A role string alone is not automatically upgraded to an office.

### Domain claims

Use separate claim rows: `id`, `placeId`, optional `claimantRecordId` (person or organization), recorded `status` (`unspecified`, `asserted`, `recognized`, `contested`, `historical`), optional dates, sources, and future access policy. Keep claim details as separate items.

Multiple claims can concern the same place. Claimant can remain null for a recorded claim with unknown claimant. A claim is not proof of ownership, exclusive control, or recognition by others. A city-wide claim does not automatically assign claims to every nested site. Any “within a claimed area” display is a derived geographic context, clearly distinguished from a directly recorded claim and filtered by visibility.

### Membership inheritance

Store an explicit rule rather than deriving membership from every parent:

`membershipImplication: {id, sourceOrganizationId, targetOrganizationId, eligibleConnectionTypes, enabled, sourceRefs, accessPolicyId}`

For the confirmed Night Forum rule:

- Source organization: Night Forum.
- Target organization: Anarchs.
- Eligible connection: `member_of`.
- Direction: Night Forum → Anarchs only.
- UI: “Anarch affiliation via Night Forum.”

Derive results; do not persist duplicate person memberships. Preserve the full path for explanations, deduplicate rosters, reject cycles, and evaluate active temporal context. Associates do not inherit membership by default. Nora's existing summary calls her an associate, so migration alone must not upgrade her to a confirmed member or derive her Anarch affiliation. A direct independent Anarch connection would be a different fact.

Inherited membership is a subset relationship, not a claim about leadership, command, loyalty, shared alliances, clan, or residence. If a person has both a direct and derived affiliation, show both provenance paths without duplicating the person.

## 6. Future visibility and reveal behavior

This is a future authenticated capability, not a static-client toggle. Until it exists, only approved public data may enter client files, git-tracked data, static images, or exported public datasets. Do not import the supplied private dossiers into this repository.

Use future access policies and grants covering record shells, names, content items, relationship existence, relationship details, claims, offices/appointments, implication rules, sources, and attachments. Audience classes: Storyteller, campaign players, and selected players or explicit audience groups. Public web access is a separate choice; “known by players” does not mean “public on the Internet.”

A concrete future policy contract:

- `accessPolicies`: `id`, `campaignId`, `defaultAudience` (`storyteller_only`, `campaign_players`, `public`, `selected`).
- `accessGrants`: `id`, `policyId`, `principalId`, `permission` (`read` or explicitly authorized write capabilities).
- `campaignMemberships`: authenticated user, campaign, and server-assigned role. Users cannot grant themselves Storyteller permissions.
- Optional reveal provenance: granted by whom, when, and in which session. Access grants are editable; they are not themselves secret game facts presented to players.

Missing access configuration on newly authored future content defaults to Storyteller-only. Existing static content is audited before being marked public; no blanket permission migration based on merely having been in OneNote or a screenshot. Reading a record shell does not grant reading its child entries. Child access cannot bypass a hidden owning record or section.

Examples of intended behavior, without importing campaign secrets:

- Revealing one scheme shows only that scheme and readable entries, not all schemes owned by the NPC.
- Revealing a relationship's existence does not reveal its private explanation.
- Revealing a mask does not reveal the underlying identity unless a separate readable connection establishes it.
- Hidden clan/membership connections do not appear in rosters or search.
- A derived affiliation requires a readable membership path and rule; a hidden group must not be exposed by “via…” labels. Explicitly revealed affiliation can be recorded independently if its hidden derivation must remain concealed.
- Hidden content is absent from search suggestions, result counts, related cards, section headings, breadcrumbs, summaries, image thumbnails, and source links.
- A visible record whose geographic parent is hidden omits that ancestor without inventing a different parent. Its children remain subject to their own access rules.

Implement enforcement in Supabase row-level security and protected storage, with policies on all relevant tables. Search, views, derived membership queries, and server endpoints must preserve caller permissions; do not use privileged/service-role access to assemble a player response. Do not send private data and hide it with CSS or JavaScript. Permission-aware derived queries must be tested with actual principals, not just a frontend role switch.

Public summaries are editorial content that needs review: filtering rows cannot remove secrets already copied into a readable paragraph. Authenticated notes can have granular permissions while a separately curated public overview remains concise.

## 7. Database-ready layout without building the database now

A plausible future relational layout:

| Tables | Responsibility |
| --- | --- |
| `campaigns`, `campaign_memberships` | Campaign boundaries and authenticated membership. |
| `records`, subtype tables | Global identity plus structural person/place/clan/organization/thread/scheme/session/event metadata. Revealable lore stays in permissioned rows. |
| `record_names` | Alternate names, contexts, and permissions. |
| `sections`, `content_items` | Flexible narratives, structured facts, nested entries, ordering. |
| `relationship_types`, `relationships` | Validated endpoints and reciprocal labels. |
| `membership_implications` | Explicit derivation rules. |
| `offices`, `appointments` | Positions and officeholder history. |
| `domain_claims` | Claims with person/organization claimants. |
| `attachments`, protected storage | Media and documents. |
| `source_links`, `route_aliases` | Provenance and durable navigation. |
| `access_policies`, `access_grants` | Granular access control. |

A common records registry allows foreign keys for relationship endpoints despite different record types. Every table needs campaign scoping; prevent cross-campaign references with composite keys/constraints or equivalent validated transactions. Validate endpoint type compatibility and hierarchy cycles, not just foreign-key existence. Keep editorial timestamps distinct from in-world date expressions.

Store stable semantic keys and structured values in content items when useful, while allowing prose. Flexible values do not excuse unvalidated links: structured record references use relationships/foreign keys rather than arbitrary JSON IDs.

`createCampaignModel` remains the presentation boundary. Start with a normalized static dataset plus an adapter. Later a database repository loads already authorized rows into the same model. Fetching becomes asynchronous; the UI must handle loading, errors, and records disappearing after permissions change. This document proposes no backend implementation or SQL migration yet.

## 8. Exact migration mapping from today's data

Before mutation, capture the original dataset, working-tree diff, record counts, summaries, relationships, and routes. Preserve all local corrections and do not overwrite unrelated work.

| Existing value | Proposed mapping / safeguards |
| --- | --- |
| `people[].id/name` | Person ID `person:<id>`; unchanged route key and display name. |
| `people[].type` | Individual `person.nature` fact, preserving original label. No automatic Thin-Blood subtype conversion. |
| `people[].clan` | `clan_member_of` relation to `clan:<id>`; absence remains unrecorded. No inherited clan from crew or sire. |
| `people[].affiliationStatus` | Individual status fact; Independent does not create an organization. |
| `people[].memberships` | Person → organization connection; preserve role/null. Spokes Crew entries can retain recorded membership. Night Forum's associate wording maps Nora to `associate_of`. Bliss wording maps Georgia to association, not inferred employment or formal membership. Log these semantic corrections. |
| `people[].affiliations` | `affiliated_with` to the corresponding organization; preserve role/null. Do not silently upgrade to formal membership. |
| `people[].places` | `associated_with_place`; preserve generic meaning unless separately confirmed. |
| `people[].summary` | Preserve verbatim as an overview entry. Do not automatically extract potentially secret relationships from prose. |
| `groups[].id` | Organization `organization:<id>` with original group route alias. Preserve kind; missing kind stays unspecified. |
| `factions[].id` | Organization `organization:<id>` with original faction route alias. Keep `duluth-camarilla` distinct from a global Camarilla record; do not merge by similar name. |
| `groups[].places` | Organization/place association (`related_to` by default), not inferred headquarters or ownership. |
| Organization `parent` | Explicit `subgroup_of` only after verifying the recorded meaning. No inheritance without an implication rule. Existing parents are null. |
| Existing clan records | `clan:<id>`; preserve names and routes. Do not add the screenshot's entire roster. |
| Personal `relationships` | `associated_with` rows retaining original IDs through a migration ID map; preserve null explanation. |
| `places[].id/name/kind` | Place ID `place:<id>`; unchanged route key; name and kind as appropriate name/fact data. Retain original summary in the migration audit. |
| `places[].parent` | Primary `contained_in` relation. Watchtower/Bliss → Twig and Nopeming → Eldes Corner remain intact. |
| `places[].children` | Compare against derived children, report discrepancies, then remove duplicate arrays once parent migration passes. |
| `watchtower.domain` | A claim row with null claimant and unspecified status. No inferred owner or coterie claimant. |
| `rack` | One record for Canal Park/The Rack; add contextual names. Replace the network-only overview with the confirmed identity; preserve original wording in the audit, not as an asserted current description. Geographic parent remains a flagged legacy value pending clarification. |
| `threads[].people/places` | `involves` relations; do not infer participation roles or scheme ownership. |
| `sessions[].people/places/threads` | `references` relations; avoid asserting physical attendance for every listed record. |
| Session date/title/summary | Preserve original date expression, route key, title, and recap. Preserve existing ID even if date provenance needs review. |
| `tonight` | Preserve the homepage view configuration and references through the ID map; it is not a separate authoritative lore record. |
| `legacyRoutes` | Preserve and compose existing redirects with new organization routes. Detect loops and collisions. |

Creating an `organization:anarchs` shell and the Night Forum implication rule is supported by the user's explicit clarification. Include only that confirmed affiliation structure, not imported leadership, rosters, or private notes. The group relationship and rule do not establish Nora's formal membership.

Screenshot-specific extra facts remain outside automatic migration. The author decides which individual entries may enter public data. A small, sanitized fixture can test the schema without using those dossiers.

### Route compatibility

Keep `#people/<key>`, `#places/<key>`, `#clans/<key>`, `#threads/<key>`, and `#chronicle/<key>` working. Introduce `#organizations/<key>` and eventually `#schemes/<key>`/`#events/<key>` only when those records/pages are implemented.

Redirect old `#groups/<key>` and `#factions/<key>` to the organization's canonical route. Preserve old collection listing URLs as filtered organization listings. In particular:

- `#groups/bliss` → organization page; `#places/bliss` → place page. They must never collide.
- Existing `#factions/spokes-crew`, `#factions/night-forum`, and `#factions/bliss` reach their organization pages, directly or through composed aliases.
- `#factions/independent` remains a status/search entry point, not an invented organization.
- `#places/rack` remains the Canal Park/The Rack page.

Store aliases centrally and resolve a canonical route in one step where possible. Renaming a display name never breaks a URL. Search uses authorized aliases and linked facts; it does not index entire hidden dossiers.

## 9. Implementation phases and acceptance criteria

### Phase 1 — Normalize the public static model

1. Preserve a recoverable source snapshot and produce an ID/route mapping and migration report.
2. Add normalized records, names, items, organizations, and typed relationships without changing visual direction.
3. Update the model adapter and migrate existing links. Keep legacy route aliases.
4. Implement confirmed contextual names and corrected geography. Keep unresolved values explicitly flagged; do not invent a new parent for The Rack.
5. Introduce explicit membership implication logic and test it with synthetic confirmed-member cases. Keep unconfirmed/associate cases separate.
6. Compare migrated output with the source, including summaries, all existing IDs/routes, homepage references, unknown fields, and geography corrections.

Gate: no lost facts, no duplicate identities, no unapproved private imports, and every existing public route resolves. Produce a reviewable report of semantic changes rather than silently rewriting descriptions.

### Phase 2 — Flexible detail pages and typed links

1. Render populated sections/items and appropriately labeled reverse relationships.
2. Add contextual-name search, organization categories, member rosters, offices, claims, and optional detail modules as their data becomes available.
3. Support attachment display and optional promoted room/floor/tenant records.
4. Preserve mobile reading order, accessible headings, touch targets, keyboard navigation, and desktop layout.

Gate: a minimal NPC requires no invented fields; a detailed fixture supports multiple schemes, conditional descriptions, histories, and media. Geographic areas remain visually distinct from individual sites. Specific reverse labels are correct.

### Phase 3 — Supabase, authenticated editing, and granular reveals

1. Create database tables, foreign keys, cycle/type validation, protected storage, campaign roles, and row-level security.
2. Exercise access policies before importing private material.
3. Build editing/import tools with explicit audiences, provenance, unknown-state handling, and migration previews.
4. Import source notes only after the author confirms identity matches and disclosure choices.
5. Add player views and reveals, including permission-aware search and inherited affiliation results.

Gate: a player cannot retrieve hidden rows/assets through APIs, direct URLs, search, derived views, or browser state. Test Storyteller, player, selected-player, and unauthenticated access, plus revoked permissions. Only then introduce private campaign notes.

### Required validation across phases

- IDs are unique; references are valid and type-compatible; no cross-campaign links.
- Geographic containment, item nesting, and organization/implication graphs have no cycles.
- One active primary parent per place; additional overlap/proximity links do not rewrite containment.
- Symmetric relationship duplicates are detected; multiple genuinely different connections remain possible.
- Night Forum membership implies Anarch affiliation in one direction only; association does not; rosters deduplicate and retain provenance.
- A hidden membership path never leaks through an inherited roster or explanation.
- Clan identity is not inherited through group affiliation or a personal association.
- A claim doesn't create ownership, exclusive control, or descendant claims.
- Names/aliases reach one canonical record; duplicate personal names remain distinct people.
- Former relationships, unknowns, qualifiers, source dates, and rumors retain their meaning.
- Minor and detailed records both render with no compulsory blank sections.
- Existing bookmarks, search, browser back/forward, and mobile/desktop layouts remain functional.

## 10. Review decisions before implementation

The recommended model can proceed without filling every unknown. The following decisions affect migration or authoring behavior:

1. Confirm the primary parent of Canal Park/The Rack; keep the existing value flagged until then.
2. Confirm whether West Duluth is geographic containment for Eldes Corner or notebook organization only.
3. Identify which new source entries may be public. None of the screenshots is authorization to publish an entire note.
4. Confirm specific ambiguous person-place and membership connections only when desired. Generic association is a legitimate final value.
5. When designing authenticated access, choose whether ordinary player knowledge is shared by the coterie or sometimes individual; the model supports both.

No answer is needed to finish this design document. These decisions can be resolved during staged implementation; private publication always requires an explicit disclosure decision and enforceable access controls.
