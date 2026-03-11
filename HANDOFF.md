# Handoff

## Branch
- `codex/feature-branch-process`

## Current Focus
- Make the repo lifecycle docs explicitly require feature-branch work before implementation.

## What Changed
- Added a `Feature Branch First` section to `AGENTS.md`.
- Made the rule explicit that implementation work must not begin on `main`.
- Added a matching `Development workflow` section to `README.md` with branch/worktree examples.
- Removed the duplicated `Thread/Branch Isolation` section from `AGENTS.md`.

## Verification
- `git diff` should show doc-only changes in `AGENTS.md`, `README.md`, and `HANDOFF.md`.

## Open Items
- Commit and push the docs update branch.
- If desired, cherry-pick or merge the docs update back after review.

## Resume Checklist
1. `git branch --show-current`
2. `git status --short`
3. Review `AGENTS.md` and `README.md`
4. Commit and push `codex/feature-branch-process`
