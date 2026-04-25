#!/usr/bin/env bash
#
# Maps git changes to doc sections that need updating.
# Reads SECTION markers from your HTML doc and a section-map file
# to tell you exactly which sections are stale.
#
# Usage:
#   ./update-doc.sh                        # diff since last doc commit
#   ./update-doc.sh HEAD~3                 # diff against specific ref
#   ./update-doc.sh abc123                 # diff against specific commit
#
# Setup:
#   1. Copy this script into your project
#   2. Set DOC_PATH below to your architecture HTML file
#   3. Edit the section_map function to match your project structure

set -euo pipefail

# --- CONFIG: edit these ---
REPO_ROOT="$(cd "$(dirname "$0")" && git rev-parse --show-toplevel 2>/dev/null || pwd)"
DOC_PATH="${DOC_PATH:-$(find "$REPO_ROOT" -name "*.html" -path "*/docs/*" -not -name "template*" | head -1)}"

if [[ -z "$DOC_PATH" || ! -f "$DOC_PATH" ]]; then
  echo "No doc found. Set DOC_PATH or put your HTML in docs/."
  exit 1
fi

REF="${1:-}"

if [[ -z "$REF" ]]; then
  REF=$(git -C "$REPO_ROOT" log -1 --format=%H -- "$DOC_PATH" 2>/dev/null || true)
  if [[ -z "$REF" ]]; then
    REF="HEAD~10"
  fi
fi

echo "Doc:     $(basename "$DOC_PATH")"
echo "Diffing: ${REF:0:7}"
echo ""

CHANGED=$(git -C "$REPO_ROOT" diff --name-only "$REF" -- . ":!$DOC_PATH" 2>/dev/null || true)

if [[ -z "$CHANGED" ]]; then
  echo "No code changes since ${REF:0:7}"
  exit 0
fi

# --- SECTION MAP: edit to match your project ---
# Each line: file_pattern -> section_name [section_name ...]
section_map() {
  local hits=()
  local check() {
    local pattern="$1"; shift
    if echo "$CHANGED" | grep -qE "$pattern"; then
      hits+=("$@")
    fi
  }

  # Database / schema changes
  check "migrations?/|\.sql$|prisma/|drizzle/"    data-model definitions

  # API routes
  check "routes/|controllers/|api/"                api changelog

  # Frontend pages
  check "pages/|views/|app/.*page\."               pages

  # Components
  check "components/"                               pages

  # Config / environment
  check "\.env|config/"                             definitions

  # Generic: any server change gets a changelog entry
  check "server/|src/server|api/"                   changelog

  # Deduplicate and sort
  printf '%s\n' "${hits[@]}" | sort -u
}

SECTIONS=$(section_map)

if [[ -z "$SECTIONS" ]]; then
  echo "Changed files don't map to any doc sections:"
  echo "$CHANGED" | sed 's/^/  /'
  exit 0
fi

echo "Sections to update:"
while IFS= read -r s; do
  LINE=$(grep -n "SECTION:${s} " "$DOC_PATH" 2>/dev/null | head -1 | cut -d: -f1)
  echo "  - $s (line ${LINE:-?})"
done <<< "$SECTIONS"

echo ""
echo "Changed files:"
echo "$CHANGED" | sed 's/^/  /'

JOINED=$(echo "$SECTIONS" | paste -sd', ' -)
echo ""
echo "---"
echo "To update, tell your AI tool:"
echo "  \"Update the ${JOINED} sections in $(basename "$DOC_PATH")\""
