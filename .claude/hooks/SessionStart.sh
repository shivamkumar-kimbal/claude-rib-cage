#!/usr/bin/env bash
# .claude/hooks/SessionStart.sh
#
# Trigger : SessionStart — runs once when Claude Code opens a session.
# Purpose : Print a project summary so the agent immediately understands
#           the codebase state without extra exploration.

set -euo pipefail

CYAN='\033[0;36m'
RESET='\033[0m'

echo -e "${CYAN}══════════════════════════════════════════════${RESET}"
echo -e "${CYAN}  Claude Code — Session Start                 ${RESET}"
echo -e "${CYAN}══════════════════════════════════════════════${RESET}"

# ── Project identity ──────────────────────────────────────────────────────────
echo "Project : ${CLAUDE_PROJECT:-$(basename "$PWD")}"
echo "Env     : ${CLAUDE_ENV:-development}"
echo "Date    : $(date -u '+%Y-%m-%d %H:%M UTC')"
echo ""

# ── Git context ───────────────────────────────────────────────────────────────
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
LAST_COMMIT=$(git log -1 --oneline 2>/dev/null || echo "no commits yet")
DIRTY=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')

echo "Branch      : $BRANCH"
echo "Last commit : $LAST_COMMIT"
echo "Dirty files : $DIRTY"
echo ""

# ── Quick structure summary ───────────────────────────────────────────────────
if command -v tree &>/dev/null; then
  tree -L 2 -a --noreport -I '.git|node_modules|__pycache__|.venv' 2>/dev/null || true
else
  find . -maxdepth 2 \
    -not -path './.git/*' \
    -not -path './node_modules/*' \
    -not -name '*.pyc' \
    | sort
fi
echo ""

# ── Active rules reminder ─────────────────────────────────────────────────────
echo "Active rules:"
find .claude/rules -name '*.md' 2>/dev/null | while read -r rule; do
  SCOPE=$(grep -m1 'applies_to:' "$rule" 2>/dev/null | sed 's/.*applies_to: //' || echo "global")
  echo "  • $(basename "$rule") → $SCOPE"
done

echo ""
echo -e "${CYAN}Ready. Refer to CLAUDE.md for project rules.${RESET}"
