#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
# Seller Breach Dashboard — Upload & Publish
# Drop your raw CSV in the same folder as this script, then run:
#   bash upload_and_publish.sh
# The dashboard at your GitHub Pages link will auto-refresh for everyone.
# ─────────────────────────────────────────────────────────────────────────────

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"   # folder this script lives in
CSV_NAME="breach_data.csv"                   # rename your CSV to this before running
COMMIT_MSG="Dashboard data update $(date '+%Y-%m-%d %H:%M')"

echo ""
echo "=== Seller Breach Dashboard Publisher ==="
echo ""

# 1. Check git is available
if ! command -v git &> /dev/null; then
  echo "ERROR: git not found. Install Git for Windows and re-open Git Bash."
  exit 1
fi

# 2. Check we're in a git repo
if [ ! -d "$REPO_DIR/.git" ]; then
  echo "ERROR: $REPO_DIR is not a git repository."
  echo "Run this once to initialize:"
  echo "  cd \"$REPO_DIR\""
  echo "  git init"
  echo "  git remote add origin https://github.com/snehabvc-netizen/Pickup-Scorecard.git"
  echo "  git checkout -b main"
  exit 1
fi

# 3. Check CSV exists
if [ ! -f "$REPO_DIR/$CSV_NAME" ]; then
  echo "ERROR: '$CSV_NAME' not found in $REPO_DIR"
  echo "Rename your raw data CSV to '$CSV_NAME' and place it here:"
  echo "  $REPO_DIR"
  exit 1
fi

CSV_SIZE=$(du -h "$REPO_DIR/$CSV_NAME" | cut -f1)
echo "Found: $CSV_NAME ($CSV_SIZE)"
echo "Publishing to GitHub Pages..."
echo ""

# 4. Stage + commit + push
cd "$REPO_DIR"
git add index.html "$CSV_NAME"
git add -A
git commit -m "$COMMIT_MSG"

if git push origin main 2>&1; then
  echo ""
  echo "✅ Published! Dashboard will refresh in ~30 seconds."
  echo "   Share this link with your team:"
  echo "   https://snehabvc-netizen.github.io/Pickup-Scorecard/"
else
  echo ""
  echo "Push failed. If this is first time:"
  echo "  git push -u origin main"
  echo "Then run this script again."
fi
