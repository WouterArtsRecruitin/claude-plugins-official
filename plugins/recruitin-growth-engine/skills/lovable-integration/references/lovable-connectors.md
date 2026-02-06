# Lovable Connectors Reference

## Shared Connectors (voor deployed apps)

### Supabase
- **Status:** Verplicht
- **Setup:** Settings > Connectors > Shared Connectors > Supabase
- **Gebruik:** Database access voor alle Recruitin tabellen
- **Docs:** https://docs.lovable.dev/integrations/supabase

### Lovable Cloud
- **Status:** Verplicht voor API integraties
- **Setup:** Settings > Cloud
- **Gebruik:** Edge Functions, Secrets, backend hosting
- **Docs:** https://docs.lovable.dev/integrations/cloud

### Lovable AI
- **Status:** Aanbevolen
- **Setup:** Settings > Connectors > Shared Connectors > Lovable AI
- **Gebruik:** AI-powered features in je apps
- **Docs:** https://docs.lovable.dev/integrations/ai

### Stripe
- **Status:** Optioneel
- **Setup:** Settings > Connectors > Shared Connectors > Stripe
- **Gebruik:** Facturatie voor recruitment diensten
- **Docs:** https://docs.lovable.dev/integrations/stripe

### Firecrawl
- **Status:** Optioneel
- **Setup:** Settings > Connectors > Shared Connectors > Firecrawl
- **Gebruik:** Web scraping voor market intelligence
- **Docs:** https://docs.lovable.dev/integrations/firecrawl

### ElevenLabs
- **Status:** Optioneel
- **Setup:** Settings > Connectors > Shared Connectors > ElevenLabs
- **Gebruik:** Voice-overs voor recruitment video's
- **Docs:** https://docs.lovable.dev/integrations/eleven-labs

### Perplexity
- **Status:** Optioneel
- **Setup:** Settings > Connectors > Shared Connectors > Perplexity
- **Gebruik:** Arbeidsmarkt research, sector analyses
- **Docs:** https://docs.lovable.dev/integrations/perplexity

## Personal Connectors / MCP Servers (voor context tijdens bouwen)

### Notion
- **Gebruik:** Content drafts, recruitment news, content kalender
- **Setup:** Settings > Connectors > Personal Connectors > Notion
- **Koppel:** Je Recruitin Notion workspace

### Linear
- **Gebruik:** Task tracking, sprint planning
- **Setup:** Settings > Connectors > Personal Connectors > Linear

### Miro
- **Gebruik:** Campaign flowcharts, customer journey maps
- **Setup:** Settings > Connectors > Personal Connectors > Miro

### Custom MCP Server
- **Gebruik:** Eigen tools koppelen
- **Setup:** Settings > Connectors > Personal Connectors > Custom
- **URL:** Eigen MCP server URL invoeren

## API Integraties (via Edge Functions)

### Meta Marketing API
- **Base URL:** `https://graph.facebook.com/v19.0`
- **Auth:** Bearer token
- **Secret:** `META_ACCESS_TOKEN`
- **Endpoints:**
  - `GET /{ad_account_id}/campaigns` — campagne overzicht
  - `GET /{campaign_id}/insights?fields=impressions,clicks,spend,actions` — metrics
  - `GET /{ad_account_id}/ads?fields=creative,status` — ad creatives
- **Data mapping:**
  - impressions → `weekly_metrics.impressions`
  - clicks → `weekly_metrics.clicks`
  - spend → `weekly_metrics.spend`
  - actions[type=lead] → `weekly_metrics.applications`

### LinkedIn Marketing API
- **Base URL:** `https://api.linkedin.com/v2`
- **Auth:** OAuth 2.0 Bearer token
- **Secret:** `LINKEDIN_ACCESS_TOKEN`
- **Endpoints:**
  - `GET /organizationShares` — geposte content
  - `GET /organizationalEntityShareStatistics` — analytics
- **Data mapping:**
  - impressionCount → `weekly_metrics.impressions`
  - clickCount → `weekly_metrics.clicks`
  - engagement → berekend als (likes + comments + shares) / impressions

### PiAPI (Beeldgeneratie)
- **Base URL:** `https://api.piapi.ai/v1`
- **Auth:** API key header `x-api-key`
- **Secret:** `PIAPI_KEY`
- **Endpoint:** `POST /imagine`
- **Input:** visual_prompt uit content_log
- **Output:** gegenereerde beeld-URL

### Indeed Publisher API (Market Intelligence)
- **Base URL:** `https://api.indeed.com/ads/apisearch`
- **Auth:** Publisher ID
- **Secret:** `INDEED_PUBLISHER_ID`
- **Gebruik:** Vacature-volumes per keyword/regio
- **Data mapping:** results → `market_intelligence` (data_type: 'market_trend')
