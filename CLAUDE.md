# CLAUDE.md — Project Rules for AI Agents

> This file is loaded automatically by Claude Code on every session.
> Keep it under 200 lines. Focus on rules, not tutorials.

---

## 1. Identity & Scope

You are an AI coding assistant working inside this repository.
Your job: read, write, refactor, test, and ship code — nothing else.
Do not browse the internet unless a tool explicitly permits it.

---

## 2. Core Principles

- **Minimal footprint**: change only what is necessary.
- **Ask before deleting**: never remove files or directories without confirmation.
- **Deterministic hooks**: hooks in `.claude/hooks/` always run; respect their output.
- **Modular skills**: load skills from `.claude/skills/` only when the task calls for it.
- **Scoped rules**: rules in `.claude/rules/` apply only to the file paths they declare.

---

## 3. Project Layout

```
.
├── CLAUDE.md              ← you are here
├── CLAUDE.local.md        ← personal overrides (gitignored; copy from CLAUDE.local.md.example)
├── .gitignore
├── mcp.json               ← MCP server config (root only)
├── settings.json          ← global permissions & hook registry
├── settings.local.json    ← personal overrides (gitignored; copy from settings.local.json.example)
└── .claude/
    ├── hooks/             ← deterministic, fire every time
    ├── commands/          ← slash commands  (/ship, etc.)
    ├── skills/            ← modular, load on demand
    ├── agents/            ← isolated sub-agents
    ├── output-styles/     ← response format rules
    ├── plugins/           ← first-class integrations
    ├── rules/             ← path-scoped rule files
    └── statusline         ← bottom-bar display config
```

---

## 4. Workflow Rules

### Git
- Always work on a feature branch; never push directly to `main`.
- Commit messages: `type(scope): short description` (Conventional Commits).
- Run `git status` before every commit to verify the diff.

### Code Quality
- Run the project linter before marking a task done.
- Fix all errors; warnings are acceptable if pre-existing.
- Do not add dependencies without explicit user approval.

### Testing
- Write or update tests for every behaviour change.
- All tests must pass before shipping.
- Prefer unit tests over integration tests unless the change crosses service boundaries.

### Security
- Never commit secrets, tokens, or passwords.
- Secrets live in environment variables or a secrets manager.
- Validate all external input; sanitise before use.

---

## 5. File Conventions

| Pattern | Rule |
|---------|------|
| `src/api/**` | Follow `.claude/rules/api.md` |
| `**/*.test.*` | Do not delete; update to match new behaviour |
| `*.local.*` | Gitignored; never commit |
| `.env*` | Gitignored; never commit |

---

## 6. Communication Style

- Default output style: concise, code-first (see `.claude/output-styles/terse.md`).
- When in doubt, show the diff and ask for confirmation.
- Flag blockers immediately rather than silently skipping them.

---

## 7. Agent Handoffs

When delegating to a sub-agent in `.claude/agents/`:

1. Pass **only** the context the agent needs.
2. Receive the agent's structured output and validate it.
3. Never merge agent output blindly — review diffs first.

---

## 8. Hooks Summary

| Hook | Trigger | Purpose |
|------|---------|---------|
| `SessionStart.sh` | Session open | Load context, print project summary |
| `PostToolUse.sh` | After every tool call | Auto-stage edits, enforce naming |
| `PreCompact.sh` | Before context compaction | Save session state to `.claude/state/` |

---

*Last updated: 2026-04 · Keep this file focused and under 200 lines.*
