# Handoff

## Branch
- `codex/focus-states`

## Current Focus
- Ship the bundled focus/browser-hint tweaks on this branch via PR for issue `#32`.

## What Changed
- Opened GitHub issue `#32` to track site-wide focus-state cleanup.
- Added shared focus design tokens in `assets/css/styles.css` and `assets/css/work-case-study.css`.
- Replaced the browser-default focus treatment with a subdued red `:focus-visible` outline across interactive elements.
- Added a separate soft red outer glow to control-style elements, including the spinning logo, rail nav controls, social icons, cards, CTA buttons, and the `cols` toggle.
- Left the existing hover/focus icon swaps and text-color changes intact so the new focus treatment layers on top of current interaction cues.
- Declared the site dark-only at the document/CSS root level, and all home/work pages now declare a black `theme-color`.
- Updated `README.md` to document the shared focus treatment.

## Verification
- Keyboard through the homepage and confirm the logo, left rail anchors, social links, CTA buttons, footer links, and `cols` toggle all show the subdued red focus ring plus outer glow.
- Confirm those control-style elements also pick up the subtle red halo without shifting layout.
- Keyboard through `/work`, `/work/resy-discovery/`, and `/work/sendmoi/` and confirm the same focus treatment appears there.
- Confirm mouse clicks no longer leave the browser’s default purple focus ring on the logo.
- In mobile Safari light and dark system appearance, confirm the site/browser chrome stays on the dark theme hints (`color-scheme: dark` and black `theme-color`) where Safari honors them.

## Open Items
- Push `codex/focus-states` and open the PR for issue `#32`.

## Resume Checklist
1. `git branch --show-current`
2. `git status --short`
3. Review `README.md` and `HANDOFF.md`
4. Run the local server and keyboard through home and work pages
5. Confirm the focus ring/halo reads clearly on desktop and mobile layouts
6. Push/open PR for `codex/focus-states`
