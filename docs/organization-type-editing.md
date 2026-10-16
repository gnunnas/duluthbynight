# Organization type editing

In an organization's **Edit record & reveals** screen, use the **Organization type** text box near the top. Enter any label, for example **Coterie**, **Band**, **Sect**, or **Business**. The current stored label, including a generic “Organization,” is prefilled. Save changes without editing JSON or expanding the raw field.

Run the entire [migration 015](../supabase/migrations/20261016001500_organization_type_editor.sql) as postgres in Supabase SQL Editor before deploying website release `20261016-organization-type-editor`. Migration installation and website deployment are not yet confirmed. Existing records/types are not rewritten or revealed by installing it, and no campaign reimport is needed.

This edits the existing `organization.kind` content item's JSON string value, preserving identity and audience. A missing field is created privately under the organization's existing active Facts section, or a new private Facts section if needed. New types remain Storyteller-only even for a shared organization; use the saved **Organization type** field's reveal checkbox and the existing review to share it. Already shared types require review and confirmation before edits are saved. Canceling that review writes nothing. Clearing a type retains its row/history, sets value null and marks it unrecorded; the existing detail page displays Unknown until another type is recorded.

Types are descriptive labels. They do not change the record's organization identity, its group/political browse category, membership hierarchy/inheritance, Coterie workspace setup or character/account permissions. Entering Coterie does not automatically add members or create workspace resources. No suggested label is applied automatically.

The narrow `save_organization_type` RPC is SECURITY INVOKER with an empty search path and an explicit Storyteller check. It permits active organizations only, serializes creation against the organization row, rejects stale revisions with PT409, and refuses duplicate active type fields or protected/archived/nested structures. Private edits use that RPC; already shared edits use the existing atomic edit/reveal flow. RLS, table grants, audit triggers and account/cache boundaries are unchanged. Drafts survive conflicts, missing-migration errors and canceled reviews; copy them before reloading.

The normal editor still loads only the selected record; complete dependency data loads for reveal review. The type editor is not shown for people, places or other record types, and players have no authoring control.

Verification:

```sh
bash scripts/test-supabase-draft.sh
CAMPAIGN_TEST_URL=http://127.0.0.1:8028 node tests/organization-types-browser.cjs
CAMPAIGN_TEST_URL=http://127.0.0.1:8028 node tests/record-editor-browser.cjs
CAMPAIGN_TEST_URL=http://127.0.0.1:8028 node tests/summaries-browser.cjs
```

SQL tests exercise real migrations, private defaults, existing/absent/cleared fields, free text, audit/attribution, stale creation/update revisions, shared-edit review guard, protected structures, active organization scope and player/nonmember/anonymous denial in disposable PostgreSQL. Browser tests mock APIs and verify creation, replacing generic labels, detail display, conflict/migration error drafts, shared preview/cancel/conflict/save, scoped reads, role/type restrictions and responsive layout. Neither test suite changes live campaign data.

Local validation passed for the full SQL suite, dedicated type-editor browser suite and existing editor/reveal and summary browser suites. Syntax and whitespace checks passed. The migration has only been applied in disposable local tests; do not infer production installation or deployment from these results.
