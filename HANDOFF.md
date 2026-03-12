# Handoff

## Branch
- `codex/worktree-preview-links`

## Current Focus
- Ship the worktree preview workflow update on this branch via PR for issue `#38`.

## What Changed
- Opened GitHub issue `#38` to track a predictable preview workflow for concurrent worktree threads.
- Added `make dev-thread` and `make dev-live-thread` in `Makefile`.
- Reserved `7777` as the default root-checkout preview port and documented the `7778`, `7779`, `7780`, and upward cascade for worktree previews.
- Updated `AGENTS.md` so rendered work in a worktree should start or reuse a preview when needed and include the exact preview URL in responses.
- Updated `README.md` with the new worktree preview commands and the expectation to surface preview URLs for rendered changes.

## Verification
- `make dev-thread`
- `git diff --check`
- Confirmed `make dev-thread` starts from `7778` and prints both the `.local` and LAN preview URLs.
- Dry-run checked `make dev-live-thread` to confirm it also seeds from `7778`.

## Open Items
- Push `codex/worktree-preview-links` and open the PR for issue `#38`.

## Resume Checklist
1. `git branch --show-current`
2. `git status --short`
3. Review `README.md` and `HANDOFF.md`
4. Run `make dev-thread` or `make dev-live-thread`
5. Confirm the preview URL uses the expected `7778+` worktree port range
6. Push/open PR for `codex/worktree-preview-links`
