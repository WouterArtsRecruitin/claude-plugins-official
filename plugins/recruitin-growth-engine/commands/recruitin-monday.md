---
name: recruitin-monday
description: Volledige maandag data cyclus — scrape market intelligence, importeer metrics, genereer weekrapport, notify team
allowed-tools: mcp, supabase, playwright, slack, notion, Read, Write, Bash, Grep, Glob
---

# Maandag Data Cyclus

Voer de volledige maandag routine uit in deze volgorde:

## Stap 1: Market Intelligence Scrapen
Gebruik **Playwright** om actuele data op te halen:
- Scrape Indeed.nl voor vacature-volumes per keyword (PLC programmeur, field service engineer, maintenance engineer, automation engineer, commissioning engineer, technisch commercieel) in 3 regio's (Gelderland, Overijssel, Noord-Brabant)
- Check de career pages van ICP bedrijven (ASML, VDL Groep, Philips, Siemens, Alfen, Stork, BAM) voor nieuwe vacatures
- Scrape concurrent blogs (Yacht, Brunel, Randstad, Olympia, Tempo-Team) voor nieuwe posts deze week

## Stap 2: Data Opslaan
Gebruik **Supabase** MCP:
- INSERT nieuwe rijen in `market_intelligence` met data_type, keyword, region, metric_value
- UPDATE bestaande rijen als dezelfde week/keyword combinatie al bestaat

## Stap 3: Weekly Metrics Importeren
Vraag de gebruiker om de campagne metrics van deze week (of importeer automatisch als Meta/LinkedIn API gekoppeld is):
- Per actieve campagne: impressies, clicks, sollicitaties, qualified_applications, hires, spend
- INSERT in `weekly_metrics` — CTR, CPC, CPA, CPH, quality_score worden automatisch berekend

## Stap 4: Winning Strategies Refreshen
```sql
SELECT refresh_winning_strategies();
```

## Stap 5: Anomalie Detectie
Query `weekly_metrics` voor anomalieën:
- CTR daling >30% t.o.v. campagne-gemiddelde → WAARSCHUWING
- CPC stijging >25% → WAARSCHUWING
- Quality Score daling >20% → WAARSCHUWING
- 0 sollicitaties bij actieve spend >7 dagen → PAUZEER ALERT

## Stap 6: Weekrapport Genereren
Maak een rapport met:
- KPI overzicht per campagne (week-over-week)
- Market intelligence highlights
- Anomalieën en aanbevolen acties
- Top/flop campagnes

## Stap 7: Distributie
- **Slack**: Post samenvatting in #campagne-updates
- **Notion**: Sla volledig rapport op

Presenteer het rapport aan de gebruiker met concrete aanbevelingen.
