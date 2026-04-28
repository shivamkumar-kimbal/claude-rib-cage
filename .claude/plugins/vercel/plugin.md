# Plugin: Vercel

<!-- plugin_meta
name: vercel
description: Bundled commands, agents, and MCP config for deploying to Vercel.
version: 1.0.0
requires: ["vercel-cli>=32"]
-->

---

## What this plugin provides

| Resource | Path | Purpose |
|----------|------|---------|
| Deploy command | `/vercel:deploy` | One-shot production deploy |
| Preview command | `/vercel:preview` | Deploy preview for current branch |
| Env sync command | `/vercel:env-pull` | Pull remote env vars to `.env.local` |
| Log agent | `agents/vercel-logs.md` | Tail and diagnose Vercel runtime logs |

---

## Configuration

Edit `config.json` in this directory to customise the plugin:

```json
{
  "projectId": "prj_xxxxxxxxxxxxxxxxxxxx",
  "orgId": "team_xxxxxxxxxxxxxxxxxxxx",
  "regions": ["iad1"],
  "framework": "nextjs",
  "buildCommand": "npm run build",
  "outputDirectory": ".next",
  "autoAlias": true
}
```

> `projectId` and `orgId` are found in your Vercel project settings.
> Do NOT commit tokens — they go in `.env.local`.

---

## Commands

### `/vercel:deploy` — Production deploy

```bash
vercel deploy --prod --yes \
  --token "$VERCEL_TOKEN" \
  --scope "$(jq -r .orgId .claude/plugins/vercel/config.json)"
```

### `/vercel:preview` — Preview deploy

```bash
BRANCH=$(git rev-parse --abbrev-ref HEAD)
vercel deploy --yes \
  --token "$VERCEL_TOKEN" \
  --meta "branch=$BRANCH"
```

### `/vercel:env-pull` — Sync env vars

```bash
vercel env pull .env.local --yes --token "$VERCEL_TOKEN"
echo "Environment pulled → .env.local"
```

---

## Environment variables required

| Variable | Where to set |
|----------|-------------|
| `VERCEL_TOKEN` | `.env.local` or CI secret |
| `VERCEL_PROJECT_ID` | `.env.local` (override `config.json`) |
| `VERCEL_ORG_ID` | `.env.local` (override `config.json`) |
