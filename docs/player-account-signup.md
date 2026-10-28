# Player account signup and approval

Players can create their own Supabase Auth accounts from `campaign.html`. Registration never grants campaign access by itself. After confirming their email and signing in, a player requests access; a Storyteller approves or declines that request from **Storyteller tools**.

## Install

1. In the Supabase SQL Editor, run `supabase/migrations/20261028001600_player_access_requests.sql` once.
2. In Supabase, open **Authentication → Sign In / Providers → Email**. Enable new-user email signup and keep email confirmation enabled.
3. Under **Authentication → URL Configuration**, use `https://duluthbynight.monster` as the Site URL and retain `https://duluthbynight.monster/**` as an allowed redirect. Keep the configured Cloudflare preview wildcard while preview testing is needed.
4. Deploy the matching website release `20261028-player-signup`.

Supabase's built-in email service is suitable for a small initial group but is rate limited and is not intended as a permanent production mail service. Add custom SMTP later if confirmation messages are delayed or rejected. Never put SMTP credentials in this repository or browser JavaScript.

## Player flow

1. Open `/campaign.html` and choose **Create account**.
2. Enter an email and a password of at least eight characters.
3. Open the Supabase confirmation email and follow its link.
4. Sign in and choose **Request player access**.
5. Wait for a Storyteller to approve the request, then sign out and sign in again.

## Storyteller flow

Open **Storyteller tools**. Pending accounts appear under **Player access requests**, sorted by email. **Approve player** creates or reactivates only a Player membership. It preserves an existing Storyteller role rather than demoting it. **Decline** closes the request; the account may request again later.

Account creation and campaign membership are separate on purpose. An unapproved Auth account cannot read the campaign row or any player-visible campaign content. The browser has no service-role key. Narrow authenticated functions run as the caller; row-level policies independently restrict requests to the current account and approvals to Storytellers.

Existing Auth users and memberships are not changed by the migration. Players are not automatically linked to a character; character ownership/editing remains a separate future feature.

## Verification

Use a new email address rather than an existing Storyteller account:

1. Register, confirm the email, and sign in. Confirm that campaign records remain unavailable.
2. Request access and confirm the waiting message appears.
3. Sign in as Storyteller, approve the request, and verify it disappears from the pending list.
4. Sign in again as the new player and confirm only player-revealed material is visible.
5. Create a second request and decline it. Confirm it can request again but still cannot see the campaign unless later approved.

