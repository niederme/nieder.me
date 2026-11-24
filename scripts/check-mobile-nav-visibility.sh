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

assert_visibility() {
  local result
  result="$("$PWCLI" --raw -s="$SESSION" eval "() => {
    const nav = document.querySelector('.mobile-nav');
    const rect = nav.getBoundingClientRect();
    return rect.height >= 44 && Math.abs(rect.bottom - window.innerHeight) <= 1
      && nav.contains(document.elementFromPoint(rect.left + rect.width / 2, rect.top + 24));
  }")"
  if [[ "$result" != "$2" ]]; then
    echo "FAIL: Mobile navigation unexpected visibility $1."
    exit 1
  fi
}

assert_visibility "on load" true
"$PWCLI" -s="$SESSION" eval "() => window.scrollTo({top: 2000, behavior: 'instant'})" >/dev/null
assert_visibility "after scrolling down" false
"$PWCLI" -s="$SESSION" eval "() => window.scrollBy({top: -120, behavior: 'instant'})" >/dev/null
assert_visibility "after scrolling up" true
"$PWCLI" -s="$SESSION" reload >/dev/null
assert_visibility "after reload" true

echo "mobile nav visibility check passed"
