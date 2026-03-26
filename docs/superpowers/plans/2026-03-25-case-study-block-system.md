# Case Study Block System Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the fixed case-study article template with a reusable block-based system that supports varied editorial layouts, lightweight carousel behavior, and future CMS-friendly structure without introducing a new framework or CMS.

**Architecture:** Keep the existing static page shell and shared rail/footer behaviors intact, then refactor the case-study story surface into a semantic block namespace inside `assets/css/work-case-study.css` and the four `work/<slug>/index.html` pages. Use Resy as the canonical pilot because the approved Figma pattern already describes that story, then migrate the other case studies onto the same block vocabulary once the CSS and optional carousel enhancement are stable. After the story body is stable, add a dedicated bottom recirculation surface with previous/next promos and a tertiary `See all case studies` link.

**Tech Stack:** Static HTML, shared CSS in `assets/css/work-case-study.css`, shared vanilla JS in `assets/js/main.js`, shell-based structural checks, `make dev-thread` / `make dev-live-thread` preview workflow.

---

### Task 1: Establish The Block-System Guardrails And Pilot Skeleton

**Files:**
- Create: `scripts/check-case-study-blocks.sh`
- Modify: `work/resy-discovery/index.html:88-220`
- Test: `scripts/check-case-study-blocks.sh`

- [ ] **Step 1: Write the failing structural check script**

Create `scripts/check-case-study-blocks.sh` so it:
- checks the pilot page for the shared block namespace marker, for example `case-study-story` and `case-study-block`
- checks the pilot page (`work/resy-discovery/index.html`) for the required opening rhythm markers: `case-study-block-hero`, `case-study-block-meta`, `case-study-block-lede`
- allows the Resy pilot to remain in a mixed legacy/new state until Task 3 completes
- allows the non-pilot case-study pages to remain on legacy markup until Task 4 completes
- prints a short success message such as `case-study block checks passed`

Suggested script shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

pages=(
  "work/resy-discovery/index.html"
  "work/sendmoi/index.html"
  "work/somm-ai/index.html"
  "work/ai-quota/index.html"
)

expect() {
  local file="$1"
  local pattern="$2"
  local message="$3"
  rg -q "$pattern" "$file" || { echo "FAIL: $message"; exit 1; }
}
```

- [ ] **Step 2: Run the check script to verify it fails before the refactor**

Run:

```bash
chmod +x scripts/check-case-study-blocks.sh
./scripts/check-case-study-blocks.sh
```

Expected: FAIL with a message that the Resy page is missing the new block markers.

- [ ] **Step 3: Refactor the Resy page opening structure into the new semantic skeleton**

Update [work/resy-discovery/index.html](/Users/niederme/~Repos/nieder.me/work/resy-discovery/index.html) so the current hero/meta/body layout becomes a semantic pilot structure:
- wrap story content in a shared `case-study-story`
- convert the existing hero section into `case-study-block case-study-block-hero`
- convert the metadata aside into `case-study-block case-study-block-meta`
- insert a dedicated `case-study-block case-study-block-lede` immediately after metadata
- convert the remaining narrative sections into block wrappers such as `case-study-block-text` and `case-study-block-results`

Use a minimal markup pattern like:

```html
<section class="case-study-block case-study-block-lede">
  <div class="case-study-block-inner">
    <p class="case-study-lede">...</p>
  </div>
