# Handoff

## Branch
- `main`

## Current Focus
- Home/work routing polish and article rail consistency updates.

## What Changed
- Home `Work Experience` section copy was tightened for the NYT role description.
- Home overflow link now reads `Full Work Experience & Resume →` and routes to `/work`.
- Added `/work` placeholder page (`work/index.html`) with the same rail/nav treatment and footer as article pages.
- Updated article rail behavior:
  - `Back` icon remains slot one on article pages.
  - `Work Experience` slot now routes to `/work` (not the home anchor).
  - Active case-study icon remains static per page; no scroll-driven switching on article pages.
- Added footer layout and styles on work pages for visual consistency (`assets/css/work-case-study.css` + article/footer markup).
- Refined shared footer structure/style on home (`assets/css/styles.css` + `index.html` footer markup).

## Verification
- Manual HTML/CSS review of updated pages and link targets.

## Open Items
- None for this polish pass.

## Resume Checklist
1. `git pull`
2. `git status --short`
3. Run `make` and verify:
   - `/`
   - `/work`
   - `/work/resy-discovery/`
   - `/work/sendmoi/`
