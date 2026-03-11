# Handoff

## Branch
- `codex/minor-tweaks`

## Current Focus
- Footer refinement across all pages, plus final rail polish.

## What Changed
- Footer now exists on all key pages:
  - `/`
  - `/work`
  - `/work/resy-discovery/`
  - `/work/sendmoi/`
- Footer layout/system updates:
  - Removed standalone `Connect` text-link column.
  - Moved social icon row under `John Niedermeyer` + `Product Design & Direction`.
  - Placed `© 2026 John Niedermeyer` below the icon row.
  - Rebalanced desktop columns: wider brand block + `Case Studies` + `Policies`.
  - Footer links use white text with animated underline on hover/focus.
  - Footer heading color now matches copyright gray.
- Work-page rail polish:
  - Removed unintended top divider line above the first rail item (`.work-case-anchor:first-child { border-top: none; }`).
- Routing/content polish retained in this branch:
  - Home overflow link now routes to `/work`.
  - `/work` placeholder page included and uses shared rail/footer language.
  - Article rail `Work Experience` slot routes to `/work`.

## Verification
- `node --check assets/js/main.js` passes.
- Manual HTML/CSS/link-target review of:
  - `/`
  - `/work`
  - `/work/resy-discovery/`
  - `/work/sendmoi/`

## Open Items
- Commit, push branch, and open PR.

## Resume Checklist
1. `git checkout codex/minor-tweaks`
2. `git status --short`
3. Run `make` and verify:
   - `/`
   - `/work`
   - `/work/resy-discovery/`
   - `/work/sendmoi/`
4. Commit + push
5. Open PR
