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

missing = [
    str(path.relative_to(ROOT))
    for path in PUBLIC_PAGES + COLOPHON_ICONS
    if not path.exists()
]
if not missing:
    print("expected missing files before implementation")
    sys.exit(1)

print("missing expected pre-implementation files:")
for item in missing:
    print(f"- {item}")
sys.exit(1)
