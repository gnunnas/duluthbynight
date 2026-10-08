# Tonight status strip

The homepage's small status strip is backed by `public.campaign_status`. It preserves the old **Current night**, **Coterie status**, **Current lead**, and **Next stop** values, and adds an empty **Weather** row. No weather, full calendar date, or new campaign fact is invented. Blank values do not display on the homepage.

## Install once on your existing project

In Supabase SQL Editor, run the complete contents of:

`supabase/migrations/20261007000200_campaign_status.sql`

Run only this new migration; do not rerun the initial schema or campaign import. This creates the table, real RLS permissions, revision/audit triggers, and starter rows for the existing `duluth-by-night` campaign. The migration is a single transaction. When installing a fresh project before creating its campaign, starter rows are not created; add them in Table Editor after campaign initialization.

The website tolerates this table being absent while you deploy the change. Without the migration it simply omits the status strip; sign-in and records continue working.

## Update before play

Sign in to the campaign as Storyteller and open **Storyteller** in the navigation. Edit each row’s label, value, display order, or visibility, then click **Save row**. The new values appear immediately when you return to Tonight in that tab. Other signed-in tabs need to reload and sign in again to fetch them.

Each save checks the revision you loaded. If another edit won, your draft stays in the form and the save reports a conflict. **Reload saved values** replaces the editor’s current drafts with the latest database rows. Player accounts have no editor access; Supabase RLS enforces that restriction.

Alternatively, open **Table Editor → campaign_status**, filter `campaign_id` to `duluth-by-night`, then edit the `value` cells. `Current night` is the fictional in-game date/time, so it is free text rather than your computer's current date. Weather is authored campaign weather, not an automatic live forecast.

You can also change `label` or `sort_order`. Add more rows for other short details with the same campaign ID and a unique ID such as `mood`. Lower sort orders display first. Leave a value empty to hide its slot. The existing responsive strip wraps for additional rows.

These session-prep rows deliberately use `audience = players`: active campaign players and Storytellers can read them. Use `storyteller` for a hidden row. Storytellers alone can insert/update through authenticated API access; players and anonymous visitors cannot change them. Changes are recorded in `change_events`. Table Editor uses administrative access, as with your other setup tasks.

After saving, reload the website and sign in again to fetch the new values. The main page does not poll for live changes. The site editor updates existing active rows. Adding new rows or restoring archived rows still uses Table Editor. No additional SQL migration is needed for the editing screen.

**Hero tagline** is the text over the homepage image. Apply migration `20261007000700_tonight_hero_tagline.sql` once to add its editable row, then edit it alongside the Tonight details. It renders over the hero image, not as a status-strip box. Leave its value blank to hide it. Its player visibility and editing permissions use the existing status-table RLS and audit history. The migration preserves the existing line and does not overwrite an already configured tagline. Artwork stays in presentation code. The recap and Faces to remember are separate features and are not changed here.
