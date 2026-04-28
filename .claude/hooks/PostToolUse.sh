#!/usr/bin/env bash
# .claude/hooks/PostToolUse.sh
#
# Trigger : PostToolUse — runs after EVERY tool call Claude makes.
# Purpose : Auto-stage modified files, enforce naming conventions,
#           and print a brief status line.
#
# Environment variables injected by Claude Code:
#   CLAUDE_TOOL_NAME   – name of the tool that just ran (e.g. "Write")
#   CLAUDE_TOOL_INPUT  – JSON-encoded tool input
#   CLAUDE_TOOL_OUTPUT – JSON-encoded tool output

set -euo pipefail

TOOL="${CLAUDE_TOOL_NAME:-}"

# ── 1. Auto-stage after any Write / Edit ─────────────────────────────────────
if [[ "$TOOL" == "Write" || "$TOOL" == "Edit" || "$TOOL" == "MultiEdit" ]]; then
  # Extract the file path from the tool input (requires jq)
  FILE=$(echo "${CLAUDE_TOOL_INPUT:-{}}" | jq -r '.path // empty' 2>/dev/null || true)

  if [[ -n "$FILE" && -f "$FILE" ]]; then
    git add -- "$FILE" 2>/dev/null || true
    echo "[PostToolUse] staged: $FILE"
  fi
fi

# ── 2. Enforce no *.local.* files are staged ─────────────────────────────────
STAGED_LOCAL=$(git diff --cached --name-only 2>/dev/null | grep -E '\.local\.' || true)
if [[ -n "$STAGED_LOCAL" ]]; then
  echo "[PostToolUse] ERROR: attempted to stage a .local. file — unstaging."
  echo "$STAGED_LOCAL" | xargs git reset HEAD -- 2>/dev/null || true
fi

# ── 3. Status line ────────────────────────────────────────────────────────────
MODIFIED=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
echo "[PostToolUse] tool=$TOOL | dirty_files=$MODIFIED"
