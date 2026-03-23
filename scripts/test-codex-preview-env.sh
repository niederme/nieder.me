#!/usr/bin/env bash
set -euo pipefail

HELPER="${CODEX_PREVIEW_ENV_BIN:-$HOME/.codex/bin/codex-preview-env}"

if [[ ! -x "$HELPER" ]]; then
  echo "Missing executable helper: $HELPER" >&2
  exit 1
fi

tmpdir="$(mktemp -d "${TMPDIR:-/tmp}/codex-preview-test.XXXXXX")"
cleanup() {
  if [[ -n "${busy_pid:-}" ]]; then
    kill "$busy_pid" >/dev/null 2>&1 || true
    wait "$busy_pid" 2>/dev/null || true
  fi
  rm -rf "$tmpdir"
}
trap cleanup EXIT

assert_contains() {
  local haystack="$1"
  local needle="$2"
  if [[ "$haystack" != *"$needle"* ]]; then
    echo "Expected output to contain: $needle" >&2
    echo "--- output ---" >&2
    echo "$haystack" >&2
    exit 1
  fi
}

pick_port() {
  python3 - <<'PY'
import socket
s = socket.socket()
s.bind(("127.0.0.1", 0))
print(s.getsockname()[1])
s.close()
PY
}

run_test_local_only_output() {
  local port output
  port="$(pick_port)"
  output="$("$HELPER" --port "$port" --scan-limit 2 --local-host testbox.local --local-only)"
  assert_contains "$output" "PORT_REQUESTED=$port"
  assert_contains "$output" "PORT_TO_USE=$port"
  assert_contains "$output" "LOCAL_URL_HOST=testbox.local"
  assert_contains "$output" "LOCAL_URL=http://testbox.local:$port"
  assert_contains "$output" "LAN_URL=http://testbox.local:$port"
}

run_test_port_bumps() {
  local port output
  port="$(pick_port)"
  python3 -m http.server "$port" --bind 127.0.0.1 >/dev/null 2>&1 &
  busy_pid=$!
  sleep 0.4

  output="$("$HELPER" --port "$port" --scan-limit 2 --local-host testbox.local --local-only)"
  assert_contains "$output" "PORT_REQUESTED=$port"
  assert_contains "$output" "PORT_TO_USE=$((port + 1))"
  assert_contains "$output" "PORT_WAS_BUSY=1"

  kill "$busy_pid" >/dev/null 2>&1 || true
  wait "$busy_pid" 2>/dev/null || true
  busy_pid=""
}

run_test_port_auto_disabled() {
  local port stderr_file
  port="$(pick_port)"
  stderr_file="$tmpdir/stderr.txt"
  python3 -m http.server "$port" --bind 127.0.0.1 >/dev/null 2>&1 &
  busy_pid=$!
  sleep 0.4

  if "$HELPER" --port "$port" --no-port-auto --local-host testbox.local --local-only >"$tmpdir/stdout.txt" 2>"$stderr_file"; then
    echo "Expected helper to fail when port auto selection is disabled." >&2
    exit 1
  fi
  assert_contains "$(cat "$stderr_file")" "Port $port is already in use."

  kill "$busy_pid" >/dev/null 2>&1 || true
  wait "$busy_pid" 2>/dev/null || true
  busy_pid=""
}

run_test_local_only_output
run_test_port_bumps
run_test_port_auto_disabled

echo "All codex-preview-env tests passed."
