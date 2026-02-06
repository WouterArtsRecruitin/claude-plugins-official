---
name: recruitin-content
description: Content creatie cyclus — genereer LinkedIn posts en Meta ads op basis van data, sla op in Notion, post ter review
allowed-tools: mcp, supabase, notion, figma, slack, Read, Write, Bash, Grep, Glob
---

# Content Creatie Cyclus

Genereer data-gedreven content voor deze week.

## Stap 1: Context Ophalen
Gebruik **Supabase** MCP om te laden:
- `winning_strategies` — best presterende tone/type/kanaal combinaties
- `client_brand_voices` — tone-of-voice regels
- `content_log` — recente content (voorkom herhaling)
- `market_intelligence` — actuele vacature-volumes en concurrent activiteit
- `campaigns` — actieve campagnes en hun fase in de 12-weken cyclus

## Stap 2: Fase Bepalen
Bereken de huidige week in de 12-weken cyclus:
- Week 1-3: Foundation (data, trends, insights)
- Week 4-6: Authority (case studies, contrarian takes)
- Week 7-9: Engagement (polls, behind-the-scenes)
- Week 10-12: Conversie (lead magnets, CTA's)

Selecteer de juiste content stijlen voor deze fase.

## Stap 3: Content Genereren
Gebruik de **Campaign Strategy** skill om te produceren:

**Voor Recruitin (Authority):**
- 2 LinkedIn posts (mix van stijlen passend bij de fase)
- 1 visual prompt per post
- Gebruik actuele market intelligence data in de posts

**Voor actieve client campagnes (Performance):**
- 3 ad-varianten per vacature (benefit/pain-point/social proof)
- Visual prompts per variant

## Stap 4: Brand Consistency
Gebruik **Figma** MCP (indien gekoppeld):
- Haal brand kleuren en tokens op
- Verwerk in visual prompts

## Stap 5: Opslaan & Review
- **Notion**: Sla drafts op in Content Drafts database met status "Draft"
- **Slack**: Post in #content-review: "X nieuwe posts klaar voor review"
- **Supabase**: Na goedkeuring → INSERT in content_log

## Stap 6: Kwaliteitscheck
Controleer ELKE uiting op:
- ✅ Past bij de geregistreerde tone-of-voice
- ✅ Bevat minimaal 1 specifiek datapunt
- ✅ Duidelijke CTA passend bij campagnefase
- ✅ Visual prompt is compleet (platform, format, stijl, sfeer, kleuren)
- ✅ Geen generieke filler-zinnen
- ✅ Nederlands klinkt natuurlijk

Presenteer alle content aan de gebruiker ter goedkeuring.
