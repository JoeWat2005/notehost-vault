#!/usr/bin/env bash
# Push markdown file(s) to the server.
# For each input <name>.md, writes the response next to your input as
# <name>_notes.md, and stores the same content on the server under <name>.md.
#   bash push.sh foo.md
#   bash push.sh a.md b.md c.md
# Reads NOTES_URL and NOTES_TOKEN from $PWD/.env or this script's directory.

set -euo pipefail

case "${1:-}" in
  -h|--help) sed -n '1,7p' "$0"; exit 0 ;;
  '') echo "usage: bash push.sh <file.md> [file2.md ...]" >&2; exit 2 ;;
esac

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORK_DIR="$(pwd)"

if [ -z "${NOTES_URL:-}" ] || [ -z "${NOTES_TOKEN:-}" ]; then
  if [ -f "$WORK_DIR/.env" ]; then
    . "$WORK_DIR/.env"
  elif [ -f "$SCRIPT_DIR/.env" ]; then
    . "$SCRIPT_DIR/.env"
  fi
fi
: "${NOTES_URL:?NOTES_URL not set; put it in .env (see .env.example)}"
: "${NOTES_TOKEN:?NOTES_TOKEN not set; put it in .env (see .env.example)}"

command -v curl >/dev/null || { echo "curl is required" >&2; exit 1; }

for arg in "$@"; do
  [ -f "$arg" ] || { echo "file not found: $arg" >&2; exit 1; }
done

push_one() {
  local paper="$1"
  local name stem out code
  name="$(basename "$paper")"
  stem="${name%.md}"
  out="$WORK_DIR/${stem}_notes.md"

  code="$(curl -sS -o "$out" -w '%{http_code}' \
    -X POST "$NOTES_URL" \
    -H "Authorization: Bearer $NOTES_TOKEN" \
    -H "Content-Type: text/markdown" \
    -H "X-Note-Name: $name" \
    --data-binary "@$paper")"

  if [ "$code" != "200" ]; then
    echo "FAIL $name (HTTP $code)" >&2
    [ -s "$out" ] && cat "$out" >&2
    rm -f "$out"
    return 1
  fi
  echo "OK   $name -> ${stem}_notes.md  (server copy: $name)"
}

FAILED=0
for p in "$@"; do
  push_one "$p" || FAILED=$((FAILED + 1))
done

exit "$FAILED"
