---
name: orchestration
description: This skill should be used when the user wants to "run a full workflow", "connect plugins", "automate the weekly routine", "run the Monday cycle", "do the full campaign pipeline", "sync all systems", "run end-to-end", or needs guidance on how different MCP servers and skills work together as one system.
version: 0.1.0
---

# Orchestration — Multi-Plugin Samenwerking

Dit is de dirigent van het Recruitin Growth Engine ecosysteem. Het verbindt alle MCP servers, skills en commands tot geautomatiseerde workflows.

## Plugin Ecosysteem Overzicht

```
┌─────────────────────────────────────────────────────────────────┐
│                    RECRUITIN GROWTH ENGINE                       │
│                                                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌────────────────────┐    │
│  │  Campaign     │  │  Data        │  │  Continuous        │    │
│  │  Strategy     │  │  Memory      │  │  Optimization      │    │
│  └──────┬───────┘  └──────┬───────┘  └────────┬───────────┘    │
│         │                 │                    │                │
│  ┌──────┴─────────────────┴────────────────────┴───────────┐   │
│  │                   ORCHESTRATION                          │   │
│  │            (workflows + cross-plugin routing)            │   │
│  └──────┬──────────┬──────────┬──────────┬────────────┬────┘   │
│         │          │          │          │            │         │
│  ┌──────┴───┐ ┌────┴───┐ ┌───┴────┐ ┌──┴──────┐ ┌──┴─────┐  │
│  │Lovable   │ │Prospect│ │Content │ │Analytics│ │Scraping│   │
│  │Integratie│ │Pipeline│ │Hub     │ │& Report │ │Engine  │   │
│  └──────────┘ └────────┘ └────────┘ └─────────┘ └────────┘   │
│         │          │          │          │            │         │
└─────────┼──────────┼──────────┼──────────┼────────────┼────────┘
          │          │          │          │            │
    ┌─────┴──┐ ┌────┴────┐ ┌──┴───┐ ┌───┴────┐ ┌────┴──────┐
    │Supabase│ │Pipedrive│ │Notion│ │PostHog │ │Playwright │
    │Stripe  │ │Clay     │ │Figma │ │Supabase│ │Firecrawl  │
    │Lovable │ │LinkedIn │ │Slack │ │Context7│ │Indeed API │
    └────────┘ └─────────┘ └──────┘ └────────┘ └───────────┘
```

## De 5 Sub-Skills en Hun MCP Servers

### 1. Prospect Pipeline (Clay + Pipedrive + LinkedIn)
Vindt, verrijkt en kwalificeert prospects.

**Flow:**
1. Clay → Verrijk bedrijfsdata (grootte, sector, hiring signals)
2. ICP scoring → Bereken score in Supabase (7 criteria, max 28.5)
3. Pipedrive → Maak deal aan voor A-prospects
4. LinkedIn → Zoek decision makers, bereid outreach voor
5. Slack → Notify team bij nieuwe A-prospect

### 2. Content Hub (Notion + Figma + Slack)
Beheert content creatie van idee tot publicatie.

**Flow:**
1. Supabase → Check winning_strategies + content_log (geen herhaling)
2. Campaign Strategy skill → Genereer content + visual prompt
3. Notion → Sla draft op in Content Drafts database
4. Figma → Haal brand tokens op voor visual consistency
5. Slack → Post draft ter review in #content-review kanaal
6. Na goedkeuring → Supabase content_log + publiceer

### 3. Analytics & Reporting (Supabase + PostHog + Google Ads)
Verzamelt en analyseert alle campagnedata.

**Flow:**
1. PostHog → Haal landing page conversie data op
2. Supabase → Importeer weekly_metrics
3. Continuous Optimization skill → Detecteer anomalieën
4. Supabase → Refresh winning_strategies materialized view
5. Slack → Post weekrapport in #campagne-updates

### 4. Scraping Engine (Playwright + Context7)
Haalt market intelligence op.

**Flow:**
1. Playwright → Scrape Indeed.nl voor vacature-volumes per keyword/regio
2. Playwright → Scrape concurrent blogs voor content activiteit
3. Playwright → Check ICP bedrijf career pages voor hiring signals
4. Supabase → Sla alles op in market_intelligence tabel
5. Context7 → Haal actuele API docs op indien nodig

### 5. Lovable App Builder (Supabase + Stripe + Lovable)
Bouwt en deployt recruitment apps.

**Flow:**
1. Supabase → Lees tabelstructuur
2. Lovable Integration skill → Genereer app prompt
3. Stripe → Configureer betaling indien nodig
4. Supabase → Koppel database aan app

---

## Geautomatiseerde Workflows

### Workflow 1: Maandag Data Cyclus
Trigger: `/recruitin-monday`

```
1. [Playwright]  → Scrape Indeed.nl + Monsterboard voor vacature-volumes
2. [Playwright]  → Check concurrent blogs voor nieuwe posts
3. [Playwright]  → Scan ICP career pages voor hiring signals
4. [Supabase]    → Importeer alles naar market_intelligence
5. [Supabase]    → Importeer weekly_metrics (handmatig of via Meta/LinkedIn API)
6. [Supabase]    → REFRESH MATERIALIZED VIEW winning_strategies
7. [PostHog]     → Haal landing page analytics op
8. [Data Memory] → Genereer weekrapport met anomalie detectie
9. [Slack]       → Post rapport in #campagne-updates
10. [Notion]     → Update content kalender met insights
```

