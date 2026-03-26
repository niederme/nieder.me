#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

STYLESHEET="assets/css/styles.css"

reject_pattern() {
  local file="$1"
  local pattern="$2"
  local message="$3"

  if rg -q -U "$pattern" "$file"; then
    echo "FAIL: $message"
    exit 1
  fi
}

reject_pattern "$STYLESHEET" "@media \\(min-width: 521px\\) and \\(max-width: 959px\\) \\{[[:space:][:print:]]*body \\{[[:space:][:print:]]*touch-action: pan-y;" "Homepage tablet body rules should not force pan-y touch handling."
reject_pattern "$STYLESHEET" "@media \\(max-width: 520px\\) \\{[[:space:][:print:]]*body \\{[[:space:][:print:]]*touch-action: pan-y;" "Homepage mobile body rules should not force pan-y touch handling."

echo "Homepage mobile scroll audit passed."
