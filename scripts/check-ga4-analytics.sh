#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

expect_file() {
  local path="$1"
  [[ -f "$path" ]] || fail "Expected file '$path' to exist."
}

expect_pattern() {
  local path="$1"
  local pattern="$2"
  local message="$3"
  grep -Fq -- "$pattern" "$path" || fail "$message"
}

expect_no_pattern() {
  local path="$1"
  local pattern="$2"
  local message="$3"
  if grep -Fq -- "$pattern" "$path"; then
    fail "$message"
  fi
}

expect_theme_bootstrap_before_ga() {
  local path="$1"
  python3 - "$path" <<'PY'
from pathlib import Path
import sys

path = Path(sys.argv[1])
contents = path.read_text()

theme_token = 'const storedTheme = window.localStorage.getItem("nieder.theme");'
ga_token = 'window.dataLayer = window.dataLayer || [];'

theme_index = contents.find(theme_token)
ga_index = contents.find(ga_token)

if theme_index == -1:
    print(f"FAIL: Expected {path} to include the theme/grid bootstrap token.", file=sys.stderr)
    sys.exit(1)

if ga_index == -1:
    print(f"FAIL: Expected {path} to include the GA bootstrap token.", file=sys.stderr)
    sys.exit(1)

if theme_index > ga_index:
    print(
        f"FAIL: Expected {path} to keep the theme/grid bootstrap before the GA snippet.",
        file=sys.stderr,
    )
    sys.exit(1)
PY
}

tagged_pages=(
  "index.html"
  "about/index.html"
  "accessibility/index.html"
  "colophon-style-guide/index.html"
  "privacy/index.html"
  "work/index.html"
  "work/resy-discovery/index.html"
  "work/resy-search-ai/index.html"
  "work/ai-quota/index.html"
  "work/sendmoi/index.html"
)

excluded_pages=(
  "resy-ai-demo.html"
)

for page in "${tagged_pages[@]}"; do
  expect_file "$page"
  expect_pattern "$page" "https://www.googletagmanager.com" \
    "Expected '$page' to include the Google Tag Manager origin."
  expect_pattern "$page" "G-DEFM9FZ25D" \
    "Expected '$page' to include measurement ID G-DEFM9FZ25D."
  expect_pattern "$page" "window.dataLayer = window.dataLayer || [];" \
    "Expected '$page' to initialize the GA dataLayer."
  expect_pattern "$page" 'window.gtag("config", "G-DEFM9FZ25D");' \
    "Expected '$page' to configure GA4 with the measurement ID."
  expect_pattern "$page" "const isLocalPreview =" \
    "Expected '$page' to suppress GA4 on local preview hosts."
  expect_pattern "$page" 'hostname.endsWith(".local")' \
    "Expected '$page' to suppress GA4 on .local preview hosts."
  expect_pattern "$page" 'pathname.startsWith("/drafts/")' \
    "Expected '$page' to suppress GA4 on draft paths."
  expect_pattern "$page" "window.niederAnalyticsSuppressed = true;" \
    "Expected '$page' to mark suppressed analytics contexts."
  expect_theme_bootstrap_before_ga "$page"
done

for page in "${excluded_pages[@]}"; do
  expect_file "$page"
  expect_no_pattern "$page" "G-DEFM9FZ25D" \
    "Expected '$page' to stay out of the GA4 rollout."
done

expect_pattern "privacy/index.html" "Google Analytics" \
  "Expected privacy/index.html to disclose Google Analytics."
expect_no_pattern "privacy/index.html" "does not currently use advertising, analytics" \
  "Expected privacy/index.html to remove the outdated no-analytics claim."

expect_pattern "scripts/ga4-weekly-report.py" 'field_name="hostName"' \
  "Expected the weekly GA4 report to filter by production hostname."
expect_pattern "scripts/ga4-weekly-report.py" 'value=r"^(www\.)?nieder\.me$"' \
  "Expected the weekly GA4 report to include only nieder.me production hosts."
expect_pattern "scripts/ga4-weekly-report.py" "dimension_filter=PRODUCTION_HOST_FILTER" \
  "Expected every weekly GA4 query to use the production hostname filter."

echo "GA4 analytics checks passed."
