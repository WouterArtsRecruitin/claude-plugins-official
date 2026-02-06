---
name: recruitin-onboard
description: Onboard een nieuwe client — verrijk data, maak database entries, analyseer employer brand, genereer eerste campagne
allowed-tools: mcp, supabase, clay, pipedrive, linkedin, playwright, notion, slack, Read, Write, Bash, Grep, Glob
---

# Nieuwe Client Onboarding

Onboard een nieuwe client in het volledige Recruitin ecosysteem.

Gebruik: `/recruitin-onboard <client-naam>`

## Stap 1: Data Verrijking
Gebruik **Clay** MCP (indien gekoppeld) of vraag handmatig:
- Bedrijfsnaam, sector, grootte (FTE)
- Locatie(s)
- Key contacts (HR Director, Hiring Manager)
- Website en career page URL

## Stap 2: Pipedrive Check
Gebruik **Pipedrive** MCP (indien gekoppeld):
- Zoek bestaande deal op bedrijfsnaam
- Haal op: budget, recruitment type, contactpersoon, deal stage

## Stap 3: Database Entries Aanmaken
Gebruik **Supabase** MCP:

```sql
INSERT INTO clients (name, industry, brand_voice, target_audience)
VALUES ('<naam>', '<sector>', '{}', '{}');
```

Vraag de gebruiker om:
- Tone-of-voice voorkeuren (formeel/semi-formeel/informeel)
- USP's van de werkgever (3-5 punten)
- Doelgroep beschrijving
- Woorden die ze WEL en NIET willen gebruiken

```sql
INSERT INTO client_brand_voices (client_id, voice_name, formality, personality_traits, vocabulary_preferences, language)
VALUES (...);
```

## Stap 4: Employer Brand Analyse
Gebruik **Playwright** om te scrapen:
- Career page van de client → analyseer tone, visuals, USP's
- LinkedIn bedrijfspagina → volgers, post frequentie, engagement

Gebruik **LinkedIn** MCP (indien gekoppeld):
- Bedrijfsprofiel ophalen
- Recente posts analyseren

## Stap 5: Eerste Campagne Aanmaken
Gebruik **Supabase** MCP:
```sql
INSERT INTO campaigns (client_id, campaign_type, channel, status, target_role, target_industry)
VALUES (...);
```

Gebruik de **Campaign Strategy** skill om te genereren:
- 3 ad-varianten (benefit / pain-point / social proof)
- Visual prompts per variant
- Budget advies op basis van branche benchmarks

## Stap 6: Documentatie
- **Notion**: Maak client briefing pagina aan
- **Supabase**: Log eerste content naar content_log

## Stap 7: Team Notificatie
- **Slack**: Post in #client-updates: "Nieuwe client onboarded: <naam> — <sector> — Budget: €X — Eerste campagne aangemaakt"

Presenteer de complete onboarding samenvatting aan de gebruiker.
