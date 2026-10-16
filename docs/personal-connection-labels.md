# Personal connection labels

## Status and deployment

Implementation `0f96693` was pushed on `connection-labels-and-editor-loading` and merged in PR #32 (`4574c4e`), verified against remote `main`. Installation of migration 012 and deployment of the latest browser files have not yet been confirmed. Do not claim either is complete without evidence.

To enable label saves, apply the entire [migration 012](../supabase/migrations/20261016001200_personal_connection_labels.sql) in Supabase SQL Editor as postgres, after existing migrations, then deploy the website changes. If already installed, do not rerun it without checking. No campaign reimport is needed, and it creates no labels or facts automatically.

The newer [scoped editor](scoped-record-editing.md) loads only the selected person for ordinary label editing, and waits for complete dependencies before reviewing shared changes. This loading change needs no additional SQL.

The accompanying editor timeout fix is independent: it uses paged REST reads and requires no new SQL. See [campaign loading](campaign-loading.md). A failing editor before this deployment was reproduced as SQL statement timeout `57014`; installing migration 012 alone cannot resolve it.

## Editing a label

1. Open a person and select **Edit record & reveals**.
2. Find **Personal connection labels** and the other person's name.
3. Enter a description and choose **Save label**. Labels can be up to 500 characters.
4. Clear the input and save to restore the plain **Associate** fallback.

Only existing person-to-person `associated_with` connections appear here. This control does not create people or connections, change a sire/employer relationship type, or edit organization membership roles. Organization role editing remains separate roadmap work.

The label describes the connection from the person being edited. A label on one person's profile does not silently become a reciprocal description on the other person's profile. Existing structural relationships still supply labels such as **Childe of**.

## Visibility and saving

New labels are Storyteller-only, even if both names and the connection are already shared. To share one, find **Connection label for [person]** under the saved fields, select its reveal checkbox, and use the normal reveal review. The planner includes the section, connection and necessary linked names.

Editing an already shared label uses **Review and save label** and the same reveal review before saving. Canceling that review saves nothing. Private-label saves do not reveal other fields. Players cannot use the label-saving RPC.

A stale revision rejects the save and retains the draft in the form. Copy any draft needed before reloading. After a successful save, failure to reload is reported as saved-but-reload-failed; reload before trying another edit.

## Storage and code

- Reuse `content_items.field_key = relationship.details`, with a text JSON value, `subject_relationship_id`, and the owning person's `record_id`.
- The dedicated RPC is `save_personal_connection_label(campaign, record, relationship, revision, label)`. It is **SECURITY INVOKER**, explicitly requires Storyteller access, and retains RLS, audit triggers and optimistic revisions.
- It validates an active person, an existing personal association, both endpoints, one active label per owner/connection, and a maximum 500-character input. It rejects unrelated people and duplicate label rows rather than guessing.
- It creates a private `connection-labels` section if needed. Clearing retains the item identity and sets the label to unrecorded, rather than deleting history.
- Private updates use the RPC. Already shared updates use the existing atomic `edit_campaign_rows` and reveal review. No authorization policy was relaxed.
- `record-editor.js` supplies the UI and friendly saved-field names. `campaign-model.js` scopes label lookup to the owning person. `app.js` renders labels in Personal connections and suppresses duplicate standalone label panels.
- Imported descriptions are not parsed or converted into labels automatically. For future imports, use only explicit source facts when providing a label, keep it person-scoped and private, and preserve source provenance. Generic associations do not imply that all narrative context is absent.

## Verification

Before push, 36 related unit checks, the full disposable PostgreSQL migration/permission suite, and existing editor/loading browser checks passed. New coverage includes directional label lookup, create/edit/clear, stale revisions, unrelated-person rejection, audit attribution, private RLS, player/anonymous denial, shared-label review, pagination completeness, failed-page retry, draft retention and mobile layout.

Relevant commands:

```sh
node --test tests/model.cjs tests/npc.cjs tests/notes.cjs tests/campaign-loader.cjs tests/supabase-adapter.cjs
bash scripts/test-supabase-draft.sh
node tests/connection-labels-browser.cjs
CAMPAIGN_TEST_URL=http://127.0.0.1:8028 node tests/record-editor-browser.cjs
CAMPAIGN_TEST_URL=http://127.0.0.1:8028 node tests/campaign-loading-browser.cjs
```

Use a local static server on the specified port. Tests use synthetic/public fixtures; live exports, NPC imports and private screenshots stay outside the published repository.
