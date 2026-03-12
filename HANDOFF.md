# Handoff

## Branch
- `codex/deploy-staged-cache-bust`

## Current Focus
- Stop deploy from mutating tracked source files when updating site metadata and cache-busted asset URLs.

## What Changed
- Updated `scripts/deploy-2026.sh` to build a temporary staging directory for deploy output instead of rewriting tracked source files in place.
- Updated `scripts/set-site-url.sh` to accept an optional HTML target path so deploy can rewrite metadata in the staged `index.html`.
- Switched deploy-time cache busting from date-sequence tokens stored in source to per-file content hashes computed from the staged CSS and JS assets.
- Updated `README.md` deploy documentation to reflect the staged deploy flow and non-mutating cache-bust behavior.

## Verification
- Verified with a mocked deploy run using fake `ssh`/`rsync` wrappers:
  - the worktree stayed unchanged before and after the deploy script ran
  - the staged `index.html` received rewritten site metadata for the provided `SITE_URL`
  - the staged `index.html` received hashed cache-bust query params for `styles.css` and `main.js`

## Open Items
- GitHub issue: `#25 Stop deploy from mutating tracked index.html`
- Commit and push `codex/deploy-staged-cache-bust`.
- Open PR and merge after review.
- Decide whether to drop the stale stash after this branch lands.

## Resume Checklist
1. `git branch --show-current`
2. `git status --short`
3. Review `README.md` and `HANDOFF.md`
4. Verify mocked deploy leaves the worktree clean
5. Commit and push `codex/deploy-staged-cache-bust`
6. Open PR to `main`
