# Handoff

## Branch
- `codex/home-case-study-promo`

## Last Pushed
- `8fd47ed` `Add safe GitHub issue creation workflow (#12)` (current `main` base before this branch work)

## Current Focus
- Finalize and ship reusable homepage case-study promo modules (Resy + SendMoi).
- Restore standalone `/work/...` case-study pages and align rail nav behaviors/states.
- Prepare PR against issue `#14`.

## What Changed
- Homepage promos (`index.html`, `assets/css/styles.css`, `assets/js/main.js`):
  - Added reusable case-study promo section after `Work Experience`.
  - Added Resy and SendMoi promo instances with configurable logo/bg/focus data attributes.
  - Set `200px` spacing above promo section, `50px` spacing between promo cards, and `50px` promo corner radius.
  - Updated SendMoi promo copy:
    - Eyebrow: `SendMoi for iOS & MacOS`
    - Headline: `Designed & built with a little help from AI coding tools.`
  - Added desktop side-nav anchors for `Resy` and `SendMoi` and linked them to `#case-study-resy` and `#case-study-sendmoi`.
  - Updated rail active-state calculation to use document-absolute section tops so one nav item stays active while scrolling.
  - Nav icon state behavior:
    - Off state uses provided off assets.
    - On state uses white `*-on.svg` assets.
    - Hover uses dedicated red `*-hover.svg` assets.
    - SendMoi nav icon remains width exception at `32px`.
- New/updated promo assets:
  - `assets/images/home/case-study-promos/bg-SendMoi-desktop.png`
  - `assets/images/home/case-study-promos/logo-SendMoi.svg`
- Standalone work pages:
  - Existing Resy page kept and updated to shared stylesheet version `20260310-002`.
  - Added `work/sendmoi/index.html` from legacy content, adapted to standalone article template.
  - Extended `assets/css/work-case-study.css` with per-page theme variables (hero image/overlay/focus/logo sizing) used by `work-theme-sendmoi`.
- Desktop rail icon assets:
  - Updated from Desktop: `home-off/on`, `icon-work-experience-off/on`.
  - Added: `icon-work-resy-off/on`, `icon-work-sendmoi-off/on`.
  - Added hover variants: `home-hover`, `icon-work-experience-hover`, `icon-work-resy-hover`, `icon-work-sendmoi-hover`.
- Existing cleanup retained:
  - Defunct `mailmoi/` pages removed.

## Verification
- `node --check assets/js/main.js` passes.
- Manual visual QA completed iteratively with user-provided screenshots and Desktop icon/background asset replacements.

## Open Items
- Commit all current changes.
- Push branch and open PR that closes issue `#14`.

## Resume Checklist
1. `git fetch --all`
2. `git checkout codex/home-case-study-promo`
3. `git status --short`
4. Review diffs in:
   - `index.html`
   - `assets/css/styles.css`
   - `assets/js/main.js`
   - `assets/css/work-case-study.css`
   - `work/resy-discovery/index.html`
   - `work/sendmoi/index.html`
   - `assets/icons/side-nav/*(home|work-*)*`
   - `assets/images/home/case-study-promos/*SendMoi*`
   - `README.md`
   - `HANDOFF.md`
5. Commit + push
6. Open/update PR for issue `#14`
