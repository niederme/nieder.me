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
  grep -q -- "$pattern" "$path" || fail "$message"
}

expect_no_pattern() {
  local path="$1"
  local pattern="$2"
  local message="$3"
  if grep -q -- "$pattern" "$path"; then
    fail "$message"
  fi
}

expect_multiline_pattern() {
  local path="$1"
  local pattern="$2"
  local message="$3"
  python3 - "$path" "$pattern" "$message" <<'PY'
from pathlib import Path
import re
import sys

path = Path(sys.argv[1])
pattern = sys.argv[2]
message = sys.argv[3]
contents = path.read_text()
if not re.search(pattern, contents, re.DOTALL):
    print(f"FAIL: {message}", file=sys.stderr)
    sys.exit(1)
PY
}

expect_file "accessibility/index.html"
expect_file "privacy/index.html"
expect_file "assets/css/work-case-study.css"

policy_pages=(
  "accessibility/index.html"
  "privacy/index.html"
)

home_pages=(
  "index.html"
)

one_level_pages=(
  "about/index.html"
  "colophon/index.html"
  "work/index.html"
  "styleguide/index.html"
  "accessibility/index.html"
  "privacy/index.html"
)

two_level_pages=(
  "work/resy-discovery/index.html"
  "work/sendmoi/index.html"
  "work/somm-ai/index.html"
  "work/ai-quota/index.html"
)

for page in "${home_pages[@]}"; do
  expect_pattern "$page" "site-footer-utility-links" "Expected footer utility links in '$page'."
  expect_pattern "$page" 'href="accessibility/"' "Expected '$page' to link to accessibility/."
  expect_pattern "$page" 'href="privacy/"' "Expected '$page' to link to privacy/."
done

for page in "${one_level_pages[@]}"; do
  expect_pattern "$page" "site-footer-utility-links" "Expected footer utility links in '$page'."
  expect_pattern "$page" 'href="../accessibility/"' "Expected '$page' to link to ../accessibility/."
  expect_pattern "$page" 'href="../privacy/"' "Expected '$page' to link to ../privacy/."
done

for page in "${two_level_pages[@]}"; do
  expect_pattern "$page" "site-footer-utility-links" "Expected footer utility links in '$page'."
  expect_pattern "$page" 'href="../../accessibility/"' "Expected '$page' to link to ../../accessibility/."
  expect_pattern "$page" 'href="../../privacy/"' "Expected '$page' to link to ../../privacy/."
done

for page in "${policy_pages[@]}"; do
  expect_pattern "$page" 'class="[^"]*policy-page' "Expected '$page' to opt into the policy-page layout."
  expect_pattern "$page" 'work-article-meta case-study-block case-study-block-meta' \
    "Expected '$page' to use the case-study-style metadata rail."
  expect_pattern "$page" 'case-study-block-inner' \
    "Expected '$page' to wrap policy metadata in the case-study inner container."
done

expect_pattern "assets/css/work-case-study.css" '.policy-page .work-article-meta {' \
  "Expected policy pages to scope the narrower metadata rail in work-case-study.css."
expect_pattern "assets/css/work-case-study.css" '.policy-page .work-article-grid {' \
  "Expected policy pages to add the case-study-style top rule and spacing in work-case-study.css."
expect_pattern "assets/css/work-case-study.css" '.policy-page .work-article-body {' \
  "Expected policy pages to scope the matching article-body alignment in work-case-study.css."
expect_pattern "assets/css/work-case-study.css" '--case-study-sidecar-width:' \
  "Expected work-case-study.css to define the shared responsive sidecar width."
expect_multiline_pattern "assets/css/work-case-study.css" \
  '\.policy-page \.work-article-grid \{[^}]*margin-top: 38px;[^}]*padding-top: 50px;[^}]*border-top: 1px solid var\(--line\);' \
  "Expected policy pages to keep extra space above the ruled content row."
expect_multiline_pattern "assets/css/work-case-study.css" \
  '\.policy-page \.work-article-meta \{[^}]*width: var\(--case-study-sidecar-width\);' \
  "Expected policy pages to size the left metadata rail from the shared responsive sidecar width."
expect_multiline_pattern "assets/css/work-case-study.css" \
  '@media \(min-width: 960px\) and \(max-width: 1500px\) \{[\s\S]*?\.work-article \{[\s\S]*?--case-study-support-width: calc\(\(4 \* var\(--case-study-column-width\)\) \+ \(3 \* var\(--grid-gutter\)\)\);[\s\S]*?--case-study-sidecar-width: var\(--case-study-support-width\);[\s\S]*?--case-study-body-offset: calc\(\(4 \* var\(--case-study-column-width\)\) \+ \(4 \* var\(--grid-gutter\)\)\);' \
  "Expected narrower desktop widths to widen the shared support rail and full-width offset to a 4-column grid track."
expect_multiline_pattern "assets/css/work-case-study.css" \
  '@media \(min-width: 960px\) and \(max-width: 1500px\) \{[\s\S]*?\.policy-page \.work-article-meta,[\s\S]*?\.case-study-page \.work-article-meta \{[\s\S]*?grid-column: 1 / span 4;' \
  "Expected narrower desktop widths to place the metadata rail on a 4-column grid slot."
expect_multiline_pattern "assets/css/work-case-study.css" \
  '@media \(min-width: 960px\) and \(max-width: 1500px\) \{[\s\S]*?\.policy-page \.work-article-body,[\s\S]*?\.case-study-page \.work-article-body \{[\s\S]*?grid-column: 5 / span 6;' \
  "Expected narrower desktop widths to push the article body over one column with the wider support rail."
expect_multiline_pattern "assets/css/work-case-study.css" \
  '\.logo-link,\s*\.mobile-logo-link \{[^}]*cursor: pointer;' \
  "Expected clickable logo links to advertise interactivity with a pointer cursor."
expect_multiline_pattern "assets/css/work-case-study.css" \
  '\.logo-link \{[^}]*position: fixed;[^}]*width: 93\.832px;[^}]*height: 93\.832px;' \
  "Expected the desktop logo link to own the fixed clickable hit area."
expect_multiline_pattern "assets/css/work-case-study.css" \
  '\.logo-mark \{[^}]*cursor: pointer;[^}]*pointer-events: auto;' \
  "Expected the visible desktop logo mark itself to remain an active hover target."
expect_pattern "assets/css/work-case-study.css" '.logo-link:hover .logo-mark' \
  "Expected the logo link to provide a visible hover cue."
expect_no_pattern "assets/css/work-case-study.css" 'site-footer-utility-separator' \
  "Expected footer utility links to use spacing instead of a slash separator style."

for page in "${home_pages[@]}" "${one_level_pages[@]}" "${two_level_pages[@]}"; do
  expect_no_pattern "$page" 'site-footer-utility-separator' \
    "Expected '$page' footer utility links to omit the slash separator."
done

echo "Policy pages and footer utility links look good."
