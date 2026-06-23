#!/usr/bin/env python3
"""Sync design-system/design-tokens.json with the :root tokens in styles.css.

The colors and grid metrics are the values that actually drift, because they live
as CSS custom properties in assets/css/styles.css. This script reads the default
(dark) :root block and the :root[data-theme="light"] override block, then updates
the matching entries in design-tokens.json — leaving the curated type / spacing /
radii sections (which are not tokenized in the CSS) untouched.

Usage:
  python3 scripts/extract-design-tokens.py            # rewrite the JSON in place
  python3 scripts/extract-design-tokens.py --check     # exit 1 if the JSON is stale
"""
from __future__ import annotations

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CSS = ROOT / "assets" / "css" / "styles.css"
TOKENS = ROOT / "design-system" / "design-tokens.json"

# CSS custom property  ->  dotted path inside design-tokens.json
COLOR_MAP = {
    "--bg": "color.bg",
    "--fg": "color.fg",
    "--accent": "color.accent",
    "--accent-hover": "color.accentHover",
    "--line": "color.line",
    "--muted": "color.muted",
    "--footer-meta": "color.footerMeta",
    "--about-surface": "color.surfaceAbout",
    "--colophon-surface": "color.surfaceColophon",
    "--focus-ring": "color.focusRing",
    "--focus-shadow": "color.focusShadow",
}
GRID_MAP = {
    "--grid-cols": ("grid.columns", "number"),
    "--grid-col-width": ("grid.columnWidth", "dimension"),
    "--grid-gutter": ("grid.gutter", "dimension"),
    "--grid-width": ("grid.maxWidth", "dimension"),
}


def normalize(value: str) -> str:
    """Match the JSON's whitespace convention (no spaces inside rgba())."""
    value = value.strip()
    if value.startswith("rgba") or value.startswith("rgb"):
        return re.sub(r"\s+", "", value)
    return value


def parse_root_block(css: str, selector: str) -> dict[str, str]:
    """Return {custom-property: value} for the first matching selector block."""
    pattern = re.escape(selector) + r"\s*\{(.*?)\}"
    match = re.search(pattern, css, re.DOTALL)
    if not match:
        raise SystemExit(f"Could not find `{selector}` block in {CSS}")
    body = match.group(1)
    out: dict[str, str] = {}
    for prop, value in re.findall(r"(--[\w-]+)\s*:\s*([^;]+);", body):
        out[prop] = normalize(value)
    return out


def set_path(tokens: dict, dotted: str, key: str, value):
    node = tokens
    for part in dotted.split("."):
        node = node[part]
    node[key] = value


def build(tokens: dict) -> dict:
    css = CSS.read_text()
    dark = parse_root_block(css, ":root")
    light = parse_root_block(css, ':root[data-theme="light"]')

    for prop, dotted in COLOR_MAP.items():
        if prop in dark:
            set_path(tokens, dotted, "$value", dark[prop])
        # Only attach a light override when the light block actually redefines it.
        node = tokens
        for part in dotted.split("."):
            node = node[part]
        if prop in light and light[prop] != dark.get(prop):
            node.setdefault("$extensions", {}).setdefault("theme", {})["light"] = light[prop]
        elif "$extensions" in node:
            node["$extensions"].get("theme", {}).pop("light", None)
            if not node["$extensions"].get("theme"):
                node["$extensions"].pop("theme", None)
            if not node["$extensions"]:
                node.pop("$extensions", None)

    for prop, (dotted, kind) in GRID_MAP.items():
        if prop not in dark:
            continue
        raw = dark[prop]
        set_path(tokens, dotted, "$value", int(raw) if kind == "number" else raw)

    return tokens


def main() -> int:
    check = "--check" in sys.argv[1:]
    current = TOKENS.read_text()
    tokens = json.loads(current)
    build(tokens)
    rendered = json.dumps(tokens, indent=2) + "\n"

    if check:
        if rendered != current:
            print("design-tokens.json is stale — run: make design-tokens", file=sys.stderr)
            return 1
        print("design-tokens.json is in sync with styles.css")
        return 0

    TOKENS.write_text(rendered)
    print(f"Wrote {TOKENS.relative_to(ROOT)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
