# Tonight status strip

The homepage's small status strip is backed by `public.campaign_status`. It preserves the old **Current night**, **Coterie status**, **Current lead**, and **Next stop** values, and adds an empty **Weather** row. No weather, full calendar date, or new campaign fact is invented. Blank values do not display on the homepage.

## Install once on your existing project

In Supabase SQL Editor, run the complete contents of:

`supabase/migrations/20261007000200_campaign_status.sql`

Run only this new migration; do not rerun the initial schema or campaign import. This creates the table, real RLS permissions, revision/audit triggers, and starter rows for the existing `duluth-by-night` campaign. The migration is a single transaction. When installing a fresh project before creating its campaign, starter rows are not created; add them in Table Editor after campaign initialization.

The website tolerates this table being absent while you deploy the change. Without the migration it simply omits the status strip; sign-in and records continue working.

## Update before play

Open **Table Editor → campaign_status**, filter `campaign_id` to `duluth-by-night`, then edit the `value` cells. `Current night` is the fictional in-game date/time, so it is free text rather than your computer's current date. Weather is authored campaign weather, not an automatic live forecast.

You can also change `label` or `sort_order`. Add more rows for other short details with the same campaign ID and a unique ID such as `mood`. Lower sort orders display first. Leave a value empty to hide its slot. The existing responsive strip wraps for additional rows.

These session-prep rows deliberately use `audience = players`: active campaign players and Storytellers can read them. Use `storyteller` for a hidden row. Storytellers alone can insert/update through authenticated API access; players and anonymous visitors cannot change them. Changes are recorded in `change_events`. Table Editor uses administrative access, as with your other setup tasks.

After saving, reload the website and sign in again to fetch the new values. The main page does not poll for live changes. This change adds no Storyteller editing form to the website; Table Editor is the initial editing interface.

Permanent flavor text and artwork stay in presentation code. The recap and Faces to remember are separate features and are not changed here.
