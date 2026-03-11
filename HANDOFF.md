# Handoff

## Branch
- `codex/fix-deploy-work-sync`

## Current Focus
- Final homepage/article polish + deploy script sync fix.

## What Changed
- Updated deploy script `scripts/deploy-2026.sh` so sync includes:
  - `index.html`
  - `assets/`
  - `work/` (if present)
  - `sendmoi/` (if present)
- Updated article back links to use directory roots instead of explicit `index.html`.
- Removed footer `Policies` column/links from:
  - `/`
  - `/work`
  - `/work/resy-discovery/`
  - `/work/sendmoi/`
- Removed homepage mobile section nav completely:
  - removed HTML markup block in `index.html`
  - removed JS controller block in `assets/js/main.js`
  - removed related CSS rules in `assets/css/styles.css`
- Updated README notes for deploy behavior, footer composition, and mobile nav removal.

## Verification
- `node --check assets/js/main.js` passes.
- `rg "mobile-section-nav"` returns no matches in `index.html`, `assets/css/styles.css`, `assets/js/main.js`.
- `rg 'href="[^"]*index\\.html'` returns no remaining homepage/article nav links.
- `rg 'href="/sendmoi/'` returns no remaining footer policy links.

## Open Items
- Commit and push this branch.
- Open PR and merge.
- Run `./scripts/deploy-2026.sh` from a shell with deploy SSH credentials loaded.

## Resume Checklist
1. `git checkout codex/fix-deploy-work-sync`
2. `git status --short`
3. Open/merge PR
4. Run deploy:
   - `./scripts/deploy-2026.sh`
5. Verify:
   - `https://nieder.me/2026/work/`
   - `https://nieder.me/2026/work/resy-discovery/`
   - `https://nieder.me/2026/work/sendmoi/`
