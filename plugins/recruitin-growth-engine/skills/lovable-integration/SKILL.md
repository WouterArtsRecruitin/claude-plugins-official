---
name: lovable-integration
description: This skill should be used when the user wants to "build a recruitment app in Lovable", "create a dashboard in Lovable", "connect Lovable to Supabase", "deploy a candidate portal", "build a hiring funnel app", "create a recruitment landing page", "set up Lovable connectors", "integrate APIs in Lovable", or needs guidance on building Lovable.dev apps that connect to the Recruitin Growth Engine ecosystem.
version: 0.1.0
---

# Lovable Integration for Recruitin Growth Engine

This skill connects the Recruitin Growth Engine to Lovable.dev — a visual app builder. Use it to build recruitment marketing apps, candidate portals, dashboards en landing pages die direct gekoppeld zijn aan je Supabase database.

## Lovable Architectuur

Lovable werkt met 3 typen integraties:

| Type | Doel | Gebruik voor Recruitin |
|------|------|----------------------|
| **Shared Connectors** | Functionaliteit voor deployed apps | Supabase (database), Stripe (betaling), Lovable AI |
| **Personal Connectors (MCP)** | Context tijdens het bouwen | Notion (content drafts), Linear (taken) |
| **API Integraties** | Custom koppelingen | Meta Ads API, LinkedIn API, PiAPI (visuals) |

## Shared Connectors Setup

### 1. Supabase (Verplicht)

De Recruitin database is al ingericht. Koppel Lovable aan dezelfde Supabase instance:

1. Open je Lovable project
2. Ga naar **Settings > Connectors > Shared Connectors**
3. Klik op **Supabase**
4. Voer in:
   - Project URL: `https://vaiikkhaulkqdknwvroj.supabase.co`
   - Anon Key: (uit je Supabase Dashboard > Settings > Data API)

De app heeft nu toegang tot alle Recruitin tabellen:
- `clients` — Klantgegevens
- `campaigns` — Actieve campagnes
- `weekly_metrics` — KPI data met automatische CTR/CPC/CPA/CPH berekening
- `content_log` — Gegenereerde content
- `market_intelligence` — Vacature-volumes, ICP signals, concurrent activiteit
- `icp_scores` — Prospect scoring (A/B/C classificatie)
- `winning_strategies` — Best presterende combinaties (materialized view)

### 2. Lovable AI (Aanbevolen)

Gebruik Lovable AI voor:
- Automatische UI-generatie op basis van je Supabase schema
- Slimme form-builders voor data-invoer
- AI-powered zoekfuncties in je recruitment data

### 3. Firecrawl (Optioneel)

Gebruik voor market intelligence scraping:
- Vacature-pagina's van concurrenten
- Indeed.nl / Monsterboard.nl vacature-volumes
- Bedrijfs career pages van ICP prospects

Setup: **Settings > Connectors > Shared Connectors > Firecrawl**

## Personal Connectors (MCP Servers)

Configureer deze in **Settings > Connectors > Personal Connectors**:

### Notion (Aanbevolen)
Koppel je Notion workspace voor:
- Content drafts lezen en schrijven
- Recruitment News Database als inspiratiebron
- Content kalender synchronisatie

### Linear (Optioneel)
Voor task management:
- Campagne taken aanmaken vanuit Lovable
- Sprint planning voor content cycli

## Recruitin App Templates

### Template 1: Campaign Dashboard

Vraag in Lovable:
```
Bouw een recruitment campaign dashboard met Supabase.
Toon een overzicht van alle actieve campagnes uit de campaigns tabel.
Per campagne: status, kanaal, budget, en de laatste weekly_metrics (CTR, CPC, CPA, CPH).
Gebruik een clean design met groene accenten voor goede KPI's en rode voor slechte.
KPI targets: CTR Meta >1.2%, CTR LinkedIn >0.5%, CPC Meta <€2.50, CPH <€500.
```

### Template 2: Weekly Report Generator

