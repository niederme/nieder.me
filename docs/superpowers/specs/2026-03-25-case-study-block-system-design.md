# Case Study Block System Design

**Date:** 2026-03-25

**Goal:** Replace the current fixed long-form case-study template with a reusable block-based system that supports varied editorial layouts in the existing static HTML/CSS stack and prepares the site for a future CMS migration.

## Summary

The site's current case-study pages share one narrow article template with a hero, metadata rail, a sequence of text sections, and a simple visuals gallery. That structure is easy to maintain, but it does not support the more editorial rhythm shown in the Figma exploration: large hero treatments, a stronger lede, alternating text wells and media moments, inset side media, paired visuals, and interactive media sequences.

This redesign should introduce a small, opinionated library of reusable case-study blocks. Each case study remains a hand-authored static HTML page for now, but the body is composed from interchangeable semantic sections instead of page-specific layout markup. The result should feel flexible enough to support different stories while still remaining disciplined, coherent, and portable to a future CMS block model.

## Desired Authoring Model

### Phase 1 authoring

- Keep each case study as a standalone HTML page in `work/<slug>/index.html`.
- Keep the current static-site stack: no CMS, no framework migration, no broad site rebuild.
- Replace ad hoc section structures with reusable block markup inside the shared case-study shell.
- Author pages by stacking a controlled set of blocks in different orders rather than inventing new layout structures per project.

### CMS-friendly constraint

Even though phase 1 stays HTML-first, each block should be named and structured as if it could later become a CMS content type. That means each block should map cleanly to:

- a stable block type identifier
- a predictable content payload
- a small number of sanctioned variants
- explicit asset references

Human-facing language can stay editorial and design-oriented, but implementation naming should remain stable and machine-friendly.

## Page Architecture

Each case-study page should be organized into two layers:

### 1. Shared shell

The shell remains consistent across all case studies and preserves the site's existing chrome:

- fixed rail navigation
- theme toggle
- column-grid toggle
- footer
- overall article width and responsive behavior

This shell should continue using the current work/case-study page conventions so the block system changes the storytelling surface without rethinking the rest of the site.

### 2. Block-based story body

Inside the shell, the case-study content becomes an ordered sequence of reusable blocks. The opening rhythm should remain recognizable across all stories:

1. `hero`
2. `meta`
3. `lede`

After that opening system, the body should be assembled from text, media, and callout blocks as needed.

## Block Library

The first-pass library should stay intentionally small.

### `hero`

Purpose:
- Establish the project quickly with logo, eyebrow, title, optional summary, and hero media treatment.

Supported variants:
- image-led
- device-led
- quiet/minimal

Notes:
- The hero remains part of the shared case-study identity and should preserve the bold top-of-page treatment from the current design system.

### `meta`

Purpose:
- Present project facts such as role, organization, timeframe, status, platforms, collaborators, and relevant links.

Notes:
- This should remain visually consistent across all case studies even when individual fields vary.
- The markup should support omitted rows without breaking spacing.

### `lede`

Purpose:
- Introduce the story with a larger opening paragraph or short group of paragraphs.

Notes:
- This is a distinct block, not just the first normal text section.
- It should carry stronger typographic emphasis than the body copy.

### `text`

Purpose:
- Provide the main reading column for narrative sections.

Supported variants:
- standard
- with section heading

Notes:
- This block should be the default narrative unit and preserve comfortable reading width.

### `full-media`

Purpose:
- Present a large visual moment such as a full-width image, mockup, diagram, or video.

Supported variants:
- full-bleed/wide
- inset

Notes:
- Includes a consistent caption treatment.
- Intended for moments that need emphasis, not every image on the page.

### `aside-media`

Purpose:
- Present a smaller supporting visual adjacent to or between text sections.

Supported variants:
- left
- right

Notes:
- Best used for supporting screenshots, detail crops, or secondary examples.

### `two_up`

Display/editor label:
- `2-up`

Purpose:
- Present two related visuals together for comparison, progression, or paired storytelling.

Supported variants:
- equal split
- asymmetric emphasis

Notes:
- This should be used intentionally for relationships between assets, not merely because two images exist.

### `carousel`

Purpose:
- Present a sequence of related visuals that benefit from interaction rather than page-length stacking.

Supported variants:
- screens/gallery
- before/after
- step sequence

