# Handoff

## Branch
- `codex/ai-quota-case-study`

## Current Focus
- Expand the AIQuota case study across the site with homepage promo placement, side-nav placeholders, and a cleaner `/work` case-study layout.

## Tracking
- GitHub issue `#69` tracks publishing AIQuota across the site surfaces.

## What Changed
- Added a new standalone case-study page at `work/ai-quota/index.html`.
- Added local AIQuota visuals under `assets/images/case-studies/ai-quota/` and `assets/images/work/ai-quota/`.
- Added an AIQuota card to `/work`, switched it to the main-app screenshot, and updated shared footer work sitemaps across home and all case-study pages.
- Added a placeholder AIQuota promo to the homepage plus temporary AIQuota side-nav icons on home and work/article pages.
- Reworked the `/work` case-study section so the heading spans the full width and the four cards sit in a cleaner two-column grid.
- Added a `work-theme-aiquota` hero treatment in `assets/css/work-case-study.css`, then updated the AIQuota hero/card/promo imagery to use the newer composite desktop shot.
- Updated `README.md`, `assets/images/case-studies/README.md`, and this handoff to reflect the current repo state.

## Verification
- `git diff --check`
- Preview `/work/ai-quota/`, `/work/`, and the homepage locally and review nav, promo placement, and card layout.

## Open Items
- Replace the temporary AIQuota rail icon with a proper vector treatment if this case study graduates from placeholder status.
- Open the PR with `Closes #69`.

## Resume Checklist
1. `git branch --show-current`
2. `git status --short --branch`
3. Review `README.md` and `HANDOFF.md`
4. Run `git diff --check`
5. Preview `/`, `/work/`, and `/work/ai-quota/`
6. Push `codex/ai-quota-case-study`
7. Open the PR with `Closes #69`
