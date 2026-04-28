# /ship — Build, Lint, Test, and Deploy

> **Slash command**: type `/ship` inside Claude Code to trigger this workflow.
> Claude will execute each step in order and stop on the first failure.

---

## Steps

### 1. Quality gate

```bash
# Install dependencies (idempotent)
npm ci

# Lint
npm run lint

# Type-check (if applicable)
npm run typecheck 2>/dev/null || true

# Tests
npm test -- --passWithNoTests
```

### 2. Build

```bash
npm run build
```

### 3. Commit staged changes

```bash
git add -A
git commit -m "chore(release): ship $(date -u '+%Y-%m-%d')" || echo "Nothing to commit"
```

### 4. Push branch

```bash
BRANCH=$(git rev-parse --abbrev-ref HEAD)
git push origin "$BRANCH"
echo "Pushed → $BRANCH"
```

### 5. Deploy (Vercel)

```bash
# Requires Vercel CLI: npm i -g vercel
# Reads project config from .claude/plugins/vercel/
vercel deploy --prod --yes
```

---

## Notes

- Steps 1–3 run locally; step 5 deploys to the configured Vercel project.
- If any step fails, Claude stops and reports the error before proceeding.
- Override deploy target by editing `.claude/plugins/vercel/config.json`.
