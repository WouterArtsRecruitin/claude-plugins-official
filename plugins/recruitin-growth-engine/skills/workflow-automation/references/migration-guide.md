# Migration Guide: Van 20 Workflows naar 3 Pipelines

## Wat wordt vervangen

### intelligence-hub (12 → 0 actieve workflows)

| Oude Workflow | Vervanging | Actie |
|---------------|-----------|-------|
| `intelligence-hub.yml` | `weekly-intelligence-pipeline.yml` stap 1-3 | DISABLE |
| `weekly-market-trends.yml` | `weekly-intelligence-pipeline.yml` stap 1 | DISABLE |
| `weekly-icp-activity.yml` | `weekly-intelligence-pipeline.yml` stap 2 | DISABLE |
| `weekly-concurrent-activity.yml` | `weekly-intelligence-pipeline.yml` stap 3 | DISABLE |
| `weekly-job-board.yml` | `weekly-intelligence-pipeline.yml` stap 4 | DISABLE |
| `weekly-intent-signals.yml` | `weekly-intelligence-pipeline.yml` stap 5 | DISABLE |
| `weekly-email-engagement.yml` | `weekly-intelligence-pipeline.yml` stap 5 | DISABLE |
| `weekly-dashboard.yml` | `weekly-intelligence-pipeline.yml` stap 7 | DISABLE |
| `linkedin-newsletter.yml` | `weekly-content-pipeline.yml` | DISABLE |
| `yaml-lint.yml` | Niet nodig (was only linting workflow files) | DISABLE |
| `claude.yml` | BEHOUDEN (in intelligence-hub) | KEEP |
| `claude-code-review.yml` | BEHOUDEN (in intelligence-hub) | KEEP |

### recruitin-content-intelligence-system (3 → 0 actieve workflows)

| Oude Workflow | Vervanging | Actie |
|---------------|-----------|-------|
| `notion-content-automation.yml` | `daily-news-pipeline.yml` + `weekly-content-pipeline.yml` | DISABLE |
| `claude.yml` | BEHOUDEN | KEEP |
| `claude-code-review.yml` | BEHOUDEN | KEEP |

### recruitin-mcp-servers (5 → 1 actieve workflow)

| Oude Workflow | Vervanging | Actie |
|---------------|-----------|-------|
| `daily-news-scraper.yml` | `daily-news-pipeline.yml` | DISABLE |
| `weekly-content-gen.yml` | `weekly-content-pipeline.yml` | DISABLE |
| `publish-wouter-mcp.yml` | BEHOUDEN (package publishing) | KEEP |
| `claude.yml` | BEHOUDEN | KEEP |
| `claude-code-review.yml` | BEHOUDEN | KEEP |

## Stap-voor-stap Migratie

### Stap 1: Secrets configureren in claude-plugins-official

Ga naar: `github.com/WouterArtsRecruitin/claude-plugins-official/settings/secrets/actions`

Voeg deze secrets toe:

```
BRAVE_API_KEY=<van intelligence-hub settings>
NOTION_API_KEY=<van content-intelligence-system settings>
SUPABASE_URL=https://vaiikkhaulkqdknwvroj.supabase.co
SUPABASE_SERVICE_ROLE_KEY=<je service role key>
ANTHROPIC_API_KEY=<van recruitin-mcp-servers settings>
SLACK_WEBHOOK_URL=<van intelligence-hub settings>
GOOGLE_CREDENTIALS=<van intelligence-hub settings>
SHEET_ID=<van intelligence-hub settings>
GH_PAT=<GitHub Personal Access Token met repo access>
```

De `GH_PAT` is nodig omdat de weekly-intelligence-pipeline de intelligence-hub en content-intelligence repos moet checkout-en.

### Stap 2: Test de nieuwe workflows

```bash
# Test daily pipeline
gh workflow run daily-news-pipeline.yml --repo WouterArtsRecruitin/claude-plugins-official

# Test weekly intelligence (enkele stap)
gh workflow run weekly-intelligence-pipeline.yml \
  --repo WouterArtsRecruitin/claude-plugins-official \
  -f step=market-trends

# Test weekly content
gh workflow run weekly-content-pipeline.yml --repo WouterArtsRecruitin/claude-plugins-official
```

### Stap 3: Disable oude workflows

Per repo, per workflow:
```bash
# intelligence-hub
gh workflow disable "Intelligence Hub - Weekly Scraping" --repo WouterArtsRecruitin/intelligence-hub
gh workflow disable "Weekly Market Trends" --repo WouterArtsRecruitin/intelligence-hub
gh workflow disable "Weekly ICP Activity" --repo WouterArtsRecruitin/intelligence-hub
gh workflow disable "Weekly Concurrent Activity" --repo WouterArtsRecruitin/intelligence-hub
gh workflow disable "Weekly - Job Board Tracker" --repo WouterArtsRecruitin/intelligence-hub
gh workflow disable "Weekly - Intent Signals Tracker" --repo WouterArtsRecruitin/intelligence-hub
gh workflow disable "Weekly - Email Engagement Tracker" --repo WouterArtsRecruitin/intelligence-hub
gh workflow disable "Weekly - Reporting Dashboard" --repo WouterArtsRecruitin/intelligence-hub
gh workflow disable "LinkedIn Newsletter Automation" --repo WouterArtsRecruitin/intelligence-hub
gh workflow disable "YAML Linter" --repo WouterArtsRecruitin/intelligence-hub

# content-intelligence-system
gh workflow disable "Notion Content Manager - Daily Automation" --repo WouterArtsRecruitin/recruitin-content-intelligence-system

# mcp-servers
gh workflow disable "Daily News Scraper" --repo WouterArtsRecruitin/recruitin-mcp-servers
gh workflow disable "Weekly Content Generator" --repo WouterArtsRecruitin/recruitin-mcp-servers
```

### Stap 4: Monitor (2 weken)

Check dagelijks:
1. Slack kanaal voor pipeline notificaties
2. Supabase `market_intelligence` tabel voor nieuwe data
3. Notion databases voor nieuwe entries
4. GitHub Actions tab voor groene ✅

### Stap 5: Cleanup (na 2 weken)

Als alles stabiel draait, verwijder de oude workflow bestanden uit de repos.

## Nieuw Schema

| Tijd (CET) | Pipeline | Frequentie |
|------------|----------|------------|
| 07:00 | Daily News Pipeline | Ma-Vr |
| 08:00 | Weekly Intelligence Pipeline | Maandag |
| 17:00 | Weekly Content Pipeline | Vrijdag |

Vergelijk met het oude schema (12 workflows, 06:00-10:00 op maandag):

```
OUD:  ████████████░░░░░░░░░░░░  (12 workflows, 06:00-10:00, race conditions)
NIEUW: █░░░█░░░░░░░░░░░░░░░░█  (3 pipelines, geen overlap)
```

## Rollback Plan

Als de nieuwe workflows niet werken:
1. Re-enable de oude workflows: `gh workflow enable "<naam>" --repo ...`
2. De nieuwe workflows disablen: `gh workflow disable "<naam>" --repo WouterArtsRecruitin/claude-plugins-official`
3. Alles draait weer zoals voorheen
