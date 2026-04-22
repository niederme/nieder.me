# Handoff

## Branch
- `codex/docs-refresh`

## Current Focus
- Documentation audit after the 2026 site launch work landed on `main`.

## Tracking
- No GitHub issue is currently attached to this docs refresh.

## What Changed
- Refreshed `README.md` so the current site surface distinguishes live case studies from public "Coming Soon" teaser cards and preserved drafts.
- Added the `colophon/` and `styleguide/` legacy redirect pages to the README surface list.
- Documented that `assets/css/styleguide.css` is part of the core style stack.
- Updated the worktree example to use repo-local `.worktrees/`, matching the repo convention.
- Clarified that staged deploys include redirect pages and exclude `drafts/`.

## Verification
- `git diff --check`
- `bash scripts/check-launch-case-studies.sh`
- `python3 scripts/check-deploy-2026.py`

## Open Items
- None.

## Resume Checklist
1. `git branch --show-current`
2. `git status --short --branch`
3. Review `README.md` and `HANDOFF.md`
4. Run `git diff --check`
5. Run `bash scripts/check-launch-case-studies.sh`
6. Run `python3 scripts/check-deploy-2026.py`
7. If rendered site files change later, start or reuse a preview and include the exact URL
