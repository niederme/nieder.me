# Repository Instructions

## Commit Workflow
- Before every commit, review `README.md` and `HANDOFF.md`.
- Update `README.md` whenever setup steps, commands, behavior, or other user-facing documentation changed.
- Update `HANDOFF.md` whenever the working branch, current focus, recent changes, open items, or resume steps changed.
- Do not finalize a commit until those files are either updated or explicitly confirmed to still be accurate.

## Thread/Branch Isolation
- Assume Codex threads share a single Git worktree unless explicitly separated.
- Before any git operation, run `git branch --show-current` and verify it matches the task branch.
- If the branch does not match the expected branch, stop and ask the user before switching.
- Do not run `git checkout`, `git pull`, or `git merge` on a different branch without explicit user approval.
- Preferred workflow: use `git worktree` with one directory per active thread/feature branch.

## Thread/Branch Isolation
- Assume Codex threads share a single Git worktree unless explicitly separated.
- Before any git operation, run `git branch --show-current` and verify it matches the task branch.
- If the branch does not match the expected branch, stop and ask the user before switching.
- Do not run `git checkout`, `git pull`, or `git merge` on a different branch without explicit user approval.
- Preferred workflow: use `git worktree` with one directory per active thread/feature branch.
