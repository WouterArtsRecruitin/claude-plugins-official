---
name: recruitin-lovable
description: Genereer een Lovable app prompt voor een recruitment tool — dashboard, landing page, scoring tool, of content planner
allowed-tools: mcp, supabase, Read, Write, Bash, Grep, Glob
---

# Lovable App Generator

Genereer een kant-en-klare Lovable prompt voor een recruitment app.

Gebruik: `/recruitin-lovable <app-type>`

App types:
- `dashboard` — Campaign performance dashboard
- `landing` — Vacature landing page
- `intelligence` — Market intelligence dashboard
- `scorer` — ICP prospect scoring tool
- `calendar` — Content planning kalender
- `report` — Weekly report generator

## Stap 1: Context Laden
Gebruik **Supabase** MCP:
- Lees tabelstructuur (welke tabellen bestaan)
- Lees voorbeeld data (zodat de prompt specifiek is)
- Haal KPI targets op

## Stap 2: Prompt Genereren
Laad het juiste template uit `skills/lovable-integration/references/lovable-app-prompts.md`

Pas aan op basis van:
- Beschikbare data in Supabase
- Specifieke client wensen
- Actieve campagnes en hun metrics

## Stap 3: Output
Presenteer de volledige Lovable prompt die de gebruiker kan kopiëren en plakken in Lovable.dev.

Voeg toe:
- Supabase connectie instructies
- Benodigde environment variables
- Aanbevolen Lovable connectors voor deze app
