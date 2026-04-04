#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

if ! command -v npx >/dev/null 2>&1; then
  echo "FAIL: npx is required to run the Playwright mobile-nav check."
  exit 1
fi

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
PWCLI="$CODEX_HOME/skills/playwright/scripts/playwright_cli.sh"

if [ ! -x "$PWCLI" ]; then
  echo "FAIL: missing Playwright wrapper at $PWCLI"
  exit 1
fi

PORT="$(
  python3 - <<'PY'
import socket

sock = socket.socket()
sock.bind(("127.0.0.1", 0))
print(sock.getsockname()[1])
sock.close()
PY
)"

SERVER_LOG="$(mktemp)"
SESSION="mnv-$$-$(date +%s)"
SERVER_PID=""

cleanup() {
  if [ -n "$SERVER_PID" ] && kill -0 "$SERVER_PID" >/dev/null 2>&1; then
    kill "$SERVER_PID" >/dev/null 2>&1 || true
    wait "$SERVER_PID" >/dev/null 2>&1 || true
  fi
  "$PWCLI" -s="$SESSION" close >/dev/null 2>&1 || true
  rm -f "$SERVER_LOG"
}

trap cleanup EXIT

python3 -m http.server "$PORT" --bind 127.0.0.1 >"$SERVER_LOG" 2>&1 &
SERVER_PID="$!"
sleep 1

URL="http://127.0.0.1:$PORT/"

"$PWCLI" -s="$SESSION" open "$URL" >/dev/null
sleep 1
"$PWCLI" -s="$SESSION" resize 390 844 >/dev/null

read_state() {
  "$PWCLI" --raw -s="$SESSION" eval "() => new Promise((resolve) => {
    setTimeout(() => {
      const nav = document.querySelector('.mobile-nav');
      const sentinel = document.querySelector('.mobile-nav-sentinel');
      const rect = sentinel?.getBoundingClientRect();
      resolve({
        scrollY: window.scrollY,
        navClass: nav?.className ?? '',
        sentinelTop: rect?.top ?? null,
        transform: nav ? getComputedStyle(nav).transform : null,
      });
    }, 200);
  })"
}

assert_state() {
  local state_json="$1"
  local label="$2"
  local expected="$3"

  STATE_JSON="$state_json" python3 - "$label" "$expected" <<'PY'
import json
import math
import os
import sys

label = sys.argv[1]
expected = sys.argv[2]
state = json.loads(os.environ["STATE_JSON"])

nav_class = state.get("navClass", "")
sentinel_top = state.get("sentinelTop")
scroll_y = state.get("scrollY")

if expected == "hidden":
    ok = (
        sentinel_top is not None
        and sentinel_top > 0
        and "is-visible" not in nav_class
    )
    if not ok:
        print(f"FAIL: {label} should keep the mobile nav hidden above the sentinel.")
        print(json.dumps(state, indent=2))
        sys.exit(1)
elif expected == "visible":
    ok = (
        sentinel_top is not None
        and sentinel_top <= 0
        and "is-visible" in nav_class
    )
    if not ok:
        print(f"FAIL: {label} should show the mobile nav once the sentinel has crossed the viewport.")
        print(json.dumps(state, indent=2))
        sys.exit(1)
else:
    print(f"FAIL: unknown expectation {expected!r}")
    sys.exit(1)

if scroll_y is None or math.isnan(scroll_y):
    print(f"FAIL: {label} should report a numeric scroll position.")
    print(json.dumps(state, indent=2))
    sys.exit(1)
PY
}

initial_state="$(read_state)"
assert_state "$initial_state" "Initial mobile viewport" "hidden"

"$PWCLI" -s="$SESSION" eval "() => { window.scrollTo(0, 2000); return window.scrollY; }" >/dev/null
scrolled_state="$(read_state)"
assert_state "$scrolled_state" "Scrolled homepage state" "visible"

"$PWCLI" -s="$SESSION" reload >/dev/null
reloaded_state="$(read_state)"
assert_state "$reloaded_state" "Reloaded scrolled homepage state" "visible"

echo "mobile nav visibility check passed"
