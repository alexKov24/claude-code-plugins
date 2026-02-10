#!/bin/bash
# analyze-branch.sh - Analyze commits on current branch vs base branch
# Usage: bash analyze-branch.sh [base-branch]
# Output: Structured analysis of all commits, files changed, and overlap

set -euo pipefail

BASE_BRANCH="${1:-main}"
CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"

if [ "$CURRENT_BRANCH" = "$BASE_BRANCH" ]; then
  echo "ERROR: Currently on $BASE_BRANCH. Switch to a feature branch first."
  exit 1
fi

MERGE_BASE="$(git merge-base "$BASE_BRANCH" HEAD)"

echo "=== BRANCH ANALYSIS ==="
echo "Current branch: $CURRENT_BRANCH"
echo "Base branch: $BASE_BRANCH"
echo "Merge base: $(git log --oneline -1 "$MERGE_BASE")"
echo ""

# Count commits
COMMIT_COUNT="$(git rev-list --count "$MERGE_BASE"..HEAD)"
echo "Total commits on branch: $COMMIT_COUNT"
echo ""

# List all commits with their changed files
echo "=== COMMITS (oldest first) ==="
git log --reverse --format="---COMMIT---%n%H%n%s%n%b" "$MERGE_BASE"..HEAD | while IFS= read -r line; do
  if [ "$line" = "---COMMIT---" ]; then
    read -r hash
    read -r subject
    # Read body lines until next ---COMMIT--- or EOF
    body=""
    echo ""
    echo "COMMIT: $hash"
    echo "MESSAGE: $subject"
    echo "FILES:"
    git diff-tree --no-commit-id --name-status -r "$hash" | sed 's/^/  /'
  fi
done
echo ""

# Files changed across the entire branch (cumulative diff)
echo "=== CUMULATIVE CHANGES (branch vs $BASE_BRANCH) ==="
git diff --stat "$MERGE_BASE"..HEAD
echo ""

# File-level change summary
echo "=== FILES CHANGED ==="
git diff --name-status "$MERGE_BASE"..HEAD | sort
echo ""

# Detect files touched by multiple commits (overlap)
echo "=== FILE OVERLAP (files touched by multiple commits) ==="
git log --name-only --format="" "$MERGE_BASE"..HEAD | sort | uniq -c | sort -rn | while read -r count file; do
  if [ -n "$file" ] && [ "$count" -gt 1 ]; then
    echo "  $count commits -> $file"
  fi
done
echo ""

# Directory-level grouping hint
echo "=== DIRECTORY DISTRIBUTION ==="
git diff --name-only "$MERGE_BASE"..HEAD | sed 's|/[^/]*$||' | sort | uniq -c | sort -rn | head -20
echo ""

echo "=== ANALYSIS COMPLETE ==="
