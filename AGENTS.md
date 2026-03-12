# Repository Instructions

## Delivery Lifecycle Workflow

### 1) Start New Feature/Fix Work
- For feature/fix work, write or identify the GitHub issue first. Small doc-only or chore-only changes do not require an issue unless explicitly requested. Every non-doc/chore branch should map to one primary issue.
- Before writing code, editing files, or starting implementation work, run `git branch --show-current`.
- If you are on `main`, create or switch to a feature branch before making changes.
- Do not treat `main` as a working branch for active development, unless told explicitly to.
- Default workflow for non-trivial work: create a dedicated `git worktree` for each active feature branch/thread so multiple branches can stay in progress at once. For trivial one-off changes, a normal branch in the main checkout is fine.
- Do not push directly to `main`; all work happens on a task branch, unless told explicitly to.
- Work from `main` on short-lived branches named `codex/*`.
- Start from latest `main`:
  - `git checkout main`
  - `git pull --ff-only`
  - `git checkout -b codex/<short-slug>`
- For concurrent work, use separate branches and prefer separate worktrees:
  - `git worktree add ../<repo-name>-<short-slug> -b codex/<short-slug> main`
- Keep scope tight: branch changes should stay focused on the linked issue.

### 2) Implement And Commit
- Commit at sensible, verifiable milestones without waiting for approval.
- Multiple commits per branch are fine; keep them scoped and readable.
- Do not include unrelated working tree changes in commits unless explicitly requested.
- Update docs during development when the commit changes setup steps, commands, behavior, or active-branch context.
- Prefer milestone-sized doc updates during implementation to reduce conflict churn.

### 3) When Asked To Open A PR
- Confirm the issue number to link in the PR. If missing, ask before creating the PR.
- Complete relevant tests/checks.
- Run a full docs reconciliation pass before opening the PR:
  - review `README.md` and `HANDOFF.md` end-to-end
  - update both files to match the final branch state, or explicitly confirm they are still accurate
- Sync branch right before PR creation:
  - `git fetch origin`
  - `git rebase origin/main` (or merge `origin/main` when rebase is not appropriate)
- Resolve conflicts, rerun checks, and re-verify `README.md` / `HANDOFF.md`, then push:
  - normal push: `git push -u origin codex/<short-slug>`
  - after rebase: `git push --force-with-lease`
- Open PR against `main` and link the issue in the PR body using `Closes #<issue-number>`.
- Ensure the PR is reviewable and checks are passing before merge; squash merge is preferred.
- This is a solo-review workflow: no required approvals, but do not merge until diff and checks are complete.

### 4) After Merge Confirmation
- Sync local `main`:
  - `git checkout main`
  - `git pull --ff-only`
- Clean up feature branch:
  - `git branch -d codex/<short-slug>` (if this fails after squash merge, use `git branch -D codex/<short-slug>`)
  - `git push origin --delete codex/<short-slug>` (if remote branch exists)
- Clean up parallel workspace metadata when used:
  - `git worktree prune`

## GitHub Issues Workflow
- Treat messages prefixed with `BUG:` or `ISSUE:` as a request to create a GitHub issue directly.
- Classify issue type and labels based on context (for example: `bug`, `enhancement`, `chore`) unless the user explicitly forces a type.
- If the user includes a type hint inline (for example: `ISSUE: [bug] ...`), honor it.
- If required details are missing, ask a short follow-up question before creating the issue. Otherwise, create it without an extra confirmation step.
- If the user provides screenshots/videos, include them in the issue:
  - use existing URLs directly when available
  - if media is local-only, ask for a shareable URL or confirm the user will attach it manually (do not require committing media into this repo).
