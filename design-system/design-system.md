# nieder.me — Design System

A portable spec for agentic design tools (Claude Design, Figma Make, v0, Lovable, Cursor, etc.).
Values are extracted from the production CSS in `assets/css/styles.css` and the living style
guide at `/colophon-style-guide/`. Machine-readable tokens live alongside this file in
`design-tokens.json` (W3C Design Tokens format).

## Principles

- Editorial, typography-led. Large display type sets the tone before the copy does.
- Dark by default; light theme is a first-class peer (`:root[data-theme="light"]`).
- A single accent red carries all emphasis and interaction.
- 12-column grid, generous gutters, measured line length for body copy.

## Color

Defined as CSS custom properties, themed for dark (default) and light.

| Token | Dark (default) | Light |
| --- | --- | --- |
| `--bg` | `#000000` | `#ffffff` |
| `--fg` | `#ffffff` | `#121212` |
| `--accent` | `#ff453a` | `#ff453a` (unchanged) |
| `--accent-hover` | `#ff6a60` | `#ff6a60` |
| `--line` (hairlines) | `rgba(255,255,255,0.2)` | `#d6d0c6` |
| `--muted` (secondary text) | `#ebebf5` | `#474a51` |
| `--footer-meta` / `--footer-heading` | `#8e8f98` | `#5f6268` |
| `--about-surface` | `#111111` | `#f3eee5` |
| `--colophon-surface` | `#121212` | `#f5efe5` |

Focus: `--focus-ring: rgba(255,69,58,0.75)`, `--focus-shadow: rgba(255,69,58,0.25)`.

## Typography

**Family:** Söhne (self-hosted woff2), with system fallback:
`"Sohne", "SF Pro Text", "SF Pro Display", -apple-system, BlinkMacSystemFont, "Helvetica Neue", "Arial Nova", "Arial", sans-serif`

**Weights:** 300 (leicht) · 400 (buch) · 700 (halbfett) — each with a true italic.

**Scale** (fluid via `clamp(min, vw, max)`):

| Role | Size | Weight | Line height | Notes |
| --- | --- | --- | --- | --- |
| Mega numeral / job display | `clamp(64px, 10vw, 196px)` | 300 | 0.9 | `letter-spacing: -0.02em`, optical outdent |
| Hero display (h1/h2) | `clamp(52px, 7.7vw, 120px)` | 700 | 0.9 | accent color on the second line |
| Section display | `clamp(112px, 7.9vw, 152px)` / `clamp(48px, 16vw, 84px)` | 300–700 | ~0.9–1.0 | |
| Headings | 48 / 42 / 30 / 26 / 24px | 700 | tight | |
| Body | 16–18px (up to 24px lead) | 300–400 | 1.35 | measured width |
| Meta / eyebrow / caption | 13px | 400 | — | spaced caps, lower contrast |
| Microcopy | 10–12px | 400 | — | |

## Layout grid

| Token | Value |
| --- | --- |
| `--grid-cols` | 12 |
| `--grid-col-width` | 69px |
| `--grid-gutter` | 40px |
| `--grid-width` (max) | 1268px |

## Spacing scale

Step values observed across gaps/margins: `5, 8, 10, 12, 15, 20, 24, 28, 40` (px).
`40px` is the grid gutter (`--grid-gutter`) and the primary layout rhythm unit.

## Radii

| Use | Value |
| --- | --- |
| Square / rules | `0` |
| Subtle | `5px`, `10px`, `14px`, `16px` |
| Pill / capsule | `999px`, `50px` |
| Circle | `50%` |

## Interaction

- Links/buttons emphasize with `--accent` → `--accent-hover` on hover.
- Visible focus ring using `--focus-ring` (red, 0.75 alpha).
- Theme toggle swaps the `data-theme` attribute on `:root`; all tokens re-resolve.

## Source of truth

- Tokens & component CSS: `assets/css/styles.css`, `assets/css/styleguide.css`, `assets/css/work-case-study.css`
- Live specimen page: `colophon-style-guide/index.html`
- Fonts: `assets/fonts/soehne-*.woff2`
