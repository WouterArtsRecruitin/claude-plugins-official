---
name: workflow-automation
description: This skill should be used when the user wants to "fix failing workflows", "set up GitHub Actions", "automate the weekly pipeline", "consolidate workflows", "debug CI/CD", "set up scheduled scraping", "fix cron jobs", or needs guidance on GitHub Actions workflow automation for the Recruitin intelligence pipeline.
version: 0.1.0
---

# Workflow Automation — Geconsolideerde Pipeline

Dit skill vervangt de 20 losse GitHub Actions workflows over 3 repos met een geconsolideerd, robuust systeem.

## Probleemanalyse: Waarom Workflows Falen

### Repo 1: intelligence-hub (12 workflows)
| Probleem | Oorzaak |
|----------|---------|
| Race conditions | 6 workflows op maandag 09:00 UTC tegelijk |
| Dubbele executie | `intelligence-hub.yml` (07:00) draait ALLE scrapers, dan draaien ze OPNIEUW individueel om 09:00 |
| Geen dependency chain | Dashboard draait op 10:00 ongeacht of scrapers succesvol waren |
| Fragiele Notion pushes | `push-to-notion.js` wordt 4x aangeroepen zonder retry/dedup |
| Mixed Node versions | Sommige workflows Node 18, andere Node 20 |

### Repo 2: recruitin-content-intelligence-system (3 workflows)
| Probleem | Oorzaak |
|----------|---------|
| Dagelijks op weekdagen | `notion-content-automation.yml` draait 5x/week maar output is minimaal |
| Git push conflicts | Workflow commit json bestanden → merge conflicts bij concurrent runs |
| Geen error propagation | `list-drafts` job draait altijd, ook als `fetch-news` faalt |

### Repo 3: recruitin-mcp-servers (5 workflows)
| Probleem | Oorzaak |
|----------|---------|
| Daily news scraper | `generate-news-report-now.js` faalt als Brave API quota op is |
| Content generation | Direct `curl` naar Claude API zonder error handling |
| Build failures | `publish-wouter-mcp.yml` triggered op elke push naar main |

## Oplossing: Geconsolideerd 3-Workflow Systeem

In plaats van 20 losse workflows, 3 robuuste pipelines:

```
┌─────────────────────────────────────────────────────┐
│              GECONSOLIDEERD SYSTEEM                  │
│                                                     │
│  Pipeline 1: DAILY (ma-vr 07:00 CET)              │
│  ├── News scraping (Brave API)                      │
│  ├── Push naar Notion + Supabase                    │
│  └── Slack notificatie                              │
│                                                     │
│  Pipeline 2: WEEKLY INTELLIGENCE (ma 08:00 CET)    │
│  ├── Stap 1: Market Trends scraper                  │
│  ├── Stap 2: ICP Monitor (wacht op stap 1)         │
│  ├── Stap 3: Concurrent Tracker (wacht op stap 2)  │
│  ├── Stap 4: Job Board + Intent + Email trackers    │
│  ├── Stap 5: Push ALLES naar Supabase + Notion     │
│  ├── Stap 6: Dashboard genereren                    │
│  └── Stap 7: Slack rapport                          │
│                                                     │
│  Pipeline 3: WEEKLY CONTENT (vr 17:00 CET)         │
│  ├── Stap 1: Top artikelen selecteren               │
│  ├── Stap 2: LinkedIn + Blog content genereren      │
│  ├── Stap 3: Push naar Notion                       │
│  └── Stap 4: GitHub Issue + Slack                   │
│                                                     │
│  + Claude Actions (PR-triggered, ongewijzigd)       │
│  ├── claude.yml (@claude mentions)                  │
│  └── claude-code-review.yml (PR reviews)            │
│                                                     │
└─────────────────────────────────────────────────────┘
```

## Architectuurprincipes

### 1. Sequential Steps, Niet Parallel Jobs
Elke pipeline is één job met sequentiële stappen. Als stap 2 faalt, stoppen stap 3-7.

### 2. Supabase als Primary Store
Alle data gaat EERST naar Supabase, DAN naar Notion/Google Sheets als secondary.

### 3. Retry Logic
Elke API call (Brave, Notion, Claude, Slack) krijgt 3 retries met exponential backoff.

### 4. Deduplicatie
Check of data voor deze week al bestaat voordat je INSERT doet.

### 5. Één Node Versie
Alles draait op Node 20 LTS.

### 6. Unified Secrets
Eén set secrets die alle workflows delen, gedocumenteerd in de reference doc.

## Migratie Pad

### Fase 1: Nieuwe workflows deployen (in claude-plugins-official)
- Maak de 3 geconsolideerde workflows
- Test met `workflow_dispatch`

### Fase 2: Oude workflows disablen
- Ga naar intelligence-hub > Actions > per workflow > "Disable workflow"
- Ga naar recruitin-content-intelligence-system > Actions > disable
- Ga naar recruitin-mcp-servers > Actions > disable (behalve publish)

### Fase 3: Monitoring
- Check Slack notificaties
- Verifieer Supabase data
- Na 2 weken succesvol: verwijder oude workflow bestanden

## Benodigde Secrets

| Secret | Gebruikt door | Waar te vinden |
|--------|--------------|----------------|
| `BRAVE_API_KEY` | News + Market scraping | brave.com/search/api |
| `NOTION_API_KEY` | Content push | notion.so/my-integrations |
| `SUPABASE_URL` | Data opslag | Supabase Dashboard > Settings > API |
| `SUPABASE_SERVICE_ROLE_KEY` | Data opslag | Supabase Dashboard > Settings > API |
| `ANTHROPIC_API_KEY` | Content generatie | console.anthropic.com |
| `SLACK_WEBHOOK_URL` | Notificaties | Slack > Apps > Incoming Webhooks |
| `GOOGLE_CREDENTIALS` | Dashboard sheets | Google Cloud Console |
| `SHEET_ID` | Dashboard sheets | Google Sheets URL |
| `CLAUDE_CODE_OAUTH_TOKEN` | @claude actions | Claude Code settings |
