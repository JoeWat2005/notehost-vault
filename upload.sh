#!/usr/bin/env bash
# Raw upload to the server (body stored as-is).
#   bash upload.sh foo.md                  # stored as foo.md
#   bash upload.sh local.md remote.md      # stored as remote.md
#   bash upload.sh local.md folder/x.md    # stored under a folder
# Reads NOTES_URL and NOTES_TOKEN from $PWD/.env or this script's directory.

set -euo pipefail

case "${1:-}" in
  -h|--help) sed -n '1,7p' "$0"; exit 0 ;;
  '') echo "usage: bash upload.sh <local-file> [remote-name]" >&2; exit 2 ;;
esac

SRC="$1"
DEST="${2:-$(basename "$SRC")}"

[ -f "$SRC" ] || { echo "not found: $SRC" >&2; exit 1; }

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
  -X PUT \
  -H "Authorization: Bearer $NOTES_TOKEN" \
  -H "Content-Type: text/markdown" \
  --data-binary "@$SRC" \
  "$BASE_URL/notes/$DEST")"

if [ "$CODE" = "200" ]; then
  echo "uploaded $SRC -> $DEST"
else
  echo "FAIL $SRC -> $DEST (HTTP $CODE)" >&2
  exit 1
fi
