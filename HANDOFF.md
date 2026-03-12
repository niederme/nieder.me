# Handoff

## Branch
- `codex/hotfix-deploy-root-sync`

## Current Focus
- Hotfix the deploy script so it does not delete unmanaged root-level server files during staged deploys.

## What Changed
- Updated `scripts/deploy-2026.sh` to keep the staged deploy flow but sync only the managed staged paths (`index.html`, `assets/`, and when present `work/` / `sendmoi`) instead of syncing the entire staged root.
- This avoids deleting unrelated root-level server files such as host-managed config during `rsync --delete`.
- Updated `README.md` deploy documentation to clarify that only managed staged paths are synced.

## Verification
- Verified with a mocked deploy run using fake `ssh`/`rsync` wrappers:
  - deploy still stages `index.html` and computes hashed cache-bust query params
  - `rsync` now receives explicit staged paths instead of the staged root directory
  - the command includes staged `index.html`, `assets`, and `work` as expected

## Open Items
- Commit and push `codex/hotfix-deploy-root-sync`.
- Redeploy and verify `https://nieder.me/2026/` no longer returns 403.
- Open PR and merge after review if desired.

## Resume Checklist
1. `git branch --show-current`
2. `git status --short`
3. Review `README.md` and `HANDOFF.md`
4. Run or rerun deploy from `codex/hotfix-deploy-root-sync`
5. Verify the homepage loads
6. Commit/push/open PR if we keep the hotfix branch workflow
