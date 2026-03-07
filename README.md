# nieder.me

## Local dev

Run this from the repo root:

```bash
make
```

That starts a static server on all interfaces (`0.0.0.0`), prints:
- `http://<this-mac>.local:8000` for this Mac (derived from macOS `LocalHostName`, for example `http://niederstudio.local:8000`)
- a LAN URL like `http://192.168.x.x:8000` for other devices on the same network (for example, Niederstudio)

It also opens the `.local` URL on this Mac.

If port `8000` is already in use, `make dev` automatically picks the next available port and prints the exact URLs.

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

This uses BrowserSync to serve the repo and reload when HTML/CSS/JS files change.

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

## SendMoi case study

- The homepage `index.html` includes a SendMoi case-study section after the `Resy.com Consumer Website` block.
- SendMoi imagery for that section lives under `assets/images/sendmoi/`.
- `assets/images/sendmoi/app-icon.png` is used for the desktop rail icon and mobile case-study nav entry.
- This repo no longer serves standalone `/sendmoi/*` marketing or policy pages.

## Current mobile behavior

- The homepage includes a mobile-specific case-study nav that appears after the topper and tracks the active section.
- The mobile topper and case-study stack now use responsive width rules between narrower and wider phone viewports instead of a fixed 375px-only layout.
- The mobile horizontal scrollers no longer force `pan-x` only, which reduces vertical scroll lock/jumping during touch interactions.
- The mobile top inset and logo-to-heading spacing were tightened to better match the Figma mobile frame.
- CSS and JS assets use cache-busting query params in `index.html`; if Safari looks stale after changes, do a hard refresh.