### Workflow 2: Content Creatie Cyclus
Trigger: `/recruitin-content`

```
1. [Supabase]           → Laad winning_strategies + brand voice + content_log
2. [Supabase]           → Check market_intelligence voor actuele data
3. [Supabase]           → Bepaal fase in 12-weken cyclus
4. [Campaign Strategy]  → Genereer 2 LinkedIn posts + visual prompts
5. [Notion]             → Sla drafts op in Content Drafts database
6. [Figma]              → Haal brand kleuren/tokens op voor visual prompt
7. [Slack]              → Post ter review: "2 nieuwe posts klaar voor review"
8. [Supabase]           → Log naar content_log na goedkeuring
```

### Workflow 3: Nieuwe Client Onboarding
Trigger: `/recruitin-onboard <client-naam>`

```
1. [Clay]       → Verrijk bedrijfsdata (grootte, sector, locatie, key people)
2. [Pipedrive]  → Haal deal info op (budget, type, contactpersoon)
3. [Supabase]   → INSERT INTO clients + client_brand_voices
4. [Supabase]   → INSERT INTO campaigns (eerste campagne aanmaken)
5. [LinkedIn]   → Zoek bedrijfspagina, analyseer employer brand
6. [Playwright] → Scrape huidige career page voor tone analysis
7. [Campaign Strategy] → Genereer eerste 3 ad-varianten
8. [Notion]     → Maak client workspace aan met briefing
9. [Slack]      → Notify team: "Nieuwe client onboarded: <naam>"
```

### Workflow 4: Prospect Enrichment
Trigger: `/recruitin-prospect <bedrijfsnaam>`

```
1. [Clay]       → Verrijk: bedrijfsgrootte, sector, regio, key contacts
2. [Playwright] → Scrape career page voor open vacatures
3. [LinkedIn]   → Zoek HR Director / Talent Acquisition Manager
4. [Supabase]   → Bereken ICP score → INSERT INTO icp_scores
5. [Pipedrive]  → Maak deal aan als A/B-prospect
6. [Slack]      → Notify: "Nieuwe prospect: <naam> — Score: X/28.5 (A/B/C)"
```

### Workflow 5: Optimalisatie Sprint
Trigger: `/recruitin-optimize-sprint`

```
1. [Supabase]              → Laad alle actieve campagnes + weekly_metrics
2. [Continuous Optimization] → Identificeer underperformers (CPH >€800, CTR <0.5%)
3. [Continuous Optimization] → Bepaal winning strategies per branche
4. [PostHog]               → Analyseer landing page funnels
5. [Campaign Strategy]     → Genereer nieuwe varianten voor underperformers
6. [Supabase]              → Update campagne status, log nieuwe varianten
7. [Notion]                → Update optimalisatie log
8. [Slack]                 → Post: "Optimalisatie sprint compleet — X campagnes aangepast"
```

### Workflow 6: Weekly Report + Client Update
Trigger: `/recruitin-weekly-report <client-naam>`

```
1. [Supabase]   → Haal weekly_metrics voor deze client
2. [PostHog]    → Landing page performance
3. [Data Memory] → Genereer rapport met benchmarks
4. [Notion]     → Sla rapport op als pagina
5. [Slack]      → Post rapport link in #client-updates
```

---

## Cross-Plugin Data Flow

### Supabase als Central Hub
Alle plugins schrijven naar en lezen van Supabase:

| Plugin | Schrijft naar | Leest van |
|--------|--------------|-----------|
| Playwright | market_intelligence | — |
| Clay | icp_scores | clients |
| Pipedrive | — | icp_scores, clients |
| PostHog | weekly_metrics (landing pages) | campaigns |
| LinkedIn | — | icp_scores, client_brand_voices |
| Notion | — | content_log, campaigns |
| Campaign Strategy | content_log | winning_strategies, market_intelligence |
| Continuous Optimization | — | weekly_metrics, winning_strategies |

### Slack als Notification Hub
Alle workflows posten updates naar Slack:

| Kanaal | Berichten |
|--------|-----------|
| #campagne-updates | Weekrapporten, anomalieën, optimalisatie resultaten |
| #content-review | Nieuwe content ter goedkeuring |
| #prospects | Nieuwe A-prospects, ICP scores |
| #client-updates | Client rapporten, onboarding meldingen |

### Notion als Content Hub
Alle content-gerelateerde data gaat via Notion:

| Database | Inhoud |
|----------|--------|
| Content Drafts | LinkedIn posts, Meta ads, artikelen |
| Content Calendar | Planning per week, per fase |
| Client Briefings | Brand voice, USPs, doelgroepen |
| Optimalisatie Log | Wat werkte, wat niet, waarom |

---

## Prioriteit van Implementatie

| Fase | Workflow | Benodigde MCP Servers |
|------|----------|----------------------|
| **Week 1** | Maandag Data Cyclus | Supabase, Playwright |
| **Week 1** | Content Creatie | Supabase, Notion, Slack |
| **Week 2** | Weekly Report | Supabase, Slack, Notion |
| **Week 2** | Optimalisatie Sprint | Supabase, PostHog |
| **Week 3** | Prospect Enrichment | Clay, Pipedrive, LinkedIn |
| **Week 3** | Client Onboarding | Clay, Pipedrive, Supabase, LinkedIn |
| **Week 4** | Lovable Apps | Supabase, Stripe |
