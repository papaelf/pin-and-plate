# Pin & Plate

A phone-first gym log for Planet Fitness. Tap a machine, log sets, see last time and your estimated max, and track progress.

- Installs to the iPhone home screen (Safari → Share → Add to Home Screen).
- Works offline. Workouts and photos are stored on the phone (IndexedDB); nothing is sent anywhere.
- Back up from the header button ("Backup") and keep the file in Files or iCloud Drive.

Files: `index.html` (the whole app), `sw.js` (offline cache), `manifest.webmanifest`, `icons/`.
When you change `index.html`, bump `CACHE` in `sw.js` so phones pick up the new version.

## Cloud sync setup

Optional. Keeps a copy of every workout and machine photo online in your own free Supabase project, so a lost phone or a deleted home-screen icon loses nothing. The phone stays the main copy: the app works offline and uploads when it has signal.

1. Go to [supabase.com](https://supabase.com), sign up (free), and click **New project**. Any name, any region near you, and save the database password somewhere (the app doesn't need it).
2. When the project is ready, open **SQL Editor → New query**, paste everything from [`supabase-setup.sql`](supabase-setup.sql), and click **Run**. You should see "Success. No rows returned".
3. Open **Authentication → Sign In / Providers → Email** and turn **Confirm email** off, then save. (If you leave it on, you'll just need to tap a link in an email once.)
4. Open **Project Settings → API Keys** (or **Connect**). Copy the **Project URL** and the **publishable key** (`sb_publishable_…`; the older `anon` key works too). Never use the `secret` / `service_role` key.
5. In Pin & Plate tap **Backup** (top right) → **Cloud sync**: paste the URL and key, tap **Connect**, then **Create account** with your email and a password. Everything on the phone uploads.
6. Back in Supabase: **Authentication → Sign In / Providers** → turn off **Allow new users to sign up**, so nobody else can make an account on your project.

On a new phone: install the app, open **Backup → Cloud sync**, paste the same URL and key, and **Sign in**. Your history downloads.

Note: free Supabase projects pause after about a week with no activity. If sync says it can't reach the server after a break, open your project on supabase.com and click **Restore**. Your workouts on the phone are never affected.
