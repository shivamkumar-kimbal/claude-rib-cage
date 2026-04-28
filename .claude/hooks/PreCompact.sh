#!/usr/bin/env bash
# .claude/hooks/PreCompact.sh
#
# Trigger : PreCompact — runs just before Claude Code compacts the context window.
# Purpose : Serialise the current session state to .claude/state/ so that
#           important context (open tasks, decisions made) survives compaction.

set -euo pipefail

STATE_DIR=".claude/state"
mkdir -p "$STATE_DIR"

TIMESTAMP=$(date -u '+%Y%m%dT%H%M%SZ')
STATE_FILE="$STATE_DIR/session-$TIMESTAMP.md"

echo "# Session State — $TIMESTAMP" > "$STATE_FILE"
echo "" >> "$STATE_FILE"

# ── Git snapshot ──────────────────────────────────────────────────────────────
echo "## Git Status" >> "$STATE_FILE"
echo '```' >> "$STATE_FILE"
git status --short 2>/dev/null >> "$STATE_FILE" || echo "(no git repo)" >> "$STATE_FILE"
echo '```' >> "$STATE_FILE"
echo "" >> "$STATE_FILE"

echo "## Recent Commits" >> "$STATE_FILE"
echo '```' >> "$STATE_FILE"
git log --oneline -10 2>/dev/null >> "$STATE_FILE" || true
echo '```' >> "$STATE_FILE"
echo "" >> "$STATE_FILE"

# ── Staged diff ───────────────────────────────────────────────────────────────
STAGED=$(git diff --cached --stat 2>/dev/null || true)
if [[ -n "$STAGED" ]]; then
  echo "## Staged Changes" >> "$STATE_FILE"
  echo '```' >> "$STATE_FILE"
  echo "$STAGED" >> "$STATE_FILE"
  echo '```' >> "$STATE_FILE"
  echo "" >> "$STATE_FILE"
fi

# ── Environment snapshot ──────────────────────────────────────────────────────
echo "## Environment" >> "$STATE_FILE"
echo "- Project : ${CLAUDE_PROJECT:-$(basename "$PWD")}" >> "$STATE_FILE"
echo "- Env     : ${CLAUDE_ENV:-development}" >> "$STATE_FILE"
echo "- Branch  : $(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo unknown)" >> "$STATE_FILE"
echo "" >> "$STATE_FILE"

echo "[PreCompact] state saved → $STATE_FILE"

# ── Prune old state files (keep last 10) ─────────────────────────────────────
ls -t "$STATE_DIR"/session-*.md 2>/dev/null | tail -n +11 | xargs rm -f 2>/dev/null || true
