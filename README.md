# claude-rib-cage

A **plug-and-play Claude Code Guide Repository** — a complete template that
helps Claude Code (and similar AI agents) understand, navigate, and operate
within a real-world codebase.

> Inspired by the `.claude/ folder, fully mapped` layout.
> Copy this repo, drop it into your project, and your AI agent is immediately
> oriented — with deterministic hooks, modular skills, scoped rules, and
> isolated sub-agents.

---

## Folder Tree

```
your-project/
├── CLAUDE.md                        ← Project rules for the AI (< 200 lines)
├── CLAUDE.local.md.example              ← Personal overrides template (copy → CLAUDE.local.md)
├── .gitignore                       ← Ignores *.local.* and secrets
├── mcp.json                         ← MCP server config — MUST be at root
├── settings.json                    ← Permissions, model, hook registry
├── settings.local.json.example          ← Personal overrides template (copy → settings.local.json)
└── .claude/
    ├── hooks/                       ← Deterministic, fire every time
    │   ├── PostToolUse.sh           ← Auto-stage files after edits
    │   ├── SessionStart.sh          ← Load project context on startup
    │   └── PreCompact.sh            ← Save state before context compaction
    ├── commands/                    ← Slash commands (legacy, still works)
    │   └── ship.md                  ← Build, lint, test, deploy in one go
    ├── skills/                      ← Canonical home — model-invokable
    │   ├── carousel/
    │   │   └── skill.md             ← Auto-factory for IG/LinkedIn carousels
    │   └── drill/
    │       └── skill.md             ← Generates spaced-repetition drills
    ├── agents/                      ← Sub-agents — isolated context window
    │   ├── code-reviewer.md         ← Reviews diffs, returns findings table
    │   ├── researcher.md            ← Web fetch and synthesis
    │   └── log-analyzer.md          ← Parses errors and crash logs
    ├── output-styles/               ← Custom response formats
    │   └── terse.md                 ← Code-only, no prose
    ├── plugins/                     ← First-class integrations
    │   └── vercel/
    │       ├── plugin.md            ← Bundled commands, agents, MCP config
    │       └── config.json          ← Vercel project settings
    ├── rules/                       ← Path-scoped, loads on glob match
    │   └── api.md                   ← Loads only for src/api/**
    └── statusline                   ← Bottom-bar display config
```

---

## File-by-file Guide

### Root files

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Main rules file. The AI reads this on every session. Keep it under 200 lines and focused on rules, not tutorials. |
| `CLAUDE.local.md` | Personal overrides. Gitignored. Copy `CLAUDE.local.md.example` → `CLAUDE.local.md` to get started. |
| `.gitignore` | Ignores `*.local.*`, `.env*`, secrets, build artefacts, and `.claude/state/`. |
| `mcp.json` | Declares [MCP servers](https://modelcontextprotocol.io/) (filesystem, GitHub, Postgres, search). Must live at the project root. |
| `settings.json` | Global permissions allow/deny list, active model, and hook registry. |
| `settings.local.json` | Personal settings override. Gitignored. Copy `settings.local.json.example` → `settings.local.json`. |

---

### `.claude/hooks/`

Hooks are **deterministic** — they fire every time the matching event occurs.
Unlike skills (load on demand), hooks always run.

| Hook | Event | What it does |
|------|-------|-------------|
| `PostToolUse.sh` | After every tool call | Auto-stages edited files with `git add`; prevents `.local.` files from being staged; prints a status line. |
| `SessionStart.sh` | Session open | Prints branch, last commit, dirty-file count, project tree, and active rules. |
| `PreCompact.sh` | Before context compaction | Serialises git status, recent commits, and staged changes to `.claude/state/session-<timestamp>.md`. Keeps the last 10 snapshots. |

---

### `.claude/commands/`

Slash commands you invoke with `/commandname` inside Claude Code.

| Command | What it does |
|---------|-------------|
| `/ship` | Runs `npm ci → lint → typecheck → test → build → git commit → git push → vercel deploy` in order. Stops on first failure. |

---

### `.claude/skills/`

Skills are **modular capabilities** loaded on demand — only when the task calls
for them. Each skill lives in its own subdirectory with a `skill.md` that
declares its metadata, process, and output schema.

| Skill | Invoke phrase | Output |
|-------|--------------|--------|
| `carousel` | "generate a carousel about X" | JSON slide deck + markdown preview |
| `drill` | "create a drill for X" | JSON question set (MCQ, fill, or debug) |

---

### `.claude/agents/`

Agents run in **isolated context windows** — they receive only what you pass
them and return structured output. Never merge agent output blindly; review
the diff first.

| Agent | Purpose | Output format |
|-------|---------|--------------|
| `code-reviewer` | Reviews git diffs | Findings table + severity + summary |
| `researcher` | Web search + synthesis | Structured report with citations |
| `log-analyzer` | Parses logs/stack traces | Diagnosis report + recommended fix |

---

### `.claude/output-styles/`

Style files control how Claude formats its responses.

| Style | Activate | Effect |
|-------|---------|--------|
| `terse` | "use terse style" (or default) | Code-first; no greetings, no padding; inline comments replace prose |

---

### `.claude/plugins/vercel/`

The Vercel plugin bundles three slash commands, environment variable sync, and
a log-analysis agent. Configure `config.json` with your project and org IDs.

| Command | What it does |
|---------|-------------|
| `/vercel:deploy` | Production deploy via `vercel --prod` |
| `/vercel:preview` | Preview deploy for the current branch |
| `/vercel:env-pull` | Pull remote env vars to `.env.local` |

---

### `.claude/rules/`

Rule files are **path-scoped** — they are loaded automatically when Claude
opens or edits a file that matches the `applies_to` glob in the rule's
front-matter.

| Rule | Applies to | Covers |
|------|-----------|--------|
| `api.md` | `src/api/**` | REST conventions, input validation, auth, error handling, DB access, logging, rate limiting |

---

### `.claude/statusline`

Configures the bottom-bar display in Claude Code:
```
development | main● | claude-opus-4-5
```
Tokens, colours, and refresh interval are all configurable.

---

## Design Principles

| Principle | Implementation |
|-----------|---------------|
| **Deterministic hooks** | Hooks always fire; they do not depend on AI judgement |
| **Modular skills** | Skills load on demand; unused skills consume no context |
| **Clear agent responsibilities** | Each agent has a single job and an isolated context |
| **Separation of global vs local** | `*.local.*` files override globals and are always gitignored |
| **AI-readable markdown** | Every file uses front-matter metadata the AI can parse |

---

## Getting Started

1. **Copy** this repository into your project (or use it as a template).
2. **Create local overrides**: `cp CLAUDE.local.md.example CLAUDE.local.md && cp settings.local.json.example settings.local.json`.
3. **Edit** `CLAUDE.md` to reflect your project's real conventions.
4. **Edit** `mcp.json` with the MCP servers your project needs.
5. **Edit** `settings.json` to tighten/loosen permissions for your workflow.
6. **Configure** `.claude/plugins/vercel/config.json` with your Vercel project ID.
7. **Add** `.claude/rules/<topic>.md` for any path-specific conventions.
8. **Gitignore** your `*.local.*` files — they're already in `.gitignore`.

---

## Key Insight

> `CLAUDE.md` is advisory.  
> **Hooks are deterministic.**  
> **Skills load on demand.**

The AI can choose to ignore a rule in `CLAUDE.md`, but it cannot ignore a
hook — hooks run as shell commands outside the model's context. That's the
backbone of this system.
