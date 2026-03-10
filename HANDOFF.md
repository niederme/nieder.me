# Handoff

## Branch
- `codex/agents-thread-branch-isolation`

## Last Pushed
- `8fd47ed` `Add safe GitHub issue creation workflow (#12)`
- `265552a` `Merge pull request #9 from niederme/codex/make-hostname-open-fix`
- `be9e2ab` `Fix dev auto-open host detection across Macs`

## Current Focus
- Add explicit repository guardrails to prevent cross-thread branch switching in a shared worktree.

## What Changed
- Updated `AGENTS.md` with a new `Thread/Branch Isolation` section.
- Added requirements to:
  - verify current branch (`git branch --show-current`) before git operations
  - stop and ask before switching when branch does not match task expectations
  - avoid `checkout`/`pull`/`merge` on other branches without explicit user approval
  - prefer one `git worktree` per active thread/feature branch

## Open Items
- Open PR for `codex/agents-thread-branch-isolation` and merge when approved.
- Apply the same worktree-per-thread convention to active parallel tasks.

## Local Run
- N/A (documentation/process-only change)

## Resume Checklist
1. `git fetch --all`
2. `git checkout codex/agents-thread-branch-isolation`
3. `git pull --ff-only`
4. Review `AGENTS.md` thread/branch isolation rules
5. Open/merge PR when ready
