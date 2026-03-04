# nieder.me

## Local dev

Run this from the repo root:

```bash
make
```

That starts a static server on all interfaces (`0.0.0.0`), prints:
- `http://<this-mac>.local:8000` for this Mac (for example `http://niederbook-air-m4.local:8000`)
- a LAN URL like `http://192.168.x.x:8000` for other devices on the same network (for example, Niederstudio)

It also opens the `.local` URL on this Mac.

If port `8000` is already in use, `make dev` automatically picks the next available port and prints the exact URLs.

Use a different port if needed:

```bash
make dev PORT=8080
```

`make dev-lan` is available as an alias of `make dev`.

## Local-only mode

Run:

```bash
make dev-local
```

That binds to localhost only.

`make dev-local` also auto-selects the next available port when the requested one is already in use.

## MailMoi pages

- `/mailmoi/` is the standalone MailMoi marketing page (system light/dark, hero product video, feature grid, and temporary `Coming soon` App Store treatment).
- `/mailmoi/privacy/` is the MailMoi privacy policy page.
- `/mailmoi/terms/` is the MailMoi terms page.
- The homepage `index.html` also includes a MailMoi case-study section after the `Resy.com Consumer Website` block.

## MailMoi launch-state notes

- App Store badges on `/mailmoi/` are intentionally disabled and overlaid with hand-drawn `Coming soon` SVG assets.
- When launch links are ready, remove the `store-actions--coming-soon` treatment in `mailmoi/index.html` and replace `href="#"` on badge links with the real App Store URLs.
- MailMoi feature art lives in `assets/images/mailmoi/features/` with paired `*-Light.png` / `*-Dark.png` variants.

## Current mobile behavior

- The homepage includes a mobile-specific case-study nav that appears after the topper and tracks the active section.
- The mobile topper and case-study stack now use responsive width rules between narrower and wider phone viewports instead of a fixed 375px-only layout.
- The mobile horizontal scrollers no longer force `pan-x` only, which reduces vertical scroll lock/jumping during touch interactions.
- The mobile top inset and logo-to-heading spacing were tightened to better match the Figma mobile frame.
- CSS and JS assets use cache-busting query params in `index.html`; if Safari looks stale after changes, do a hard refresh.