</section>
```

- [ ] **Step 4: Re-run the structural check to verify the pilot skeleton passes**

Run:

```bash
./scripts/check-case-study-blocks.sh
```

Expected: PASS for the new Resy skeleton, even though the pilot page may still contain legacy body sections until Task 3 and the other case-study pages remain on legacy markup until Task 4.

- [ ] **Step 5: Commit the pilot guardrails**

Run:

```bash
git add scripts/check-case-study-blocks.sh work/resy-discovery/index.html
git commit -m "chore: scaffold case study block system"
```

Expected: a commit containing the verification script and the Resy pilot skeleton only.

### Task 2: Build The Shared CSS Block Library

**Files:**
- Modify: `assets/css/work-case-study.css:642-765`
- Modify: `assets/css/work-case-study.css:1086-1147`
- Modify: `assets/css/work-case-study.css:1320-1533`
- Test: `scripts/check-case-study-blocks.sh`

- [ ] **Step 1: Add the new block namespace without disturbing the page shell**

Extend [assets/css/work-case-study.css](/Users/niederme/~Repos/nieder.me/assets/css/work-case-study.css) by keeping the existing page shell selectors intact:
- keep `.work-article`, `.work-grid-overlay`, rail, footer, and theme/grid controls
- add new story-level selectors like `.case-study-story`, `.case-study-block`, `.case-study-block-inner`
- avoid deleting legacy rules until all pages are migrated

Suggested section header:

```css
/* Case study block system */
.case-study-story { ... }
.case-study-block { ... }
.case-study-block-inner { ... }
```

- [ ] **Step 2: Implement the opening-system and text block styles**

Add CSS for:
- `case-study-block-hero`
- `case-study-block-meta`
- `case-study-block-lede`
- `case-study-block-text`
- `case-study-block-results`

Preserve the existing visual language:
- same typography family
- same dark/light behavior
- same 12-column rhythm
- improved editorial spacing based on the approved Figma direction

- [ ] **Step 3: Implement media and supporting block variants**

Add CSS for:
- `case-study-block-full-media`
- `case-study-block-aside-media`
- `case-study-block-two-up`
- `case-study-block-callout`
- `case-study-block-divider`
- shared caption styling such as `.case-study-caption`

Specific requirements:
- `aside-media` must collapse to a stacked presentation on smaller screens
- `two-up` should support equal and asymmetric layouts through modifier classes rather than bespoke one-off CSS

- [ ] **Step 4: Implement responsive behavior and a no-JS carousel fallback**

Add styles for:
- `case-study-block-carousel`
- a static fallback state where all slides remain visible in a vertical sequence or simple grid when JS is unavailable
- desktop/mobile spacing adjustments for the new block rhythm

Avoid hiding critical media by default in CSS. The default state should be readable without any JS enhancements.

- [ ] **Step 5: Run the structural check and commit the CSS foundation**

Run:

```bash
./scripts/check-case-study-blocks.sh
git add assets/css/work-case-study.css
git commit -m "feat: add case study block styles"
```

Expected:
- the structural check still passes for the Resy pilot
- the CSS commit is isolated from the remaining page migrations

### Task 3: Convert Resy Into The Canonical Editorial Reference

**Files:**
- Modify: `work/resy-discovery/index.html:88-220`
- Modify: `assets/js/main.js:1-260`
- Test: `scripts/check-case-study-blocks.sh`

- [ ] **Step 1: Replace the remaining Resy legacy body sections with block-based editorial markup**

Refactor [work/resy-discovery/index.html](/Users/niederme/~Repos/nieder.me/work/resy-discovery/index.html) so it demonstrates the intended system:
- keep the existing hero/media asset sources
- add a stronger lede block
- convert the narrative into a mix of `text`, `full-media`, at least one explicit `aside-media`, `two-up`, and `results`
- remove the old `.work-article-section` + `.work-article-visuals` pattern from the pilot page

Target outcome:
- this page becomes the implementation reference for the other case studies
- the composition should visibly echo the approved Figma rhythm

- [ ] **Step 2: Add the smallest necessary JS enhancement for carousel behavior**

Update [assets/js/main.js](/Users/niederme/~Repos/nieder.me/assets/js/main.js) with an isolated block that:
- discovers `.case-study-block-carousel` instances
- wires next/previous or pagination controls only when a carousel actually exists
- leaves all media visible when JS cannot enhance the block

Suggested shape:

```js
{
  const carousels = Array.from(document.querySelectorAll(".case-study-block-carousel"));
  carousels.forEach((carousel) => {
    // enhance only if controls and multiple slides exist
  });
}
```

- [ ] **Step 3: Run preview and verify the pilot visually**

Run:

```bash
make dev-live-thread
```

Expected:
- output includes `Live reload on this Mac:` and `Live reload on your network:`
- the Resy case study at `/work/resy-discovery/` shows the new editorial block rhythm on desktop and mobile widths

Manual checks:
- dark and light mode both work
- the grid overlay toggle still works
- the carousel is usable with JS enabled
- the page remains readable when JS is disabled

- [ ] **Step 4: Re-run the structural check**

Run:

```bash
./scripts/check-case-study-blocks.sh
```

Expected: PASS with no legacy gallery markup left on the Resy page.

- [ ] **Step 5: Commit the canonical Resy conversion**

Run:

```bash
git add work/resy-discovery/index.html assets/js/main.js
git commit -m "feat: convert resy case study to block system"
```

Expected: a commit that locks the reference implementation before the remaining migrations.

### Task 4: Migrate The Remaining Case Studies To The Shared Block Vocabulary

**Files:**
- Modify: `work/sendmoi/index.html:88-216`
- Modify: `work/somm-ai/index.html:88-227`
- Modify: `work/ai-quota/index.html:88-232`
- Test: `scripts/check-case-study-blocks.sh`

- [ ] **Step 1: Convert SendMoi to the new block structure**

Refactor [work/sendmoi/index.html](/Users/niederme/~Repos/nieder.me/work/sendmoi/index.html) to use the new block classes while preserving existing copy and assets.

Recommended composition:
- hero
- meta
- lede
- text
- full-media
- aside-media if one of the supporting screenshots benefits from an inset treatment instead of a full-width block
- callout or inline results
- carousel or two-up if the image sequence benefits from grouping

- [ ] **Step 2: Convert Somm AI to the new block structure**

Refactor [work/somm-ai/index.html](/Users/niederme/~Repos/nieder.me/work/somm-ai/index.html) using a lighter, concept-oriented composition:
- hero
- meta
- lede
- text-heavy sections
- `two-up` for competitive/benchmark visuals if the assets support it
- compact closing results block

- [ ] **Step 3: Convert AIQuota to the new block structure carefully**

Refactor [work/ai-quota/index.html](/Users/niederme/~Repos/nieder.me/work/ai-quota/index.html) onto the shared block system without disturbing unrelated branch work.

Guardrail:
- inspect `git status --short work/ai-quota/index.html` immediately before editing
- if the file has unexpected user changes at implementation time, stop and reconcile before continuing by either merging that unrelated work first or explicitly skipping AIQuota for the current rollout and noting the deferral in the handoff

- [ ] **Step 4: Expand the structural check to cover all migrated pages, then run it**

Update `scripts/check-case-study-blocks.sh` so all four case-study pages must now include:
- the shared block namespace marker
- the required opening rhythm markers
- no legacy `.work-article-visuals` block

Run:

```bash
./scripts/check-case-study-blocks.sh
```

Expected: PASS for all four case-study pages.

- [ ] **Step 5: Commit the remaining page migrations**

Run:

```bash
git add work/sendmoi/index.html work/somm-ai/index.html work/ai-quota/index.html scripts/check-case-study-blocks.sh
git commit -m "feat: migrate case studies to shared block layout"
```

Expected: a single commit covering the non-pilot case-study migrations and the stricter structural check.

### Task 5: Add Case-Study Recirculation

**Files:**
- Modify: `assets/css/work-case-study.css`
- Modify: `work/resy-discovery/index.html`
- Modify: `work/sendmoi/index.html`
- Modify: `work/somm-ai/index.html`
- Modify: `work/ai-quota/index.html`
- Test: `scripts/check-case-study-blocks.sh`

- [ ] **Step 1: Add a recirculation guardrail to the check script**

Update `scripts/check-case-study-blocks.sh` so all case-study pages must include:
- a shared recirculation wrapper such as `case-study-recirculation`
- at least one recirculation promo link
- a `See all case studies` link

Expected:
- the check fails before the markup and CSS land

- [ ] **Step 2: Build the shared recirculation styles**

Extend [assets/css/work-case-study.css](/Users/niederme/~Repos/nieder.me/assets/css/work-case-study.css) with a dedicated recirculation module that:
- sits between the story close and the footer
- reuses the visual language of the `/work` case-study promos without simply duplicating the full work-index block
- supports two large visual promos on desktop and stacked promos on mobile
- supports optional `previous` or `next` omission at the ends of the sequence
- includes a low-emphasis `See all case studies` link

- [ ] **Step 3: Add recirculation markup to all four case studies**

Add a `case-study-recirculation` section to each case study with a fixed editorial order:
1. `Resy Discovery`
2. `SendMoi`
3. `Somm AI`
4. `AIQuota`

Requirements:
- first page omits `Previous case study`
- last page omits `Next case study`
- intermediate pages show both
- each promo uses project-specific imagery, eyebrow, title, and directional label

- [ ] **Step 4: Re-run the structural check and verify visually**

Run:

```bash
./scripts/check-case-study-blocks.sh
make dev-thread
```

Manual checks:
- recirculation appears above the footer on every case study
- direction labels are correct for each page
- desktop layout feels like an editorial continuation, not a mini `/work` index reset
- mobile layout stacks cleanly

- [ ] **Step 5: Commit the recirculation surface**

Run:

```bash
git add assets/css/work-case-study.css scripts/check-case-study-blocks.sh work/resy-discovery/index.html work/sendmoi/index.html work/somm-ai/index.html work/ai-quota/index.html
git commit -m "feat: add case study recirculation promos"
```

Expected: a single commit containing the shared recirculation system and page wiring.

### Task 6: Cache-Busting And Regression Verification Across Shared Consumers

**Files:**
- Modify: `work/resy-discovery/index.html:33,286`
- Modify: `work/sendmoi/index.html:33,282`
- Modify: `work/somm-ai/index.html:33,293`
- Modify: `work/ai-quota/index.html:33,298`
- Modify: `work/index.html:33,578`
- Modify: `about/index.html:33,215`
- Modify: `colophon/index.html:33,219`
- Modify: `styleguide/index.html:29,636`
- Test: `scripts/check-case-study-blocks.sh`

- [ ] **Step 1: Bump the shared asset cache-busting query strings**

Update every page that loads the changed shared assets so:
- `work-case-study.css?v=...` receives a new version token
- `main.js?v=...` receives a new version token if the carousel enhancement shipped

Do not rewrite unrelated HTML while touching these files. Limit edits to the asset URLs unless a real regression is found.
This scope intentionally includes `/work/`, `/about/`, `/colophon/`, and `/styleguide/` because they currently reference the same shared stylesheet and JS assets as the case-study pages.

- [ ] **Step 2: Verify non-case-study pages that share the stylesheet**

Run:

```bash
make dev-thread
```

Expected:
- output includes `Serving on this Mac:` and `Serving on your network:`
- `/work/`, `/about/`, `/colophon/`, and `/styleguide/` still render correctly after the shared CSS changes

Manual checks:
- the work index grid still aligns
- About and Colophon spacing does not regress
- the styleguide still loads the updated assets
- `/about/` and `/work/` show no console errors or broken interactions from the shared `main.js` carousel enhancement path

- [ ] **Step 3: Re-run the structural check and a clean git diff review**

Run:

```bash
./scripts/check-case-study-blocks.sh
BRANCH_BASE=$(git merge-base HEAD main)
git diff --stat "$BRANCH_BASE"..HEAD
```

Expected:
- the structural check passes
- the diff stat is limited to the planned CSS, JS, script, and case-study/shared asset-link files relative to the feature branch base

- [ ] **Step 4: Commit the cache-bust and shared-surface verification pass**

Run:

```bash
git add work/resy-discovery/index.html work/sendmoi/index.html work/somm-ai/index.html work/ai-quota/index.html work/index.html about/index.html colophon/index.html styleguide/index.html
git commit -m "chore: refresh case study asset versions"
```

Expected: a final cleanup commit containing only shared asset URL version bumps and any tiny regression fixes discovered during verification.

- [ ] **Step 5: Capture final verification notes for handoff**

Record in the final handoff:
- preview URL used
- pages manually checked
- JS-on and JS-off carousel behavior
- any intentional follow-up ideas that were explicitly deferred, such as a future CMS or richer authoring model