Vraag in Lovable:
```
Maak een weekrapport-pagina die data uit weekly_metrics en market_intelligence combineert.
Toon per actieve campagne: week-over-week vergelijking van impressies, clicks, sollicitaties, hires.
Voeg een sectie toe met market intelligence: top vacature-keywords en concurrent activiteit.
Highlight anomalieën: CTR daling >30%, CPC stijging >25%, 0 sollicitaties bij actieve spend.
```

### Template 3: Candidate Landing Page

Vraag in Lovable:
```
Bouw een vacature landing page template.
Haal de vacature-info op uit campaigns tabel (target_role, target_industry).
Haal de brand voice op uit client_brand_voices.
Voeg een sollicitatieformulier toe dat naar Supabase schrijft.
Gebruik de visual style: professioneel, energiek, met ruimte voor hero-image.
Mobile-first design, max 3 scroll-secties.
```

### Template 4: ICP Prospect Scorer

Vraag in Lovable:
```
Maak een ICP scoring tool.
Formulier met 7 velden: bedrijfsgrootte, sector, regio, recruitment type, budget range, decision maker role, urgentie.
Bereken automatisch de ICP score (max 28.5 punten) en classificatie (A/B/C).
Sla het resultaat op in de icp_scores tabel.
Toon bestaande prospects uit icp_scores gesorteerd op score.
```

### Template 5: Content Calendar

Vraag in Lovable:
```
Bouw een content kalender app.
Lees content_log en campaigns uit Supabase.
Toon een weekoverzicht met geplande en gepubliceerde posts.
Kleurcode per content type en fase (Foundation/Authority/Engagement/Conversie).
Drag-and-drop om posts te verplaatsen.
Klik op een post om de content_body en visual_prompt te zien.
```

## API Integraties voor Lovable Apps

### Meta Ads API (Authenticated)

Voor automatische campagne data import:
```
Integreer de Meta Marketing API.
Base URL: https://graph.facebook.com/v19.0
Auth: Bearer token via Edge Function
Endpoints:
- GET /{ad_account_id}/campaigns — actieve campagnes
- GET /{campaign_id}/insights — impressies, clicks, spend, actions
Sla resultaten op in weekly_metrics tabel.
```

Vereist: Meta Business App credentials als Cloud Secret.

### LinkedIn API (Authenticated)

Voor LinkedIn post analytics:
```
Integreer de LinkedIn Marketing API.
Auth: OAuth 2.0 Bearer token via Edge Function
Endpoints:
- GET /organizationShares — geposte content
- GET /organizationalEntityShareStatistics — impressies, clicks, engagement
Sla resultaten op in weekly_metrics tabel voor LinkedIn campagnes.
```

### PiAPI / Midjourney (Authenticated)

Voor automatische visual generatie:
```
Integreer de PiAPI API voor beeldgeneratie.
Base URL: https://api.piapi.ai/v1
Auth: API key header
Endpoint: POST /imagine — genereer beeld op basis van visual prompt
Input: visual_prompt JSONB uit content_log
Output: beeld-URL opslaan in content_log.visual_prompt.generated_url
```

## Lovable Cloud & Edge Functions

Voor authenticated API calls gebruikt Lovable automatisch Edge Functions via Lovable Cloud:

1. **Enable Cloud** in je Lovable project
2. **Secrets toevoegen** via Cloud > Secrets:
   - `META_ACCESS_TOKEN` — Meta Ads API token
   - `LINKEDIN_ACCESS_TOKEN` — LinkedIn API token
   - `PIAPI_KEY` — PiAPI API key
3. Lovable genereert automatisch Edge Functions die credentials veilig houden

## Best Practices

1. **Start altijd met Supabase connector** — dit is de ruggengraat
2. **Gebruik Lovable AI** om snel UI te genereren op basis van je tabelstructuur
3. **Bouw mobile-first** — recruiters en hiring managers gebruiken vaak hun telefoon
4. **Houd het simpel** — één app per functie (dashboard, landing page, scoring tool)
5. **Gebruik Firecrawl** voor market intelligence in plaats van custom scrapers
6. **Sla API keys op als Secrets** — nooit hardcoden in de app
