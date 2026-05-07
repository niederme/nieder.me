# Slides template — handoff

**Figma file:** [nieder.me — Slides Template (Design source)](https://www.figma.com/design/9zSkbL94Fr8YJkHGY07gRU)
**Created:** 2026-05-01
**Original Figma Slides target:** [https://www.figma.com/slides/98eXTZI7mGNnQvtEMNqttK](https://www.figma.com/slides/98eXTZI7mGNnQvtEMNqttK)

## What this is

A regular Figma Design file (not a Slides file) containing 18 layout frames at 1920×1080, styled to match nieder.me. Pages:

- **Index** — title page + two-column TOC of all 18 layouts.
- **Layouts** — every slide laid out in a 3-column grid for easy review and copy-paste.
- **Tokens & components** — color swatches, type ramp specimen, shared components (rule, eyebrow tag, monogram, footer, title block).

## Why a Design file and not the Slides file you sent

Figma's plugin API doesn't currently support writing into Slides files (`/slides/` URLs). It rejects edits with: *"This tool is not yet supported for Slides files."* Tried it, it's a hard block.

So this Design file is the canonical visual source. Two ways to translate it into your `98eXTZI7mGNnQvtEMNqttK` Slides file:

1. **Copy-paste frames as image baselines.** Select a layout frame → copy → paste into the Slides file. Then add real text on top using Slides' native text tools. Faster but less editable.
2. **Rebuild natively in Slides using this file as truth.** Open both files side by side, recreate each layout using Slides' template editor. Slower but produces native, fully-editable Slides templates.

## Layouts in the deck

**Defaults (restyled):** 01 Cover · 02 Section header · 03 Title + body · 04 Title + media · 05 Two columns · 06 Three columns · 07 Full-bleed image · 08 Quote · 09 Stats · 10 Closing.

**Extras (added per request):** 11 Agenda · 12 Case study · Problem · 13 Case study · Approach · 14 Case study · Before/After · 15 Case study · Metrics · 16 Case study · Learnings · 17 Pull quote · 18 Stat hero.

## Light + Bold rhythm

**Bold is the default.** Every display headline on every slide is Halbfett (Inter Bold stand-in). This matches the live site, where case-study heroes use `font-weight: 700` with tight tracking (-0.02em / -0.03em).

**Light is reserved for numerical counterparts in two-weight pairings.** The big "01" chapter number on slide 02 stays Light against the Bold chapter title. The red "01/02/03" numerals on slides 06, 13, and 16 stay Light against their Bold labels. This creates a deliberate weight contrast within a single composition — not a default for any text element on its own.

Eyebrow labels are **bare typographic** — bold uppercase red with `letter-spacing: 0.04em`, no pill container. This matches the site's `.work-meta-eyebrow` pattern. Pills (`border-radius: 999px`) on the site are reserved for CTAs, toggles, and theme cues — not for eyebrow labels.

## Type — currently Inter, should be Söhne

The file ships with **Inter** as a Söhne stand-in. Reasons:

- The Figma plugin sandbox doesn't have Söhne (it's a paid Klim font), so I couldn't author in it directly.
- SF Pro was attempted first but every text node came out invisible — Figma listed SF Pro as available but the cloud renderer reported `hasMissingFont: true`. Inter renders correctly and has the same humanist-grotesque feel.

To swap to Söhne in your file:

1. Confirm Söhne is installed locally (Font Book → search "Söhne") and the Figma Font Helper is running.
2. Open the file in Figma desktop.
3. Open Local Styles panel (right sidebar → "Show all styles").
4. Edit each of the 16 text styles, change font family from `Inter` to `Söhne`.
   - Style mapping: Light → Leicht, Regular → Buch, Bold → Halbfett, Italic → Buch Kursiv, Bold Italic → Halbfett Kursiv. (Klim uses German weight names by default; if your edition uses Light/Book/Bold, adjust.)
5. All text bound to those styles auto-updates. Any one-off text (a few in the build) you'll catch with Figma's "Replace fonts" dialog when you open the file.

If you'd rather I do this swap programmatically once your local Söhne is fully resolvable to the cloud renderer, let me know — I can run a one-shot script.

## Color tokens — bound to Figma variables

All colors are bound to a local variable collection called **nieder.me — colors** with one mode (Dark). Variables:

- `bg` — `#000000` (slide background)
- `fg` — `#ffffff` (primary text/marks)
- `accent` — `#ff453a` (rule line, eyebrows, accents — used "moderately, one moment per slide" per spec)
- `accent-hover` — `#ff6a60`
- `line` — `rgba(255,255,255,0.2)` (hairline rules)
- `muted` — `#ebebf5` (secondary text)
- `footer-meta` — `#8e8f98` (footer/captions)
- `about-surface` — `#111111` (case-study card surfaces)
- `colophon-surface` — `#121212`

To add a Light mode later: add a mode to the same collection and override the variable values. Every layout will respond. (Not built today since you specified Dark only.)

## Known limitations / things I made judgment calls on

- **Image placeholders** are dark rectangles with a thin stroke and a small "image" label. Drop your real screenshots in by selecting the rectangle → Fill → Image → Choose file.
- **Slide footer** is hand-drawn on each frame (mono mark, hairline, "JOHN NIEDERMEYER · NIEDER.ME", slide-of-total). If you change the wording, change one frame and copy the elements across — they aren't a single shared component (Figma instances don't behave well across so many frames at this scale).
- **Dimensions are 1920×1080** because that's standard for stage decks. If you need 1280×720 (Slides default for some workspaces), I can rescale.
- **The chapter/section header (slide 02)** uses a 320px stat-hero number. If you want a more restrained version, slide 16's numbered learnings shows a smaller take.
- **No light mode** in this build — you specified Dark only. If you want a Light variant later, the variable collection is set up to make it a small lift.

## What's next if you want to keep iterating

Things I'd add as v2 if you wanted to keep going:

1. Actual Söhne swap once the local font resolves.
2. Light mode (add a Light mode to the variable collection, override `bg` to `#ffffff`, `fg` to `#121212`, surface tokens to the warm cream values from `:root[data-theme="light"]` in the site's CSS).
3. A 12-col grid overlay component you can toggle on/off per slide for layout debugging.
4. Real case-study screenshots dropped into slides 04, 07, 14 (you'd point me at the assets you want pulled in).
5. Reusable instances for slide chrome (mono mark, footer) if you'd rather edit the wording in one place.

## Files in this commit

- `docs/2026-05-01-figma-slides-template-handoff.md` — this note.
