# Handoff

## Branch
- `codex/fix-ga4-report-caveats`

## Current Focus
- SendMoi draft case study refinement in `drafts/work/sendmoi/`.
- Current live preview: `make dev-live` from the repo root on port `8000`.
- Phone/Tailscale preview used in this session: `http://100.73.155.95:8000/drafts/work/sendmoi/`.

## Tracking
- No GitHub issue is currently attached to this SendMoi draft refinement pass.

## What Changed
- Reworked the SendMoi case-study lede around a focused send-to-self app and AI-assisted product execution.
- Polished the opening narrative:
  - `Reconstructing a Lost Workflow`
  - tighter Mailo/save-for-later setup
  - clearer share-sheet friction around too many taps, default recipient, and auto-send
  - smoother bridge into Codex/Claude Code as execution tools
- Rewrote the demo caption so it reads as editorial context instead of alt text.
- Reworked the next product section as `Designing for One Job`, focused on scope discipline, dependable delivery, and not letting AI-assisted work sprawl.
- Reworked setup section copy and heading to `Set It Once, Then Trust It`, emphasizing a friendly face for Gmail access and default-recipient setup.
- Updated SendMoi mobile hero art to reuse the desktop topper art.
- Adjusted responsive case-study CSS so full-media captions collapse into the existing `<960px` mobile layout instead of using sidecar caption positioning.
- Scoped larger mobile SendMoi phone-image sizing to:
  - `case-study-block-sendmoi-setup`
  - `case-study-block-sendmoi-autosend`
- Cache-busted the SendMoi draft stylesheet link with `?v=sendmoi-20260507-3` for phone review.

## Notes
- The SendMoi setup/autosend media sizing is intentionally draft-specific for now. When the CMS/block system is built, turn this into a block/media presentation option rather than a content-specific CSS selector.
- Below `960px`, case-study layouts should generally behave like mobile. Avoid adding extra orientation-specific breakpoints unless a shared rule cannot solve the issue.
- `drafts/` remains excluded from deploy and should not be linked from public pages.

## Verification
- `git diff --check -- drafts/work/sendmoi/index.html assets/css/work-case-study.css`
- Served CSS verified locally with `curl` against `http://127.0.0.1:8000/`.
- Phone review happened through Tailscale using the URL above.

## Open Items
- Continue polishing the remaining SendMoi sections after `Set It Once, Then Trust It`.
- Recheck mobile portrait after cache busting; the setup/autosend phone images should now be larger.
- Recheck landscape phone under the shared `<960px` layout path.

## Resume Checklist
1. `git branch --show-current`
2. `git status --short --branch`
3. Start or reuse preview: `make dev-live`
4. Review `http://100.73.155.95:8000/drafts/work/sendmoi/` on phone if Tailscale IP is still current
5. Continue from the section after `Set It Once, Then Trust It`
6. Run `git diff --check`
7. Keep `drafts/` out of deploy/public links
