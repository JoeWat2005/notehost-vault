#!/usr/bin/env bash
# Rename / move a note on the server (overwrites destination if it exists).
#   bash mv.sh old.md new.md
#   bash mv.sh foo.md archive/foo.md
# Reads NOTES_URL and NOTES_TOKEN from $PWD/.env or this script's directory.

set -euo pipefail

case "${1:-}" in
  -h|--help) sed -n '1,6p' "$0"; exit 0 ;;
esac

[ $# -ge 2 ] || { echo "usage: bash mv.sh <from> <to>" >&2; exit 2; }
FROM="$1"
TO="$2"

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

BASE_URL="${NOTES_URL%/process}"

CODE="$(curl -sS -o /dev/null -w '%{http_code}' \
  -X POST \
  -H "Authorization: Bearer $NOTES_TOKEN" \
  -H "X-From: $FROM" \
  -H "X-To: $TO" \
  "$BASE_URL/move")"

case "$CODE" in
  200) echo "moved $FROM -> $TO" ;;
  404) echo "FAIL source not found: $FROM" >&2; exit 1 ;;
  *)   echo "FAIL $FROM -> $TO (HTTP $CODE)" >&2; exit 1 ;;
esac
