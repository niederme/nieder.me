# Handoff

## Branch
- `codex/home-case-study-promo`

## Last Pushed
- `8fd47ed` `Add safe GitHub issue creation workflow (#12)` (current `main` base before this branch work)

## Current Focus
- Add and polish a reusable homepage Case Study Promo block (Resy first instance).
- Restore a dedicated Resy Discovery long-form article route at `/work/resy-discovery/`.
- Apply typography and spacing refinements requested during review.
- Remove defunct `mailmoi/` pages.

## What Changed
- Homepage (`index.html`, `assets/css/styles.css`, `assets/js/main.js`):
  - Added reusable case-study promo section after `Work Experience`.
  - First promo instance uses Resy assets and right-side image anchoring.
  - CTA updated to `View Case Study` and now links to `work/resy-discovery/`.
  - Removed top hero horizontal rule.
  - Removed promo divider rule above the block.
  - Set desktop spacing between `Work Experience` and promo block to `200px`.
  - Updated heading line-height to `1` for Work Experience and promo title type.
- New homepage promo assets:
  - `assets/images/home/case-study-promos/bg-Resy-desktop.png`
  - `assets/images/home/case-study-promos/bg-Resy-mobile.png`
  - `assets/images/home/case-study-promos/logo-Resy.svg`
- Added standalone Resy article route:
  - `work/resy-discovery/index.html`
  - `assets/css/work-case-study.css`
  - Uses shared desktop left rail pattern (spinning logo, left vertical rule, home + cols side controls), no `Back to homepage` link.
- Added article hero source images restored from legacy history:
  - `assets/images/work/resy-discovery/Resy-Discovery-desktop.jpg`
  - `assets/images/work/resy-discovery/Resy-Discovery-mobile.jpg`
- Removed defunct legacy pages:
  - `mailmoi/index.html`
  - `mailmoi/privacy/index.html`
  - `mailmoi/terms/index.html`
  - `mailmoi/accessibility/index.html`

## Verification
- Ran `node --check assets/js/main.js` successfully.
- Captured browser screenshots with Playwright to validate:
  - homepage promo background visibility and spacing
  - line-height updates
  - article route rendering and side rail behavior

## Open Items
- Commit and push this branch.
- Optional follow-up: tune article content/imagery density and add additional work routes (for example, `resy-web-discovery`) if needed.

## Resume Checklist
1. `git fetch --all`
2. `git checkout codex/home-case-study-promo`
3. `git status --short`
4. Review diffs for:
   - `index.html`
   - `assets/css/styles.css`
   - `assets/js/main.js`
   - `work/resy-discovery/index.html`
   - `assets/css/work-case-study.css`
   - `README.md`
   - `HANDOFF.md`
5. Commit and push branch updates
