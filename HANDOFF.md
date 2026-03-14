# Handoff

## Branch
- `codex/preview-live-reload`

## Current Focus
- Land preview-server live reload support under issue `#62`, so any local preview target can opt into BrowserSync with `LIVE=1`.

## Tracking
- GitHub issue `#62` tracks the preview live-reload workflow update.

## What Changed
- Added `LIVE=1` support to `make dev`, `make dev-thread`, and `make dev-local`.
- Kept `make dev-live` and `make dev-live-thread` as compatibility aliases that route through the same live mode.
- Consolidated the live-reload startup logic into the existing preview targets instead of maintaining a separate command family.
- Updated the BrowserSync watch list to follow the current site structure, including `work/**/*.html`.
- Updated `README.md` to document the new `LIVE=1` usage and the current watched paths.

## Verification
- `git diff --check`
- `make -n dev LIVE=1 PORT=7788 PORT_AUTO=0`
- `make -n dev-thread LIVE=1 PORT_AUTO=0`
- `make -n dev-local LIVE=1 PORT=7789 PORT_AUTO=0`
- Started `make dev-thread LIVE=1 PORT=7790 PORT_AUTO=0` and confirmed BrowserSync served and watched successfully at `http://Niederbook-Air-M4.local:7790`

## Open Items
- Push `codex/preview-live-reload`.
- Open the PR with `Closes #62`.

## Resume Checklist
1. `git branch --show-current`
2. `git status --short --branch`
3. Review `README.md` and `HANDOFF.md`
4. Run `git diff --check`
5. `git fetch origin`
6. `git rebase origin/main`
7. `git push -u origin codex/preview-live-reload`
8. Open the PR with `Closes #62`
