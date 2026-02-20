# Session Handoff — 2026-02-20

## Branch
- `codex/figma-site`

## What Changed In This Session
- Moved social links into the top hero (`#social-nav` treatment) and removed sidebar social icons.
- Updated social assets and wiring:
  - `assets/icons/social-instagram.svg`
  - `assets/icons/social-github.svg`
  - `assets/icons/social-linkedin.svg`
  - `assets/icons/social-x.svg`
  - `assets/icons/social-email.svg`
- Updated social links in `index.html` to live profiles (`x.com` for X).
- Added email obfuscation/wiring in `assets/js/main.js` via `[data-email-link]`.
- Set column grid default toggle state to OFF in `assets/js/main.js`.
- Updated topper spacing and responsive social-nav sizing/spacing in `assets/css/styles.css`.
- Updated case study visual asset:
  - `assets/images/case-studies/resy-discover-tab/resy-discover-tab-02.png`
- Bumped cache-busting query params in `index.html` for CSS/JS.

## Open Item
- Sticky caption behavior on case visuals needs a final pass.
  - Current behavior: caption is anchored to the visual frame, but in some scroll states it can appear “missing” until sticky engagement is reached.
  - Next step: decide whether caption should be viewport-pinned throughout the visual section, or remain tied to the sticky frame engagement point.

## Local Run
- Default (LAN + opens localhost):
  - `make`
- Localhost-only:
  - `make dev-local`

## Resume Checklist (next computer)
1. `git fetch --all`
2. `git checkout codex/figma-site`
3. `git pull --ff-only`
4. `make`
