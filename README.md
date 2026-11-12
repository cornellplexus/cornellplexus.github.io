# Block Board

A live timeline of the day's regional nerve blocks for the block team: pre-block checklist, history, labs, block and syringe planning with max local anesthetic dosing, end-of-case timing, and a team reference guide.

- **Page:** a single `index.html`, hosted free on GitHub Pages.
- **Shared data:** Supabase. Every save shows up on every teammate's phone and computer within about a second.
- **Sign-in:** first name + last initial and one shared team password. Each phone or computer asks once and remembers it. Only names on the team list get in, and the board shows who last edited each patient. The password and the list both live in Supabase, never in this code.

## Privacy first

Supabase's free plan is **not** covered by a HIPAA business associate agreement. Keep entries de-identified, as the board is designed for: age, sex, weight, surgery, bay or room. **No names, MRNs or dates of birth.** Check with your hospital's privacy or IT office before using it for real patients.

## One-time setup (about 15 minutes)

### 1. Create the Supabase project

1. Sign up at [supabase.com](https://supabase.com) and create a new project (the free plan is fine). Pick a region near you and save the database password somewhere safe.
2. Open **SQL Editor → New query**, paste everything in [`supabase/setup.sql`](supabase/setup.sql), and click **Run**.
3. **Authentication → Sign In / Providers:**
   - Make sure **Email** is enabled.
   - Turn **off** "Allow new users to sign up". The team shares one account (step 4), so no one else needs to sign up.
4. **Project Settings → API** (or the **Connect** button): copy the **Project URL** and the **anon / publishable** key into [`config.js`](config.js). Never use the `service_role` / secret key.

### 2. Put the site on GitHub Pages

1. Push this folder to your GitHub repository.
2. On GitHub: **Settings → Pages → Build and deployment → Source: Deploy from a branch**, choose **main** and **/ (root)**, then **Save**.
3. After a minute the board is live at `https://<your-username>.github.io/<repo-name>/`.

### 3. Point Supabase at the site

In Supabase, go to **Authentication → URL Configuration**:

- **Site URL:** `https://<your-username>.github.io/<repo-name>/`
- **Redirect URLs:** add the same address.

### 4. Create the shared team account

In Supabase, go to **Authentication → Users → Add user → Create new user**:

- **Email:** the `teamEmail` in [`config.js`](config.js) (currently `team@cornellplexus.example.com`; it never receives mail)
- **Password:** the team password
- Tick **Auto Confirm User**, then **Create user**.

Share the board's address and the password with the team. To change the password later, open that user in **Authentication → Users** and reset it; everyone then re-enters the new one.

### 5. Add the team list

Open [`supabase/team-members.sql`](supabase/team-members.sql), put in one line per person (first name + last initial), and run it in the SQL Editor. Run it again any time to add people; the file also shows how to remove someone. You can also edit the list directly in **Table Editor → team_members**.

Tip: on a phone, open the board in Safari or Chrome and use **Add to Home Screen** so it opens like an app.

## Everyday use

- **+ Add block** for a scheduled block, **+ OR request** when a room calls for an intraop block.
- **Schedule / Detailed** switches between a compact list and full cards.
- **Guide** holds the team's reference notes, the peds dosing guideline and the lock codes.
- Marking a block **done** teaches the board that surgery's plan for next time (Guide → Learned plans).

## Making changes

Edit `index.html`, commit and push; GitHub Pages updates within a minute or two. Leave `config.js` empty to try changes on one device without touching the team's data.