Notes:
- Includes caption support and should degrade gracefully if JavaScript is unavailable or limited.

### `callout`

Purpose:
- Break the reading rhythm with a highlighted quote, principle, insight, or key takeaway.

Supported variants:
- quote
- principle
- takeaway

### `results`

Purpose:
- Close or punctuate the story with outcomes, learnings, launch notes, metrics, or related links.

Notes:
- Can be used once near the end or in shorter form mid-story if needed.

### `divider`

Purpose:
- Add breathing room or a structural transition without inventing a new content block.

Notes:
- Should be used sparingly.

## Composition Rules

Flexibility should come from composition, not from giving every block unlimited styling controls.

### Required opening rhythm

Every case study should begin with:

1. `hero`
2. `meta`
3. `lede`

This creates a recognizable page structure even when the body varies.

### Body rhythm

- Alternate dense reading sections with media moments to preserve pacing.
- Avoid stacking more than two visually heavy media blocks without a text reset.
- Use `aside-media` to support nearby text rather than interrupting the whole page flow.
- Reserve `carousel` for sequences where interaction improves comprehension.
- Keep captions and media metadata visually consistent regardless of block type.

### Editorial guardrails

- Prefer a tight vocabulary of blocks over one-off layout inventions.
- Add new block types only when a storytelling need cannot be handled by an existing block plus a sanctioned variant.
- Maintain strong vertical rhythm and consistent caption behavior across all case studies.

## Markup Strategy

Phase 1 should use semantic HTML block wrappers with predictable class names. The exact final naming can evolve during implementation, but the structure should look roughly like:

- shared block base: `case-study-block`
- block type modifier: `case-study-block-text`, `case-study-block-full-media`, `case-study-block-two-up`, etc.
- inner structural elements for heading, body, media, and caption wrappers

Each block should have a consistent internal structure so the HTML remains readable and future migration to structured content is straightforward.

## CSS Strategy

- Extend `assets/css/work-case-study.css` to support a shared block library instead of one fixed article body pattern.
- Preserve the site's current typography, dark/light mode behavior, rail spacing, and overall visual language.
- Add responsive layouts that preserve the editorial feel from the Figma frame while collapsing cleanly on smaller screens.
- Ensure all media blocks share consistent caption, spacing, and alignment rules.
- Avoid introducing styling patterns that only work for one case study.

## JavaScript Strategy

JavaScript should remain minimal.

- Reuse existing page JS for theme toggle, grid toggle, and shared site behaviors.
- Add only the smallest necessary interaction support for `carousel` if a static CSS-only treatment is insufficient.
- Do not introduce a client-side rendering layer or data-driven page assembly in phase 1.

## Content Portability to a Future CMS

The implementation should make a future CMS migration easier by treating each block as though it already has a content schema. For example, a future block payload should be conceptually able to represent:

- `type`
- `variant`
- heading or eyebrow fields when relevant
- rich text/body copy
- media asset references
- caption text
- optional layout alignment controls where sanctioned

This does not require implementing JSON or a renderer now. It only means the HTML and CSS architecture should mirror how the content would eventually be modeled.

## Files Likely In Scope

- `assets/css/work-case-study.css`
- `work/resy-discovery/index.html`
- `work/sendmoi/index.html`
- `work/somm-ai/index.html`
- `work/ai-quota/index.html`

Additional shared assets or lightweight JS may enter scope if the final `carousel` treatment requires them, but the redesign should avoid broad cross-site changes where possible.

## Risks and Guardrails

- The system could become too open-ended if block variants are allowed to proliferate without discipline.
- The system could fail the original goal if it stays too close to the current fixed article template.
- `carousel` interaction can easily become overbuilt; keep the first implementation intentionally lightweight.
- Existing case-study content may need selective restructuring so the new blocks feel intentional rather than mechanically wrapped around old copy.
- Because the repo currently has unrelated in-progress edits, implementation should avoid reverting or entangling those changes.

## Testing Expectations

- Verify each case-study page still renders correctly in dark and light mode.
- Verify the rail, footer, theme toggle, and grid toggle continue to behave as they do now.
- Verify new block layouts remain readable and stable on desktop and mobile widths.
- Verify captions, spacing, and media alignment remain consistent across `full-media`, `aside-media`, `2-up`, and `carousel`.
- Verify at least one converted case study demonstrates the intended editorial flexibility shown in Figma.
