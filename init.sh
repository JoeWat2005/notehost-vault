#!/usr/bin/env bash
# Initialise this folder:
#   1. Configure JupyterLab to open .md in Markdown Preview -- skipped silently
#      if `jupyter` isn't installed, so off vLab this is a no-op.
#   2. Batch-send every .md in the current directory that does NOT already
#      have an equivalent in markdownvault/.
#
#   bash init.sh
#
# Reads NOTES_URL and NOTES_TOKEN from $PWD/.env or this script's directory.

set -euo pipefail

case "${1:-}" in
  -h|--help) sed -n '1,11p' "$0"; exit 0 ;;
esac

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORK_DIR="$(pwd)"

# --- 1. JupyterLab default-viewer config (only when jupyter is installed) ---
if command -v jupyter >/dev/null 2>&1; then
  JL_DIR="$HOME/.jupyter/lab/user-settings/@jupyterlab/docmanager-extension"
  mkdir -p "$JL_DIR"
  cat > "$JL_DIR/plugin.jupyterlab-settings" <<'EOF'
{
    "defaultViewers": {
        "markdown": "Markdown Preview"
    }
}
EOF
fi

# --- 2. Batch-process new .md files in $WORK_DIR ---
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

MV_DIR="$SCRIPT_DIR/markdownvault"
if [ ! -d "$MV_DIR" ]; then
  echo "markdownvault not found at $MV_DIR -- skipping batch step" >&2
  exit 0
fi

PROCESSED=0
SKIPPED=0
FAILED=0
TOUCHED=0

shopt -s nullglob
for src in "$WORK_DIR"/*.md; do
  TOUCHED=$((TOUCHED + 1))
  name="$(basename "$src")"
  stem="${name%.md}"

  existing="$(find "$MV_DIR" -type f \( -name "$name" -o -name "${stem}_notes.md" \) -print -quit 2>/dev/null || true)"
  if [ -n "$existing" ]; then
    SKIPPED=$((SKIPPED + 1))
    continue
  fi

  out="$MV_DIR/$name"
  code="$(curl -sS -o "$out" -w '%{http_code}' \
    -X POST "$NOTES_URL" \
    -H "Authorization: Bearer $NOTES_TOKEN" \
    -H "Content-Type: text/markdown" \
    -H "X-Note-Name: $name" \
    --data-binary "@$src")"

  if [ "$code" != "200" ]; then
    echo "FAIL $name (HTTP $code)" >&2
    [ -s "$out" ] && cat "$out" >&2
    rm -f "$out"
    FAILED=$((FAILED + 1))
    continue
  fi

  PROCESSED=$((PROCESSED + 1))
done

if [ "$FAILED" -eq 0 ]; then
  echo "OK initialised"
else
  echo "FAILED ($FAILED errors)"
fi
echo "Summary: processed=$PROCESSED skipped=$SKIPPED failed=$FAILED"
exit "$FAILED"
