#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

if ! command -v npx >/dev/null 2>&1; then
  echo "FAIL: npx is required to run the Playwright mobile shell check."
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
SESSION="mss-$$-$(date +%s)"
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

BASE_URL="http://127.0.0.1:$PORT"

"$PWCLI" -s="$SESSION" open "$BASE_URL/" >/dev/null
sleep 1
"$PWCLI" -s="$SESSION" resize 390 844 >/dev/null

read_state() {
  local path="$1"
  "$PWCLI" -s="$SESSION" goto "$BASE_URL$path" >/dev/null
  "$PWCLI" --raw -s="$SESSION" eval "() => new Promise((resolve) => {
    setTimeout(() => {
      const logo = document.querySelector('.mobile-logo-mark');
      const logoRect = logo?.getBoundingClientRect();
      const logoStyle = logo ? getComputedStyle(logo) : null;
      const workArticle = document.querySelector('.work-article');
      resolve({
        path: window.location.pathname,
        logoTop: logoRect?.top ?? null,
        logoWidth: logoStyle?.width ?? null,
        logoHeight: logoStyle?.height ?? null,
        logoMarginBottom: logoStyle?.marginBottom ?? null,
        maskHeight: workArticle ? getComputedStyle(workArticle, '::before').height : null,
      });
    }, 200);
  })"
}

HOME_STATE="$(read_state "/")"
WORK_STATE="$(read_state "/work/")"
ABOUT_STATE="$(read_state "/about/")"
CASE_STUDY_STATE="$(read_state "/work/resy-discovery/")"

HOME_STATE="$HOME_STATE" \
WORK_STATE="$WORK_STATE" \
ABOUT_STATE="$ABOUT_STATE" \
CASE_STUDY_STATE="$CASE_STUDY_STATE" \
python3 - <<'PY'
import json
import math
import os
import sys

home = json.loads(os.environ["HOME_STATE"])
work = json.loads(os.environ["WORK_STATE"])
about = json.loads(os.environ["ABOUT_STATE"])
case_study = json.loads(os.environ["CASE_STUDY_STATE"])

def fail(message, state):
    print(f"FAIL: {message}")
    print(json.dumps(state, indent=2))
    sys.exit(1)

def assert_matches_home(state, label):
    for key in ("logoWidth", "logoHeight", "logoMarginBottom"):
      if state.get(key) != home.get(key):
          fail(f"{label} should match the homepage mobile logo {key}.", state)

    logo_top = state.get("logoTop")
    home_top = home.get("logoTop")
    if logo_top is None or home_top is None or math.fabs(logo_top - home_top) > 1:
        fail(f"{label} should align the mobile logo vertically with the homepage shell.", state)

assert_matches_home(work, "Work page")
assert_matches_home(about, "About page")
assert_matches_home(case_study, "Case-study page")

if work.get("maskHeight") != "0px":
    fail("Work page mobile shell should not mask the top of the column overlay.", work)

print("mobile subpage shell check passed")
PY
