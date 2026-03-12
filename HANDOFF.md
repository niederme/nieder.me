# Handoff

## Branch
- `codex/mobile-carousel-alignment`

## Current Focus
- Finish and package homepage mobile carousel alignment and touch-hover polish for merge.

## What Changed
- Updated the homepage mobile topper carousel to use a responsive snap inset tied to `--mobile-content-width`.
- Narrowed follow-on topper cards slightly so the middle card still hints at the third card.
- Updated the homepage mobile `Work Experience` carousel to use the same responsive snap-inset model.
- Scoped link hover-only underline styles to hover-capable devices to avoid sticky touch hover artifacts on iPhone.
- Updated homepage work-experience copy:
  - `Design Lead, Digital News Design` → `Design Lead`
  - `Nov. 2007 - Mar. 2012` → `Nov. 2007 - Jan. 2014`
- Bumped homepage stylesheet cache token in `index.html`:
  - `assets/css/styles.css?v=20260311-001`

## Verification
- Verified locally with Playwright mobile screenshots against a local server for:
  - topper cards 1, 2, and 3 on `iPhone 14`
  - topper card 2 on `iPhone SE`
  - topper card 3 on `iPhone 14 Plus`
  - `Work Experience` card 2 on `iPhone SE`, `iPhone 14`, and `iPhone 14 Plus`
- Confirmed the final topper third card reaches the same left snap edge as cards 1 and 2.

## Open Items
- Commit and push `codex/mobile-carousel-alignment`.
- Open PR and merge after review.
- After merge, clean up the branch and sync local `main`.

## Resume Checklist
1. `git branch --show-current`
2. `git status --short`
3. Review `README.md` and `HANDOFF.md`
4. Commit and push `codex/mobile-carousel-alignment`
5. Open PR to `main`
