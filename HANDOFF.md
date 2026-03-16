# Handoff

## Branch
- `codex/home-work-experience-copy`

## Current Focus
- Land a homepage polish pass covering `Work Experience` copy, shared accent-link line-height, and refreshed desktop home-nav icons.

## Tracking
- GitHub issue `#66` tracks this work.

## What Changed
- Shortened three homepage `Work Experience` descriptions in `index.html` for SendMoi, the later Resy principal-design role, and BuzzFeed.
- Updated the shared accent-link line-height treatment from `1.08` to `1.2` in `assets/css/styles.css`.
- Kept `assets/css/styleguide.css` aligned with that typography change.
- Replaced the desktop side-nav `home-off.svg` and `home-on.svg` assets with the newer versions from Desktop.
- Added `assets/icons/side-nav/icon-down-off.svg` and `assets/icons/side-nav/icon-down-on.svg` for upcoming nav work.
- Reconciled `README.md` and `HANDOFF.md` to reflect the current branch state.

## Verification
- `git diff --check`

## Open Items
- Push `codex/home-work-experience-copy`.
- Open the PR with `Closes #66`.

## Resume Checklist
1. `git branch --show-current`
2. `git status --short --branch`
3. Review `README.md` and `HANDOFF.md`
4. Run `git diff --check`
5. `git push -u origin codex/home-work-experience-copy`
6. Open the PR with `Closes #66`
