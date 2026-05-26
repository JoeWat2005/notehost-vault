#!/usr/bin/env bash
# List notes on the server (size + name).
#   bash list.sh           # all your notes
#   bash list.sh foo/      # only under a folder prefix
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

URL="$BASE_URL/notes"
[ $# -gt 0 ] && URL="$URL?prefix=$1"

curl -sS -H "Authorization: Bearer $NOTES_TOKEN" "$URL" | perl -e '
  local $/;
  my $j = <STDIN>;
  my $any = 0;
  while ($j =~ /\{[^}]*"name"\s*:\s*"([^"]+)"[^}]*"size"\s*:\s*(\d+)[^}]*\}/g) {
    printf "%10d  %s\n", $2, $1;
    $any = 1;
  }
  print STDERR "(empty)\n" unless $any;
'
