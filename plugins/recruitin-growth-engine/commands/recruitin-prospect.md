---
name: recruitin-prospect
description: Prospect enrichment — verrijk een bedrijf, bereken ICP score, maak deal aan in Pipedrive
allowed-tools: mcp, supabase, clay, pipedrive, linkedin, playwright, slack, Read, Write, Bash, Grep, Glob
---

# Prospect Enrichment & ICP Scoring

Verrijk een prospect en bereken de ICP score.

Gebruik: `/recruitin-prospect <bedrijfsnaam>`

## Stap 1: Data Verzamelen
Gebruik **Clay** MCP (indien gekoppeld):
- Bedrijfsgrootte (FTE)
- Sector
- Regio/vestigingen
- Key contacts (HR Director, Head of HR, Talent Acquisition)

Als Clay niet gekoppeld is, gebruik **Playwright**:
- Scrape bedrijfswebsite voor info
- Check LinkedIn bedrijfspagina

## Stap 2: Hiring Signals Detecteren
Gebruik **Playwright**:
- Scrape career page → tel open vacatures
- Categoriseer: welke rollen, welke regio's

Gebruik **LinkedIn** MCP (indien gekoppeld):
- Zoek recent geposte vacatures
- Check of ze actief recruiten

## Stap 3: ICP Score Berekenen
7 criteria (max 28.5 punten):

| Criterium | Max Score | Scoring |
|-----------|-----------|---------|
| Bedrijfsgrootte | 5.0 | >1000=5, 500-1000=4, 200-500=3, 50-200=2, <50=1 |
| Sector | 4.0 | Manufacturing/automotive=4, energy/industrial=3, overig=2 |
| Regio | 4.0 | Gelderland=4, Overijssel/Brabant=3, anders=1.5 |
| Recruitment Type | 4.5 | RPO=4.5, w&s=3, interim=2, project=1.5 |
| Budget Range | 5.0 | €100k+=5, €50-100k=3.5, €25-50k=2, <€25k=1 |
| Decision Maker | 3.0 | Director=3, Head=2.5, Manager=2, Recruiter=1.5 |
| Urgentie | 3.0 | Urgent=3, normaal=2, langzaam=1 |

Classificatie:
- A-prospect (≥22): Directe outreach + premium campagne
- B-prospect (14-22): Standaard campagne
- C-prospect (7-14): Alleen authority content
- No match (<7): Geen actie

## Stap 4: Opslaan
Gebruik **Supabase** MCP:
```sql
INSERT INTO icp_scores (company_name, bedrijfsgrootte_fte, sector, regio,
  recruitment_type, budget_range, decision_maker_role, urgentie,
  icp_score, icp_match, score_percentage, classification)
VALUES (...);
```

## Stap 5: CRM Actie
Gebruik **Pipedrive** MCP (indien gekoppeld):
- A-prospect → Maak deal aan in "Qualified" stage
- B-prospect → Maak deal aan in "Lead" stage
- C-prospect → Geen deal, alleen notitie

## Stap 6: Notificatie
- **Slack**: Post in #prospects:
  - A: "🔥 Nieuwe A-prospect: <naam> — Score: X/28.5 — Directe outreach aanbevolen"
  - B: "📊 Nieuwe B-prospect: <naam> — Score: X/28.5 — Standaard pipeline"
  - C: "📝 Nieuwe C-prospect: <naam> — Score: X/28.5 — Alleen nurture"

Presenteer de volledige prospect analyse aan de gebruiker.
