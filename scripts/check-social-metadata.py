#!/usr/bin/env python3
from __future__ import annotations

import re
import struct
import sys
from pathlib import Path
from urllib.parse import urlparse


ROOT = Path(__file__).resolve().parents[1]
SITE_URL = "https://nieder.me"
EXCLUDED_PREFIXES = (".git/", ".tmp/", ".worktrees/", "drafts/", "node_modules/", "work/resy-web-booking/prototype/")

REQUIRED_OG = (
  "og:type",
  "og:locale",
  "og:title",
  "og:description",
  "og:url",
  "og:site_name",
  "og:image",
  "og:image:secure_url",
  "og:image:type",
  "og:image:width",
  "og:image:height",
  "og:image:alt",
)

REQUIRED_TWITTER = (
  "twitter:card",
  "twitter:title",
  "twitter:description",
  "twitter:url",
  "twitter:image",
  "twitter:image:alt",
)


def is_excluded(path: Path) -> bool:
  relative = path.relative_to(ROOT).as_posix()
  return relative.startswith(EXCLUDED_PREFIXES)


def attrs_for(tag: str) -> dict[str, str]:
  return {
    match.group(1): match.group(2)
    for match in re.finditer(r'([\w:-]+)="([^"]*)"', tag)
  }


def meta_maps(contents: str) -> tuple[dict[str, str], dict[str, str]]:
  og: dict[str, str] = {}
  twitter: dict[str, str] = {}
  for match in re.finditer(r"<meta\s+[^>]*>", contents):
    attrs = attrs_for(match.group(0))
    if "property" in attrs and attrs["property"].startswith("og:"):
      og[attrs["property"]] = attrs.get("content", "")
    if "name" in attrs and attrs["name"].startswith("twitter:"):
      twitter[attrs["name"]] = attrs.get("content", "")
  return og, twitter


def canonical_url(contents: str) -> str:
  match = re.search(r'<link\s+[^>]*rel="canonical"[^>]*>', contents)
  if not match:
    return ""
  return attrs_for(match.group(0)).get("href", "")


def image_dimensions(path: Path) -> tuple[int, int]:
  data = path.read_bytes()
  if data.startswith(b"\x89PNG\r\n\x1a\n"):
    return struct.unpack(">II", data[16:24])

  if data.startswith(b"\xff\xd8"):
    index = 2
    while index < len(data):
      if data[index] != 0xFF:
        index += 1
        continue
      marker = data[index + 1]
      index += 2
      if marker in (0xD8, 0xD9):
        continue
      length = struct.unpack(">H", data[index:index + 2])[0]
      if marker in range(0xC0, 0xC4) or marker in range(0xC5, 0xC8) or marker in range(0xC9, 0xCC) or marker in range(0xCD, 0xD0):
        height, width = struct.unpack(">HH", data[index + 3:index + 7])
        return width, height
      index += length

  raise ValueError(f"unsupported image format: {path.relative_to(ROOT)}")


def local_image_path(url: str) -> Path | None:
  parsed = urlparse(url)
  if parsed.scheme != "https" or parsed.netloc != "nieder.me":
    return None
  relative = parsed.path.lstrip("/")
  if relative.startswith("2026/"):
    relative = relative[len("2026/"):]
  return ROOT / relative


def check_page(path: Path) -> list[str]:
  relative = path.relative_to(ROOT).as_posix()
  contents = path.read_text(encoding="utf-8")
  failures: list[str] = []

  if not re.search(r"<title>[^<]+</title>", contents):
    failures.append("missing <title>")

  if not re.search(r'<meta\s+name="description"\s+content="[^"]+"\s*/?>', contents):
    failures.append("missing meta description")

  canonical = canonical_url(contents)
  if not canonical:
    failures.append("missing canonical URL")
  elif not canonical.startswith(f"{SITE_URL}/"):
    failures.append(f"canonical URL must be absolute on {SITE_URL}: {canonical}")

  og, twitter = meta_maps(contents)
  for key in REQUIRED_OG:
    if not og.get(key):
      failures.append(f"missing {key}")
  for key in REQUIRED_TWITTER:
    if not twitter.get(key):
      failures.append(f"missing {key}")

  if failures:
    return [f"{relative}: {failure}" for failure in failures]

  if og["og:image"] != og["og:image:secure_url"]:
    failures.append("og:image and og:image:secure_url must match")
  if og["og:image"] != twitter["twitter:image"]:
    failures.append("og:image and twitter:image must match")
  if og["og:url"] != twitter["twitter:url"]:
    failures.append("og:url and twitter:url must match")
  if twitter["twitter:card"] != "summary_large_image":
    failures.append("twitter:card must be summary_large_image")

  image_path = local_image_path(og["og:image"])
  if image_path is None:
    failures.append(f"social image must be hosted on nieder.me: {og['og:image']}")
  elif not image_path.is_file():
    failures.append(f"social image file is missing: {image_path.relative_to(ROOT)}")
  else:
    width, height = image_dimensions(image_path)
    if int(og["og:image:width"]) != width or int(og["og:image:height"]) != height:
      failures.append(
        f"social image dimensions should be {width}x{height}, got "
        f"{og['og:image:width']}x{og['og:image:height']}"
      )

  expected_type = "image/png" if og["og:image"].endswith(".png") else "image/jpeg"
  if og["og:image:type"] != expected_type:
    failures.append(f"og:image:type should be {expected_type}")

  return [f"{relative}: {failure}" for failure in failures]


def main() -> int:
  failures: list[str] = []
  for path in sorted(ROOT.rglob("*.html")):
    if is_excluded(path):
      continue
    failures.extend(check_page(path))

  if failures:
    for failure in failures:
      print(f"FAIL: {failure}", file=sys.stderr)
    return 1

  print("social metadata checks passed")
  return 0


if __name__ == "__main__":
  raise SystemExit(main())
