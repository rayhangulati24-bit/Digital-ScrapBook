# Our scrapbook: setup guide

You need three free accounts: GitHub, Supabase, Render. About 30-45 minutes.

## 1. Supabase (the shared database and photo storage)
1. supabase.com > New project. Pick a name and a database password (save it). Wait for it to finish.
2. Open `schema.sql` in a text editor. Replace the two example emails near the bottom with yours and your partner's.
3. In Supabase: SQL Editor > New query > paste the whole file > Run. It should say "Success".
4. Authentication > Users > Add user > Create new user. Make two users with those same emails and passwords, and tick "Auto Confirm User".
5. Authentication > Sign In / Providers (or Settings): turn OFF "Allow new users to sign up" so nobody else can create an account.
6. Project Settings > API: copy the Project URL and the `anon public` key.

## 2. Add your keys
Open `config.js` and paste in the URL and anon key. Keep the quotation marks.

## 3. GitHub
1. github.com > New repository. Name it e.g. `our-scrapbook`. Choose **Private**.
2. Click "uploading an existing file", drag in everything from this folder (index.html, config.js, robots.txt, render.yaml, schema.sql, README.md), and commit.

## 4. Render
1. render.com > New > **Static Site** > connect your GitHub and pick the repo.
2. Build command: leave empty. Publish directory: `.`
3. Create. In a minute you get a `something.onrender.com` link. Open it, sign in, and start scrapbooking.
4. Optional: Settings > Custom Domains to use your own domain.

## If something goes wrong
- "That email or password didn't work": check the user exists in Supabase and the email matches exactly.
- Items won't save: make sure `schema.sql` ran without errors and both emails are in it.
- Blank page: check `config.js` has the right URL and key.
- Send me the error text or a screenshot and I'll help.

## Privacy notes
- The site address is public, but without a login the page shows only a sign-in box. Your data and photos are protected by the database rules, not by hiding the link.
- Only the two emails in `allowed_emails` can read or write anything.
- Keep the GitHub repo private anyway, and never share the `service_role` key.
