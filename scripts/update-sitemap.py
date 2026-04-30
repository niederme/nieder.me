#!/usr/bin/env python3
from __future__ import annotations

import argparse
import html
import sys
import xml.etree.ElementTree as ET
from datetime import datetime, timezone
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_SITE_URL = "https://nieder.me"
EXCLUDED_PREFIXES = (".git/", ".tmp/", ".worktrees/", "drafts/", "node_modules/")
EXCLUDED_FILES = {"resy-ai-demo.html"}


def is_excluded(path: Path) -> bool:
  relative = path.relative_to(ROOT).as_posix()
  return relative in EXCLUDED_FILES or relative.startswith(EXCLUDED_PREFIXES)


def is_redirect(path: Path) -> bool:
  contents = path.read_text(encoding="utf-8")
  return 'http-equiv="refresh"' in contents.lower()


def page_url(path: Path, site_url: str) -> str:
  relative = path.relative_to(ROOT)
  if relative.name != "index.html":
    raise ValueError(f"expected index.html page, got {relative}")

  parent = relative.parent.as_posix()
  base = site_url.rstrip("/")
  if parent == ".":
    return f"{base}/"
  return f"{base}/{parent}/"


def lastmod(path: Path) -> str:
  timestamp = path.stat().st_mtime
  return datetime.fromtimestamp(timestamp, timezone.utc).date().isoformat()


def discover_pages(site_url: str) -> list[tuple[str, str]]:
  pages: list[tuple[str, str]] = []
  for path in sorted(ROOT.rglob("index.html")):
    if is_excluded(path) or is_redirect(path):
      continue
    pages.append((page_url(path, site_url), lastmod(path)))
  return pages


def render_sitemap(pages: list[tuple[str, str]]) -> str:
  lines = [
    '<?xml version="1.0" encoding="UTF-8"?>',
    '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">',
  ]
  for loc, modified in pages:
    lines.extend(
      [
        "  <url>",
        f"    <loc>{html.escape(loc, quote=True)}</loc>",
        f"    <lastmod>{modified}</lastmod>",
        "  </url>",
      ]
    )
  lines.append("</urlset>")
  return "\n".join(lines) + "\n"


def validate_xml(contents: str) -> None:
  ET.fromstring(contents)


def main() -> int:
  parser = argparse.ArgumentParser(description="Generate sitemap.xml from public index.html pages.")
  parser.add_argument("--site-url", default=DEFAULT_SITE_URL)
  parser.add_argument("--check", action="store_true", help="Fail if sitemap.xml is not up to date.")
  args = parser.parse_args()

  sitemap_path = ROOT / "sitemap.xml"
  rendered = render_sitemap(discover_pages(args.site_url))
  validate_xml(rendered)

  if args.check:
    current = sitemap_path.read_text(encoding="utf-8") if sitemap_path.exists() else ""
    if current != rendered:
      print("sitemap.xml is out of date. Run scripts/update-sitemap.py.", file=sys.stderr)
      return 1
    print("sitemap.xml is up to date.")
    return 0

  sitemap_path.write_text(rendered, encoding="utf-8")
  print(f"Wrote {sitemap_path.relative_to(ROOT)}")
  return 0


if __name__ == "__main__":
  raise SystemExit(main())
