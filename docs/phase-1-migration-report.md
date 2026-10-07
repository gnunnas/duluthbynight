# Phase 1 migration report

Phase 1 normalizes the public static campaign data and preserves the existing visual design and detail layouts. The migration does not import private OneNote dossiers, add authentication, or create a database. Flexible detail interfaces remain Phase 2; secure reveals remain Phase 3.

## Retained source and recoverability

- Original public source: [phase-1-source.js](../migration/phase-1-source.js).
- Source SHA-256: `57ac0fd3da15cab5998fc279c2f9d191af758ab1c1c43675a43c0e27ba0eaf35`.
- Full identity map, route map, count comparison, and semantic audit: [phase-1-report.json](../migration/phase-1-report.json).
- Repeatable conversion: [migrate-phase-1.cjs](../scripts/migrate-phase-1.cjs).

The source came from the clean working tree at commit `acfe91b`, which already includes the Watchtower/Bliss correction to Twig. No pre-existing local modifications were overwritten. All prior record identities are represented in the normalized map. Rollback must restore the application adapter and dataset together; the retained source alone is not compatible with the new adapter.

The migration command is comparison-only by default. `node scripts/migrate-phase-1.cjs --check` confirms exact reproducibility without changing files. An explicit `--write` rebuilds the normalized dataset and report; it is not an installation/startup command and must not overwrite later authoring edits unintentionally.

## Count comparison

| Source collection | Original count | Result |
| --- | ---: | --- |
| People | 11 | 11 person records |
| Places | 17 | 17 place records |
| Clans | 3 | 3 clan records |
| Groups | 3 | 3 organization records |
| Political affiliations | 1 | 1 organization record |
| Threads | 4 | 4 thread records |
| Sessions | 1 | 1 session record |
| Confirmed new shell | 0 | 1 Anarch organization record |
| **Total** | **40** | **41** |

Normalized supporting rows: **42 names, 77 sections, 85 content items, 57 relationships, one domain claim, and one membership implication**. Attachment storage is reserved but contains no imported assets. There are no invented schemes, events, leaders, officeholders, or new NPCs.

## What changed semantically

1. **Organizations unified.** Group and faction identities now share an organization collection, while old URLs and group/political browse categories remain. Bliss the organization and Bliss the location have distinct global IDs.
2. **Canal Park/The Rack unified by contextual names.** The old `rack` route now labels one place “Canal Park · The Rack.” Search finds it under either name. The network-only overview is replaced with the user's confirmed naming relationship; the original wording remains in the source and audit, not as a current assertion.
3. **Nora and Georgia retain association rather than presumed membership.** The original summaries describe association, not confirmed formal membership. Existing connections and unknown roles are preserved. No screenshot-specific employment or knowledge details are imported.
4. **Night Forum membership implication is explicit.** Confirmed members derive Anarch affiliation in one direction, with the full provenance path and without duplicate membership rows. Associates do not inherit membership. Nora is not silently upgraded.
5. **The Watchtower claim is normalized.** Its claimant remains null and its recognition/status unspecified. The claim does not assert ownership or descendant claims.
6. **Campaign links retain generic meanings.** Session arrays become references, not proof of attendance. Thread arrays become involvement without invented roles. Unspecified personal links remain association; direction-specific labels are supported by the model.
7. **Hierarchy has one source of truth.** Existing child arrays were compared with parent links before removal. Children are now derived from `contained_in` relationships.

Every other existing overview is preserved verbatim. Nature labels, clan IDs, Independent status, role unknowns, session display date, homepage text, and all existing NPC/location/thread/session references are retained. Stable record IDs are mapped to namespaced global identities while their route keys remain.

## Unresolved geography

- Canal Park/The Rack's primary parent needs confirmation. The inherited Downtown link remains `unverified`, with a concise notice on its detail page. No new parent is invented.
- Whether West Duluth is an intermediate parent for Eldes Corner remains unconfirmed. The established Duluth → Eldes Corner → Nopeming path remains.
- Twig remains a top-level community; no containing geography is inferred.

These are review issues, not broken references or blockers for static normalization. Watchtower and Bliss remain correctly under Twig.

## Route compatibility

All 40 pre-migration record routes resolve to their retained identities. Person/place/clan/thread/chronicle routes are unchanged. Group and faction record routes now resolve to canonical organization pages, including all earlier mixed-faction redirects. Old group/faction listings resolve to filtered organization listings. Independent remains a status/search entry point. Query parameters survive alias resolution.

Renaming Canal Park/The Rack does not create another place or change `#places/rack`. The model rejects alias loops, missing targets, identity collisions, duplicate symmetric links, incompatible endpoints, geographic/membership cycles, and multiple primary parents.

## Validation evidence

- **14 model/migration tests passed:** source-record/overview/reference preservation, homepage fidelity, geography, contextual aliases, unknown lineage/status/claimant, directional relationships, confirmed-only one-way inheritance, direct plus derived provenance, dated derivation, malformed graphs, and minimal/nested records.
- **51 canonical routes passed browser checks at 375px and 1280px widths**, plus all 40 pre-migration record URLs and existing alias entry points.
- Browser checks exercised record titles, rendered link targets, reciprocal relationships, separate geographic/site grouping, Twig and Eldes Corner breadcrumbs, alias search, organization hierarchy, Nora's association status, malformed routes, search persistence, mobile menu, and browser history.
- No page errors or horizontal overflow were observed.
- Deterministic migration comparison, JavaScript syntax checks, and whitespace checks passed.

Membership fixtures are explicitly test-only and are not shipped as campaign characters. The unchanged appearance was checked using the actual running browser; no public deployment or new-task restoration is claimed.

## What Phase 1 does not deliver

No editing forms, private data import, authentication, Supabase tables, access policies, private storage, or visibility toggles. No complete flexible-section renderer, office/appointment UI, security module, tenant directory, or attachment interface. The normalized data and adapter establish the foundation for those later phases while the current pages remain usable.
