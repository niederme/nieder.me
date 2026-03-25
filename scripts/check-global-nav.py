#!/usr/bin/env python3
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
PUBLIC_PAGES = [
    ROOT / "index.html",
    ROOT / "about" / "index.html",
    ROOT / "colophon" / "index.html",
    ROOT / "work" / "index.html",
    ROOT / "work" / "resy-discovery" / "index.html",
    ROOT / "work" / "sendmoi" / "index.html",
    ROOT / "work" / "somm-ai" / "index.html",
    ROOT / "work" / "ai-quota" / "index.html",
]
COLOPHON_ICONS = [
    ROOT / "assets" / "icons" / "side-nav" / "icon-colophon-off.svg",
    ROOT / "assets" / "icons" / "side-nav" / "icon-colophon-on.svg",
    ROOT / "assets" / "icons" / "side-nav" / "icon-colophon-hover.svg",
]
EXPECTED_CLASS = 'class="global-nav'
LEGACY_TOKENS = [
    "case-nav",
    "case-anchor",
    "work-side-nav",
    "work-case-anchor",
    "data-lock-start",
]
REQUIRED_BOOTSTRAP_TOKENS = [
    "nieder.theme",
    "nieder.cols-grid-visible",
    "document.documentElement.dataset.grid",
]
REQUIRED_FILE_TOKENS = {
    ROOT / "assets" / "js" / "main.js": [
        '.global-nav-anchor[href="#top"]',
        'const COLS_TOGGLE_STORAGE_KEY = "nieder.cols-grid-visible";',
        'let isVisible = false;',
        'document.documentElement.dataset.grid = visible ? "visible" : "hidden";',
        'const homeRailNav = document.querySelector(".global-nav-home");',
        'homeRailNav.classList.toggle("is-locked", shouldLock);',
    ],
    ROOT / "assets" / "css" / "styles.css": [
        ':root[data-grid="hidden"] .grid-overlay',
        "--nav-popover-bg:",
        "--nav-popover-fg:",
    ],
    ROOT / "assets" / "css" / "work-case-study.css": [
        ':root[data-grid="hidden"] .work-grid-overlay',
        "--nav-popover-bg:",
        "--nav-popover-fg:",
    ],
}

missing_icons = [path for path in COLOPHON_ICONS if not path.exists()]
if missing_icons:
    print("missing required icon assets:")
    for path in missing_icons:
        print(f"- {path.relative_to(ROOT)}")
    sys.exit(1)

existing_pages = [path for path in PUBLIC_PAGES if path.exists()]
if not existing_pages:
    print("no public pages found to verify")
    sys.exit(1)

for page in existing_pages:
    html = page.read_text()
    if EXPECTED_CLASS not in html:
        print(f"missing global nav in {page.relative_to(ROOT)}")
        sys.exit(1)
    for token in LEGACY_TOKENS:
        if token in html:
            print(f"legacy nav token {token!r} still present in {page.relative_to(ROOT)}")
            sys.exit(1)
    for token in REQUIRED_BOOTSTRAP_TOKENS:
        if token not in html:
            print(f"missing bootstrap token {token!r} in {page.relative_to(ROOT)}")
            sys.exit(1)

for path, tokens in REQUIRED_FILE_TOKENS.items():
    contents = path.read_text()
    for token in tokens:
        if token not in contents:
            print(f"missing expected token {token!r} in {path.relative_to(ROOT)}")
            sys.exit(1)

print("global nav verifier passed")
