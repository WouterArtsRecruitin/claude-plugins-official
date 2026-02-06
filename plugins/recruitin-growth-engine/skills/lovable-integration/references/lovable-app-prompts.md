# Lovable App Prompts voor Recruitin

Kopieer deze prompts direct in Lovable om apps te bouwen.

---

## 1. Recruitin Campaign Dashboard

```
Bouw een recruitment campaign dashboard.

Database: Supabase (al gekoppeld)
Tabellen: campaigns, weekly_metrics, clients

Homepage:
- Overzichtskaarten: totaal actieve campagnes, totale spend deze maand, gemiddelde CPH, gemiddelde quality score
- Tabel met alle actieve campagnes: naam client, kanaal (linkedin/meta), status, budget, start_date
- Klik op een campagne voor detail view

Detail view per campagne:
- Lijngrafieken: impressies, clicks, sollicitaties per week (uit weekly_metrics)
- KPI kaarten met kleurcode:
  - CTR: groen als >1.2% (meta) of >0.5% (linkedin), rood als eronder
  - CPC: groen als <€2.50 (meta) of <€6.00 (linkedin), rood als erboven
  - CPH: groen als <€500, geel als €500-800, rood als >€800
  - Quality Score: groen als >60%, rood als eronder
- Week-over-week vergelijking met pijltjes (omhoog/omlaag)

Anomalie banner:
- Rode waarschuwing als CTR daalt >30% vs gemiddelde
- Oranje waarschuwing als CPC stijgt >25%
- Rode alert als 0 sollicitaties bij actieve spend >7 dagen

Design: Clean, professioneel. Recruitin groen als accent kleur. Dark mode support.
Mobile responsive.
```

---

## 2. Vacature Landing Page Builder

```
Bouw een vacature landing page generator.

Database: Supabase (al gekoppeld)
Tabellen: campaigns, clients, client_brand_voices

Stap 1 — Selecteer campagne:
- Dropdown met actieve performance campagnes uit campaigns tabel
- Auto-fill: target_role, target_industry, client naam
- Laad brand voice uit client_brand_voices

Stap 2 — Landing page editor:
- Hero sectie: functietitel, locatie, 1-zin pitch
- USP sectie: 3-4 voordelen (iconen + korte tekst)
- Over het bedrijf: korte beschrijving
- Sollicitatieformulier: naam, email, telefoon, CV upload, motivatie (optioneel)

Stap 3 — Preview & Publiceer:
- Mobile preview naast desktop preview
- Publiceer als standalone pagina met unieke URL
- Sollicitaties worden opgeslagen in Supabase

Design: Mobile-first, max 3 scroll-secties, snelle laadtijd.
Geen afleiding, focus op conversie.
Formulier submit telt als application in weekly_metrics.
```

---

## 3. Market Intelligence Dashboard

```
Bouw een market intelligence dashboard.

Database: Supabase (al gekoppeld)
Tabellen: market_intelligence, icp_scores

Sectie 1 — Vacature Markt:
- Filter op: keyword, regio, week
- Bar chart: vacature-volumes per keyword (uit market_intelligence waar data_type = 'market_trend')
- Trend lijn: week-over-week verandering
- Kleurcode risk_level: HIGH = rood, MEDIUM = oranje, LOW = groen

Sectie 2 — ICP Monitor:
- Tabel met bedrijven uit market_intelligence (data_type = 'icp_signal')
- Kolommen: bedrijfsnaam, regio, open_positions, relevance_score
- Sorteer op relevance_score (hoog naar laag)
- Klik voor detail: alle signalen van dat bedrijf

Sectie 3 — Concurrent Activiteit:
- Tabel met concurrenten uit market_intelligence (data_type = 'competitor_activity')
- Kolommen: concurrent naam, posts_this_week, risico niveau
- Highlight concurrenten met HOOG risico

Sectie 4 — ICP Scores:
- Tabel uit icp_scores
- Kleurcode: A-prospects = groen, B = geel, C = grijs
- Sorteer op icp_score (hoog naar laag)
- Klik om prospect details te zien

Design: Data-heavy maar overzichtelijk. Tabs voor secties. Filter sidebar.
```

---

## 4. ICP Scoring Tool

