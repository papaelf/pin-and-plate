# Pin & Plate

A phone-first gym log for Planet Fitness. Tap a machine, log sets, see last time and your estimated max, and track progress.

- Installs to the iPhone home screen (Safari → Share → Add to Home Screen).
- Works offline. Workouts and photos are stored on the phone (IndexedDB); nothing is sent anywhere.
- Back up from the header button ("Backup") and keep the file in Files or iCloud Drive.

Files: `index.html` (the whole app), `sw.js` (offline cache), `manifest.webmanifest`, `icons/`.
When you change `index.html`, bump `CACHE` in `sw.js` so phones pick up the new version.
