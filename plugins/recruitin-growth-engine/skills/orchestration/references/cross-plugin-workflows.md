# Cross-Plugin Workflows — Technische Reference

## MCP Server Capabilities per Workflow

### Welke MCP server doet wat?

| MCP Server | Kan lezen | Kan schrijven | Trigger |
|------------|-----------|---------------|---------|
| **Supabase** | Alle tabellen, views | INSERT/UPDATE/DELETE | Altijd beschikbaar |
| **Playwright** | Webpagina's scrapen | — | `/recruitin-monday`, `/recruitin-prospect` |
| **Clay** | Bedrijfsdata, contacten | — | `/recruitin-prospect`, `/recruitin-onboard` |
| **Pipedrive** | Deals, contacten, pipelines | Deals aanmaken/updaten | `/recruitin-prospect`, `/recruitin-onboard` |
| **LinkedIn** | Profielen, bedrijfspagina's | — | `/recruitin-prospect`, `/recruitin-onboard` |
| **Notion** | Pages, databases | Pages aanmaken/updaten | `/recruitin-content`, `/recruitin-monday` |
| **Figma** | Design tokens, componenten | — | `/recruitin-content` |
| **Slack** | Kanalen, berichten | Berichten posten | Alle workflows |
| **PostHog** | Events, funnels, cohorts | — | `/recruitin-monday`, `/recruitin-optimize` |
| **Stripe** | Klanten, facturen | — | `/recruitin-lovable` |
| **Ollama** | — | — | Privacy-gevoelige taken |
| **Context7** | Actuele API docs | — | Development taken |
| **GitHub** | Repos, issues, PRs | Issues, PRs | Plugin development |

## Wekelijkse Routine — Volledige Mapping

| Dag | Command | MCP Servers | Output |
|-----|---------|-------------|--------|
| **Maandag** | `/recruitin-monday` | Playwright, Supabase, PostHog, Slack, Notion | Weekrapport + data update |
| **Dinsdag** | `/recruitin-content` | Supabase, Notion, Figma, Slack | 2 LinkedIn posts + ads |
| **Woensdag** | `/recruitin-lovable dashboard` | Supabase | Dashboard prompt voor Lovable |
| **Donderdag** | `/recruitin-prospect <naam>` | Clay, Playwright, LinkedIn, Pipedrive, Supabase, Slack | ICP score + deal |
| **Vrijdag** | `/recruitin-optimize` | Supabase, PostHog, Slack, Notion | Optimalisatie rapport |

## Fallback Gedrag

Als een MCP server niet gekoppeld is, gebruik fallbacks:

| MCP Server | Fallback |
|------------|----------|
| Clay | Playwright scraping + handmatige input |
| Pipedrive | Supabase-only (sla prospect data daar op) |
| LinkedIn | Playwright scraping van publieke profielen |
| Notion | Supabase content_log + lokale markdown bestanden |
| Figma | Handmatige brand kleuren uit client_brand_voices |
| Slack | Console output + Notion notificatie |
| PostHog | Supabase weekly_metrics only |
| Ollama | Claude (cloud) als default |

## Error Handling

1. **MCP server niet bereikbaar**: Log waarschuwing, gebruik fallback, ga door
2. **Supabase niet bereikbaar**: STOP — Supabase is verplicht voor alle workflows
3. **Rate limiting**: Wacht 60 seconden, retry 3x, daarna fallback
4. **Scraping geblokkeerd**: Log URL, markeer als "manual_check_needed" in market_intelligence

## Data Integriteit Regels

1. Geen duplicate entries in market_intelligence voor dezelfde week/keyword/regio
2. Geen duplicate ICP scores voor hetzelfde bedrijf (UPDATE bestaande)
3. Content_log entries zijn immutable (alleen INSERT, nooit UPDATE)
4. Winning_strategies wordt alleen gerefresht na nieuwe weekly_metrics data
5. Client brand_voice wordt nooit automatisch overschreven — altijd user confirmatie