```
Bouw een ICP prospect scoring tool.

Database: Supabase (al gekoppeld)
Tabel: icp_scores

Formulier met 7 velden:
1. Bedrijfsnaam (text)
2. Bedrijfsgrootte FTE (number) — scoring: >1000=5, 500-1000=4, 200-500=3, 50-200=2, <50=1
3. Sector (dropdown: manufacturing, automotive, renewable energy, industrial services, construction, IT, logistics, food) — scoring: manufacturing/automotive=4, overig=2
4. Regio (dropdown: gelderland, overijssel, noord-brabant, anders) — scoring: gelderland=4, overijssel/brabant=3, anders=1.5
5. Recruitment Type (dropdown: RPO, w&s, interim, project) — scoring: RPO=4.5, w&s=3, interim=2, project=1.5
6. Budget Range (dropdown: €100k+, €50k-100k, €25k-50k, <€25k) — scoring: 100k+=5, 50-100=3.5, 25-50=2, <25=1
7. Decision Maker Role (dropdown: HR Director, Head of HR, HR Manager, Recruiter, Anders) — scoring: Director=3, Head=2.5, Manager=2, Recruiter=1.5, Anders=1
8. Urgentie (dropdown: urgent, normaal, langzaam) — scoring: urgent=3, normaal=2, langzaam=1

Automatisch berekenen:
- icp_score = som van alle scores (max 28.5)
- score_percentage = (icp_score / 28.5) * 100
- classification: A (>=22), B (14-22), C (7-14), no_match (<7)
- icp_match = classification in (A, B)

Na submit: opslaan in icp_scores tabel.

Onder het formulier: tabel met alle bestaande prospects, sorteerbaar.
Groen badge voor A, geel voor B, grijs voor C.
```

---

## 5. Content Planner & Calendar

```
Bouw een content planning kalender.

Database: Supabase (al gekoppeld)
Tabellen: content_log, campaigns

Kalender view:
- Maand/week toggle
- Posts als kaartjes op de kalender
- Kleurcode per content_type: linkedin_post = blauw, meta_ad = oranje, article = paars
- Kleurcode per fase: Foundation = lichtblauw, Authority = donkerblauw, Engagement = groen, Conversie = goud

Klik op een dag:
- Nieuwe content aanmaken:
  - Selecteer campagne (dropdown uit campaigns)
  - Content type (linkedin_post, meta_ad, carousel, article, newsletter)
  - Tone of voice (data-driven, contrarian, how-to, behind-scenes)
  - Content body (rich text editor, max 1300 tekens voor LinkedIn)
  - Visual prompt (structured form: platform, format, stijl, onderwerp, kleuren, sfeer)
  - Fase (foundation, authority, engagement, conversie)
  - Publicatiedatum

Klik op bestaande post:
- Bekijk content_body en visual_prompt
- Edit of verwijder
- Status: draft / scheduled / published

Sidebar:
- Aankomende posts deze week
- Content mix check: evenwichtige verdeling van types en tonen
- Week nummer in de 12-weken cyclus

Design: Clean, Notion-achtig. Drag-and-drop om posts te verplaatsen.
```

---

## 6. Weekly Report Generator

```
Bouw een automatische weekrapport generator.

Database: Supabase (al gekoppeld)
Tabellen: weekly_metrics, campaigns, clients, market_intelligence

Input: Selecteer week nummer en jaar

Output — rapport met 4 secties:

Sectie 1: KPI Overzicht
- Per actieve campagne: impressies, clicks, sollicitaties, hires, spend
- Automatisch berekend: CTR, CPC, CPA, CPH, Quality Score
- Week-over-week vergelijking (pijltjes + percentage)
- Benchmark vergelijking per branche (uit KPI targets)

Sectie 2: Anomalieën & Acties
- Automatisch detecteren:
  - CTR daling >30% → "Creatieve vermoeidheid — nieuwe varianten nodig"
  - CPC stijging >25% → "Doelgroep verzadiging — targeting aanpassen"
  - Quality Score <60% → "Targeting te breed — verfijnen"
  - 0 sollicitaties + actieve spend → "PAUZEER campagne"

Sectie 3: Market Intelligence
- Top 5 keywords met hoogste vacature-volumes deze week
- ICP bedrijven met nieuwe hiring signals
- Concurrent activiteit samenvatting

Sectie 4: Aanbevelingen
- Budget herverdeling suggesties (meer naar best presterende, minder naar underperformers)
- Content suggesties voor volgende week

Export: Download als PDF of kopieer als tekst.
```
