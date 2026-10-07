# Campaign import

The prepared SQL is [03_import_campaign.sql](../supabase/import/03_import_campaign.sql). It imports the current repository dataset into the initialized `duluth-by-night` campaign. It does not change the website or add sign-in.

## What is included

- 84 records, preserving IDs, names, routes, source notes, and links.
- 429 content entries, 129 relationships, and 14 discipline powers.
- Alan's selected Heightened Senses ability and portrait reference.
- Watchtower security people and group, geography, claims, and source references.
- 27 person-status entries initialized to **unknown** for permanent death.

Ordinary records and content start Storyteller-only. Player-note sections and entries have shared-player audience, but players cannot read them until their owning record is revealed. No content is automatically revealed or made public. Existing static-site files remain public as before; database permissions cannot hide files already published on GitHub.

The import records the campaign owner's Auth UUID as the importer and preserves import provenance in audit history. It creates no accounts and changes no memberships. Artwork stays at its existing legacy path; it does not upload images to Storage. The original snapshot exporter also retains homepage configuration, which will be handled by the future site adapter.

## When to apply

The schema, campaign initialization, and permission check must already have passed. Before importing any new private material, test real Storyteller and player browser sign-in with the authenticated adapter. The prepared import contains the current static site's data; it does not add private notebook material.

To apply this reviewed snapshot through Supabase:

1. Open **SQL Editor → New query** in the same project where you installed the schema.
2. Paste the complete contents of `supabase/import/03_import_campaign.sql`.
3. Run as the SQL Editor's default administrative role. Keep RLS enabled. No UUID replacement is needed: the importer uses the initialized campaign owner.
4. Expect `PASS: campaign data imported; ordinary content remains Storyteller-only.`

The transaction checks every exported table's row count and commits only after all constraints pass. If a statement fails, nothing from this import is committed. If campaign records already exist, it stops without overwriting them. Do not delete records or remove this guard to rerun it; later changes need a separate update migration that preserves edits and history.

This file is a data-import snapshot, **not** a schema migration. Do not put it into `supabase/migrations` or run the initial schema again. No website connection changes occur until the authenticated adapter is implemented.

## Regeneration and validation

After intentional changes to repository data, regenerate and review the diff:

```sh
node scripts/build-supabase-import.cjs --out supabase/import/03_import_campaign.sql
bash scripts/test-supabase-draft.sh
```

The local test applies the generated import to disposable PostgreSQL, checks that the checked-in SQL matches the current data, and verifies that a second import is refused. It never contacts the Supabase project.
