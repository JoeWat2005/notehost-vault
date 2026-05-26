#!/usr/bin/env bash
# Pull notes from notehost.net into ./NOTESPULLED/.
#   bash pull.sh          # sync all
#   bash pull.sh foo.md   # fetch one
# Reads NOTES_URL and NOTES_TOKEN from $PWD/.env or this script's directory.

set -euo pipefail

case "${1:-}" in
  -h|--help) sed -n '1,6p' "$0"; exit 0 ;;
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
command -v perl >/dev/null || { echo "perl is required" >&2; exit 1; }

BASE_URL="${NOTES_URL%/process}"
DEST_DIR="$WORK_DIR/NOTESPULLED"
mkdir -p "$DEST_DIR"

fetch_one() {
  local name="$1"
  local out="$DEST_DIR/$name"
  local code
  code="$(curl -sS -o "$out" -w '%{http_code}' \
    -H "Authorization: Bearer $NOTES_TOKEN" \
    "$BASE_URL/notes/$name")"
  if [ "$code" != "200" ]; then
    echo "FAIL $name (HTTP $code)" >&2
    rm -f "$out"
    return 1
  fi
  echo "OK   $name -> NOTESPULLED/$name"
}

if [ $# -gt 0 ]; then
  fetch_one "$1"
  exit $?
fi

LIST="$(curl -sS -H "Authorization: Bearer $NOTES_TOKEN" "$BASE_URL/notes")"
NAMES="$(printf '%s' "$LIST" | perl -e '
  local $/; my $j = <STDIN>;
  while ($j =~ /"name"\s*:\s*"([^"]+)"/g) { print "$1\n"; }
')"

if [ -z "$NAMES" ]; then
  echo "No notes on server."
  exit 0
fi

FAILED=0
while IFS= read -r name; do
  [ -n "$name" ] || continue
  fetch_one "$name" || FAILED=$((FAILED + 1))
done <<< "$NAMES"

exit "$FAILED"
