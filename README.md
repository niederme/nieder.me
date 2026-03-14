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

For worktree-based feature threads, use:

```bash
make dev-thread
```

That keeps `7777` available for the main checkout and starts worktree previews at `7778`, auto-cascading to `7779`, `7780`, and upward when other worktree previews are already running.

## Development workflow

Before starting implementation work:

```bash
git branch --show-current
```

- If you are on `main`, create or switch to a feature branch before editing files.
- Do not use `main` as the active development branch.
- Preferred workflow: use a dedicated `git worktree` per feature branch/thread.
- For rendered site work in a worktree, start or reuse a preview there and surface the exact URL with the change.

Example:

```bash
git switch -c codex/my-feature
```

Or, for isolated parallel work:

```bash
git worktree add ../nieder-me-my-feature -b codex/my-feature
```

## Live reload

For auto-refresh in the browser on file save, run:

```bash
make dev-live
```

This uses BrowserSync to serve the repo and reload when HTML/CSS/JS files change. It opens the same resolved `<this-mac>.local` URL as `make dev` instead of BrowserSync's default `localhost`.

For live reload from a worktree thread, use:

```bash
make dev-live-thread
```

This follows the same `7778+` worktree port cascade as `make dev-thread`.

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

## Deploy (/2026)

Run:

```bash
./scripts/deploy-2026.sh
```

The deploy script stages a temporary copy of the managed site paths (`index.html`, `assets/`, and when present `work/` and `sendmoi/`), rewrites the site metadata and cache-busted asset URLs there, and syncs only those staged paths to the server. It does not mutate the tracked source files in your worktree or treat the remote root as fully managed.

## SendMoi pages

- `/sendmoi/` is the standalone SendMoi marketing page (system light/dark, hero product video, feature grid, and temporary `Coming soon` App Store treatment).
- `/sendmoi/privacy/` is the SendMoi privacy policy page.
- `/sendmoi/terms/` is the SendMoi terms page.
- `/sendmoi/accessibility/` is the SendMoi accessibility statement page.

## Home case-study promo and article

- The homepage `index.html` now includes a reusable case-study promo block after `Work Experience`.
- Current instances are Resy, SendMoi, and Somm AI, each with CTA text `View Case Study`.
- The homepage now includes an `About` section after the case-study promos with a portrait image and editorial-style bio copy block.
- The homepage now includes a `Colophon` section below `About`, with a large outlined heading and a two-column text layout covering type, build, preview, and deploy details.
- Promo block configuration uses data attributes for logo, desktop/mobile backgrounds, and image focus anchoring (`left`, `center`, `right`).
- Promo image references now use `*-promo.*` filenames to avoid production path mismatches observed on `nieder.me/2026` for earlier asset names.
- The Resy CTA routes to `/work/resy-discovery/`, a standalone long-form article page.
- The SendMoi CTA routes to `/work/sendmoi/`, a standalone long-form article page.
- The Somm AI CTA routes to `/work/somm-ai/`, an unshipped Resy concept case study about intent-led search and AI-guided dining discovery.
- The `Full Work Experience & Resume →` link on home now routes to `/work`.
- `/work` now acts as a full work overview page with the Figma resume layout: two-line title treatment (`Work Experience` in white, `& Resume` in red), seeking-status lead, resume download action, left-dated experience list, right-side contact/speaking/recognition/education rail, and a staggered two-column case-study layout for Resy, SendMoi, and Somm AI.
- Child work pages now use the same desktop left rail treatment as home (spinning logo, left vertical rule, home/back nav icon set, `light` toggle, and `cols` toggle).
- Work article pages (`/work/resy-discovery/`, `/work/sendmoi/`, `/work/somm-ai/`) now keep the home-style rail/nav treatment, with a second temporary Resy `R` rail item used for `/work/somm-ai/`.
- On article pages, the `Work Experience` rail item now links to `/work`.
- On article pages, the first rail item now uses a back icon (`icon-back-off/on/hover.svg`) instead of the home icon.
- Promo cards use a `50px` corner radius and `50px` vertical spacing between cards.
- Desktop rail nav on home now includes direct anchors for `Work Experience`, `Resy`, `SendMoi`, Somm AI, and `About`, with the Somm AI slot temporarily reusing the Resy `R` icon assets.
- Viewports between `960px` and `1500px` now use a compact desktop treatment: the homepage rail remains sticky and on-screen, `Work Experience` reflows into a denser two-column layout, and the `About` section keeps its portrait on the shared grid while widening the two-column copy.
- At the same compact desktop range, `/work` keeps the side rail within the viewport and tightens the resume layout before the existing sub-`1100px` stacked layout takes over.

