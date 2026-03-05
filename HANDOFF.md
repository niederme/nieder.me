# Handoff

## Branch
- `main`

## Last Pushed
- `fa259d6` `Polish SendMoi marketing page and launch-state badges`
- `a5f7106` `Tighten mobile topper responsiveness`
- `4f0247e` `Polish mobile Figma layout and nav`
- `30e9b83` `Refresh OG image and bump asset versions`
- `89f4711` `Add configurable site URL metadata switch`

## Current Focus
- SendMoi standalone marketing page polish under `/sendmoi/`
- Mobile rhythm and annotation placement tuning for the hero badge area
- Temporary launch-state App Store treatment (`Coming soon`) until live links are available
- Local development workflow improvements (live reload + dynamic `.local` host detection)

## What Changed
- Built and iterated a standalone `/sendmoi/` marketing page with:
  - responsive two-column hero (copy + device video)
  - system-driven light/dark mode with manual toggle persistence
  - concise feature grid using paired light/dark feature images from `assets/images/sendmoi/features/`
  - centered utility footer with legal links and support email
- Added and refined temporary App Store launch-state treatment:
  - disabled badge links (`aria-disabled`, no pointer interaction)
  - sketch-style `Coming soon` overlay (circle + text) sourced from user SVG assets
  - simplified badge source paths to flat files in `assets/images/sendmoi/app-store-badges/`
- Tuned mobile styling on `/sendmoi/`:
  - tighter hero spacing and typography rhythm
  - better badge readability and disabled-state feel
  - annotation placement adjusted to sit closer to badges on narrow viewports
- Updated hero video behavior on `/sendmoi/`:
  - honors `prefers-reduced-motion` (no autoplay when reduced motion is requested)
  - click/keyboard toggles play and pause
  - paused state visibly dims the video
- Added media/assets used by the marketing page:
  - app icon
  - App Store badge lockups (flat asset structure)
  - hero demo videos
  - coming-soon SVG overlays
- Added/updated SendMoi utility pages and homepage references:
  - `sendmoi/privacy/index.html`
  - `sendmoi/terms/index.html`
  - homepage SendMoi case-study section in `index.html`
  - added legacy route redirects so `/mailmoi/`, `/mailmoi/privacy/`, `/mailmoi/terms/`, and `/mailmoi/accessibility/` forward to `/sendmoi/*`
- Added BrowserSync live-reload local dev target:
  - `make dev-live` for auto-refresh on HTML/CSS/JS edits
  - explicit Node runtime guard/help text for older Node 14 setups (`node:path` support)
- Updated local URL host detection in Make targets to derive `<this-mac>.local` from macOS `LocalHostName` automatically across machines.

## Open Items
- Replace temporary App Store `href="#"` targets with real iOS/macOS App Store URLs at launch time.
- Remove the temporary `store-actions--coming-soon` overlays once the app is live.
- Run final visual QA on `/sendmoi/` in iPhone Safari (annotation placement and badge readability) after cache-clear/hard refresh.
- Optionally prune unused temporary SVG files (`coming-soon-note.svg` and `*-stroke.svg`) if they are no longer needed.

## Local Run
- Network + localhost:
  - `make`
- Network + localhost with live reload:
  - `make dev-live`
- Localhost-only:
  - `make dev-local`

## Resume Checklist
1. `git fetch --all`
2. `git checkout main`
3. `git pull --ff-only`
4. `make`
5. Validate `/sendmoi/` in desktop and iPhone Safari, then wire live App Store links when available
