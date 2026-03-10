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

## GitHub issue workflow

To avoid shell-quoting problems with Markdown backticks in issue bodies, create issues with a file or stdin:

```bash
make issue-create ISSUE_TITLE="Fix shell quoting" ISSUE_BODY_FILE=/tmp/issue.md
```

```bash
cat <<'EOF' | ./scripts/create-gh-issue.sh --title "Fix shell quoting"
Use `code` formatting safely in Markdown without zsh command substitution.
EOF
```

## SendMoi pages

- `/sendmoi/` is the standalone SendMoi marketing page (system light/dark, hero product video, feature grid, and temporary `Coming soon` App Store treatment).
- `/sendmoi/privacy/` is the SendMoi privacy policy page.
- `/sendmoi/terms/` is the SendMoi terms page.
- `/sendmoi/accessibility/` is the SendMoi accessibility statement page.

## Home case-study promo and article

- The homepage `index.html` now includes a reusable case-study promo block after `Work Experience`.
- Current instances are Resy and SendMoi, each with right-anchored background imagery and CTA text `View Case Study`.
- Promo block configuration uses data attributes for logo, desktop/mobile backgrounds, and image focus anchoring (`left`, `center`, `right`).
- The Resy CTA routes to `/work/resy-discovery/`, a standalone long-form article page.
- The SendMoi CTA routes to `/work/sendmoi/`, a standalone long-form article page.
- Child work pages now use the same desktop left rail treatment as home (spinning logo, left vertical rule, home nav icon, and `cols` toggle).
- Work article pages (`/work/resy-discovery/`, `/work/sendmoi/`) now keep the home-style rail nav items (`Home`, `Work Experience`, `Resy`, `SendMoi`) with static active state per page (no scroll-driven switching on child pages).
- On article pages, the first rail item now uses a back icon (`icon-back-off/on/hover.svg`) instead of the home icon.
- Promo cards use a `50px` corner radius and `50px` vertical spacing between cards.
- Desktop rail nav on home now includes direct anchors for `Work Experience`, `Resy`, and `SendMoi`, with explicit off/on/hover icon assets.

## Homepage footer

- The homepage now includes a grid-aligned footer after case-study promos using grouped link columns for long-term growth.
- Footer groups:
  - `Case Studies` (internal work links)
  - `Connect` (social + email)
  - `Policies` (`/sendmoi/privacy/`, `/sendmoi/terms/`, `/sendmoi/accessibility/`)
- Footer keeps the same visual system (rules, typography scale, spacing) and collapses responsively for tablet/mobile.
- `data-email-link` now supports multiple anchors so the obfuscated mailto behavior works in both topper social links and footer links.

## Legacy removal

- The old `mailmoi/` pages were removed from this branch as defunct content.

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
