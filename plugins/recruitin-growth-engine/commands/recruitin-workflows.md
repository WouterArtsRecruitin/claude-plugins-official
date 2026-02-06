---
name: recruitin-workflows
description: Manage and monitor the Recruitin workflow pipelines — check status, trigger runs, debug failures, migrate from old workflows
allowed-tools: mcp, supabase, github, slack, Read, Write, Bash, Grep, Glob
---

# Workflow Management

Beheer de Recruitin CI/CD pipelines.

Gebruik: `/recruitin-workflows <actie>`

Acties:
- `status` — Toon status van alle 3 pipelines
- `trigger <pipeline>` — Handmatig triggeren (daily/weekly-intel/weekly-content)
- `debug` — Analyseer recente failures
- `migrate` — Start migratie van oude naar nieuwe workflows
- `secrets` — Check welke secrets geconfigureerd moeten worden

## Status Check

Gebruik **GitHub** MCP:
```
gh run list --repo WouterArtsRecruitin/claude-plugins-official --limit 10
```

Toon per pipeline:
- Laatste run datum
- Status (success/failure/in_progress)
- Duur
- Link naar logs

## Trigger

```bash
gh workflow run daily-news-pipeline.yml --repo WouterArtsRecruitin/claude-plugins-official
gh workflow run weekly-intelligence-pipeline.yml --repo WouterArtsRecruitin/claude-plugins-official
gh workflow run weekly-content-pipeline.yml --repo WouterArtsRecruitin/claude-plugins-official
```

## Debug

Bij failures:
1. Haal de laatste failed run op via GitHub MCP
2. Lees de logs
3. Identificeer de falende stap
4. Check of het een secret issue is (missing env vars)
5. Check of het een script error is (node/python)
6. Check of het een API rate limit is (Brave, Notion, Claude)
7. Stel een fix voor

## Migrate

Volg de stappen uit `skills/workflow-automation/references/migration-guide.md`:
1. Configureer secrets in claude-plugins-official
2. Test nieuwe workflows met workflow_dispatch
3. Disable oude workflows in de 3 repos
4. Monitor 2 weken
5. Cleanup
