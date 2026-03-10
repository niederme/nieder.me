# nieder.me

## Local dev

Run this from the repo root:

```bash
make
```

That starts a static server on all interfaces (`0.0.0.0`), prints:
- `http://<this-mac>.local:7777` for this Mac (derived from macOS `LocalHostName` with fallbacks to `HostName`, shell hostname, and sanitized `ComputerName` when needed; for example `http://niederstudio.local:7777`)
- a LAN URL like `http://192.168.x.x:7777` for other devices on the same network (for example, Niederstudio)

It also opens the `.local` URL on this Mac.

If port `7777` is already in use, `make dev` automatically picks the next available port and prints the exact URLs.

Use a different port if needed:

```bash
make dev PORT=8080
```

`make dev-lan` is available as an alias of `make dev`.

## Live reload

For auto-refresh in the browser on file save, run:

```bash
make dev-live
```

This uses BrowserSync to serve the repo and reload when HTML/CSS/JS files change. It opens the same resolved `<this-mac>.local` URL as `make dev` instead of BrowserSync's default `localhost`.

Requirements:
- Node.js with `npx` available (recommended: Node 20 via `nvm use 20`)
- Runtime support for `node:path` (older Node 14 builds can fail)

## Local-only mode

Run:

```bash
make dev-local
```

That binds to localhost only.

`make dev-local` also auto-selects the next available port when the requested one is already in use.

## SendMoi pages

- `/sendmoi/` is the standalone SendMoi marketing page (system light/dark, hero product video, feature grid, and temporary `Coming soon` App Store treatment).
- `/sendmoi/privacy/` is the SendMoi privacy policy page.
- `/sendmoi/terms/` is the SendMoi terms page.
- `/sendmoi/accessibility/` is the SendMoi accessibility statement page.
- The homepage `index.html` also includes a SendMoi case-study section after the `Resy.com Consumer Website` block.

## SendMoi launch-state notes

- App Store badges on `/sendmoi/` are intentionally disabled and overlaid with hand-drawn `Coming soon` SVG assets.
- When launch links are ready, remove the `store-actions--coming-soon` treatment in `sendmoi/index.html` and replace `href="#"` on badge links with the real App Store URLs.
- SendMoi feature art lives in `assets/images/sendmoi/features/` with paired `*-Light.png` / `*-Dark.png` variants.
- The hero video on `/sendmoi/` respects `prefers-reduced-motion`, supports click/keyboard play-pause toggling, and dims while paused.

## Current mobile behavior

- The homepage includes a mobile-specific case-study nav that appears after the topper and tracks the active section.
- The mobile topper and case-study stack now use responsive width rules between narrower and wider phone viewports instead of a fixed 375px-only layout.
- The mobile horizontal scrollers no longer force `pan-x` only, which reduces vertical scroll lock/jumping during touch interactions.
- The mobile top inset and logo-to-heading spacing were tightened to better match the Figma mobile frame.
- CSS and JS assets use cache-busting query params in `index.html`; if Safari looks stale after changes, do a hard refresh.
