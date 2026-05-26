#!/usr/bin/env bash
# Delete a note from the server.
#   bash rm.sh foo.md
#   bash rm.sh folder/foo.md
# Reads NOTES_URL and NOTES_TOKEN from $PWD/.env or this script's directory.

set -euo pipefail

case "${1:-}" in
  -h|--help) sed -n '1,6p' "$0"; exit 0 ;;
  '') echo "usage: bash rm.sh <name>" >&2; exit 2 ;;
esac

NAME="$1"
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
  -X DELETE \
  -H "Authorization: Bearer $NOTES_TOKEN" \
  "$BASE_URL/notes/$NAME")"

case "$CODE" in
  200) echo "deleted $NAME" ;;
  404) echo "FAIL $NAME (not on server)" >&2; exit 1 ;;
  *)   echo "FAIL $NAME (HTTP $CODE)" >&2; exit 1 ;;
esac