## Homepage footer

- Footer is now present on:
  - homepage `/`
  - `/work`
  - `/work/resy-discovery/`
  - `/work/sendmoi/`
  - `/work/somm-ai/`
- Footer composition:
  - left block with `John Niedermeyer`, `Product Design & Direction`, icon-based social row, and copyright
  - `Site` column linking to the homepage, `Work Experience`, `About`, and `Colophon`
  - `Work` column linking to `/work` plus all case-study pages, with the current page highlighted
- Footer links are white by default with animated underline on hover/focus; the current page link uses the accent color.
- Footer social links are icon-based and reuse the same obfuscated email behavior (`data-email-link`) as the topper.
- Interactive focus states across home and work pages now use a shared subdued red `:focus-visible` outline with a separate soft red outer glow on control-style elements like the spinning logo, rail nav items, social icons, cards, CTAs, the `light` toggle, and the `cols` toggle.

## Legacy removal

- The old `mailmoi/` pages were removed from this branch as defunct content.

## SendMoi launch-state notes

- App Store badges on `/sendmoi/` are intentionally disabled and overlaid with hand-drawn `Coming soon` SVG assets.
- When launch links are ready, remove the `store-actions--coming-soon` treatment in `sendmoi/index.html` and replace `href="#"` on badge links with the real App Store URLs.
- SendMoi feature art lives in `assets/images/sendmoi/features/` with paired `*-Light.png` / `*-Dark.png` variants.
- The hero video on `/sendmoi/` respects `prefers-reduced-motion`, supports click/keyboard play-pause toggling, and dims while paused.

## Current mobile behavior

- The mobile-specific section dropdown nav has been removed from the homepage.
- The mobile topper and case-study stack now use responsive width rules between narrower and wider phone viewports instead of a fixed 375px-only layout.
- The mobile topper carousel now uses responsive snap insets so cards 1, 2, and 3 align to the same left text edge, while the middle card still leaves a visible hint of the next card.
- The homepage `Work Experience` section now collapses into a two-panel horizontal carousel on phones, with mobile page dots and a partial peek of the next column.
- The homepage mobile carousels now compute their snap inset from the shared content width instead of a fixed left offset, which keeps alignment consistent across different phone widths.
- Viewports between `521px` and `959px` wide now use a compact static homepage layout: the mobile logo/rule treatment is present, but the topper and `Work Experience` sections switch away from horizontal text carousels and into tighter fixed compositions.
- The side-scrolling mobile homepage treatment now carries through `520px` wide before handing off to that composed mid-width layout.
- The mobile horizontal scrollers no longer force `pan-x` only, which reduces vertical scroll lock/jumping during touch interactions.
- Homepage company-link hover underlines now only apply on hover-capable devices, avoiding sticky touch hover states on iPhone.
- The mobile top inset and logo-to-heading spacing were tightened to better match the Figma mobile frame.
- Home and work pages now default to dark mode even when the visitor’s OS prefers light, and the left rail includes a persistent `light` toggle for manually switching themes.
- Browser theme hints (`color-scheme` and `theme-color`) now switch between dark and light to match the active manual theme selection.
- CSS and JS assets use deploy-time cache-busting query params in the staged homepage HTML; if Safari looks stale locally, do a hard refresh.
