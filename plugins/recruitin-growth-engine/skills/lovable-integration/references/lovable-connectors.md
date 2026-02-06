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
- **Gebruik:** Web scraping voor market intelligence (vacature-pagina's, concurrent blogs)
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

---

## MCP Servers (voor Claude Code / Claude Desktop)

Configureer deze in `.mcp.json` of `claude_desktop_config.json`.

### Playwright (Browser Automatisering)
- **Wat:** Browser automatisering — navigeren, formulieren invullen, scrapen. Gebruikt accessibility tree, geen screenshots nodig.
- **Gebruik voor Recruitin:** Job board scraping, career page monitoring, landing page testen
- **Package:** `@playwright/mcp`
- **Config:**
```json
{
  "playwright": {
    "command": "npx",
    "args": ["-y", "@playwright/mcp@latest"]
  }
}
```

### Ollama (Lokale AI Modellen)
- **Wat:** Lokale AI modellen (Llama, Mistral, Qwen) als MCP tools. Geen data naar externe APIs.
- **Gebruik voor Recruitin:** Privé candidate data verwerken, CV's samenvatten, classificatie zonder cloud
- **Package:** `ollama-mcp`
- **Vereist:** Ollama draaiend op `localhost:11434`
- **Config:**
```json
{
  "ollama": {
    "command": "npx",
    "args": ["-y", "ollama-mcp"],
    "env": {
      "OLLAMA_HOST": "http://localhost:11434"
    }
  }
}
```

### Clay (Lead Enrichment & Prospecting)
- **Wat:** Contact verrijking via 50+ data providers (ZoomInfo, Clearbit, People Data Labs). Lead scoring, enrichment waterfalls.
- **Gebruik voor Recruitin:** ICP bedrijven verrijken, hiring managers vinden, contact data aanvullen
- **Package:** `@clayhq/clay-mcp@latest`
- **Vereist:** Clay account (vanaf $149/maand)
- **Config:**
```json
{
  "clay": {
    "command": "npx",
    "args": ["-y", "@clayhq/clay-mcp@latest"],
    "env": {
      "CLAY_API_KEY": "your_clay_api_key"
    }
  }
}
```

### Slack (Team Communicatie)
- **Wat:** Kanalen lezen/schrijven, berichten zoeken, gebruikers beheren
- **Gebruik voor Recruitin:** Campagne alerts, team updates, candidate notificaties
- **Package:** `@modelcontextprotocol/server-slack`
- **Vereist:** Slack Bot Token + Team ID
- **Config:**
```json
{
  "slack": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-slack"],
    "env": {
      "SLACK_BOT_TOKEN": "xoxb-your-bot-token",
      "SLACK_TEAM_ID": "T0123456789"
    }
  }
}
```

### Google Sheets (Spreadsheet Data)
- **Wat:** Sheets lezen/schrijven — kandidaat trackers, pipeline sheets, rapportages
- **Gebruik voor Recruitin:** Market intelligence sheets, client rapportages, KPI dashboards
- **Package:** `mcp-gsheet` (via uv/Python)
- **Vereist:** Google Cloud Service Account met Sheets API access
- **Config:**
```json
{
  "google-sheets": {
    "command": "uv",
    "args": ["--directory", "/path/to/mcp-gsheet", "run", "mcp-gsheet"],
    "env": {
      "GOOGLE_APPLICATION_CREDENTIALS": "/path/to/service-account-key.json"
    }
  }
}
```

### Pipedrive (Sales CRM)
- **Wat:** Deals, contacten, organisaties, pipelines, activiteiten beheren. 100+ tools.
- **Gebruik voor Recruitin:** Client pipeline, deal tracking, prospect management, activiteiten loggen
- **Package:** `@iamsamuelfraga/mcp-pipedrive`
- **Vereist:** Pipedrive API Token
- **Config:**
```json
{
  "pipedrive": {
    "command": "npx",
    "args": ["-y", "@iamsamuelfraga/mcp-pipedrive"],
    "env": {
      "PIPEDRIVE_API_TOKEN": "your_api_token",
      "PIPEDRIVE_DOMAIN": "recruitin"
    }
  }
}
```

### GitHub (Repository Management)
- **Wat:** Repos, issues, PRs, code search, file operations
- **Gebruik voor Recruitin:** Plugin development, automation scripts, team samenwerking
- **Config (remote — aanbevolen):**
```json
{
  "github": {
    "type": "http",
    "url": "https://api.githubcopilot.com/mcp/"
  }
}
```

### Google Ads (Campagne Data)
- **Wat:** Google Ads data querien via GAQL. Campagne performance, keywords, spend.
- **Gebruik voor Recruitin:** Google Ads recruitment campagnes analyseren
- **Package:** `google_ads_mcp` (Python/uv)
- **Vereist:** Google Ads Developer Token + OAuth credentials
- **Config:**
```json
{
  "google-ads": {
    "command": "uv",
    "args": ["--directory", "/path/to/google_ads_mcp", "run", "google_ads_mcp"],
    "env": {
      "GOOGLE_ADS_DEVELOPER_TOKEN": "your_dev_token",
      "GOOGLE_ADS_CLIENT_ID": "your_client_id",
      "GOOGLE_ADS_CLIENT_SECRET": "your_client_secret",
      "GOOGLE_ADS_REFRESH_TOKEN": "your_refresh_token",
      "GOOGLE_ADS_LOGIN_CUSTOMER_ID": "1234567890"
    }
  }
}
```

### Zapier (8.000+ App Integraties)
- **Wat:** Universele connector — 30.000+ acties over 8.000+ apps. Hosted remote server.
- **Gebruik voor Recruitin:** Alles wat geen eigen MCP heeft — Gmail, Trello, Asana, etc.
- **Setup:** Configureer tools op https://zapier.com/mcp, krijg een unieke server URL
- **Kosten:** 2 Zapier tasks per tool call
- **Config:**
```json
{
  "zapier": {
    "type": "http",
    "url": "https://actions.zapier.com/mcp/your-unique-url"
  }
}
```

### n8n (Workflow Automatisering — Self-Hosted)
- **Wat:** Self-hosted Zapier alternatief. Expose n8n workflows als MCP tools.
- **Gebruik voor Recruitin:** Complexe multi-step automatiseringen, data pipelines
- **Package:** `n8n-mcp`
- **Vereist:** n8n instance + API key
- **Config:**
```json
{
  "n8n": {
    "command": "npx",
    "args": ["n8n-mcp"],
    "env": {
      "MCP_MODE": "stdio",
      "N8N_API_URL": "https://your-n8n-instance.com",
      "N8N_API_KEY": "your-api-key"
    }
  }
}
```

### LinkedIn (Recruiter Prospecting)
- **Wat:** LinkedIn profielen zoeken, berichten sturen, vacatures doorzoeken
- **Gebruik voor Recruitin:** Kandidaat sourcing, prospect outreach, profiel analyse
- **Package:** `@felipfr/linkedin-mcpserver`
- **Vereist:** LinkedIn API OAuth credentials (mogelijk Sales Navigator)
- **Config:**
```json
{
  "linkedin": {
    "command": "npx",
    "args": ["-y", "@felipfr/linkedin-mcpserver"],
    "env": {
      "LINKEDIN_CLIENT_ID": "your_client_id",
      "LINKEDIN_CLIENT_SECRET": "your_client_secret",
      "LINKEDIN_ACCESS_TOKEN": "your_access_token"
    }
  }
}
```

### Airtable (Database/CRM)
- **Wat:** CRUD op Airtable bases — records, schema's, tabellen
- **Gebruik voor Recruitin:** ATS (Applicant Tracking), client databases, campaign tracking
- **Package:** `airtable-mcp-server`
- **Vereist:** Airtable Personal Access Token
- **Config:**
```json
{
  "airtable": {
    "command": "npx",
    "args": ["-y", "airtable-mcp-server"],
    "env": {
      "AIRTABLE_API_KEY": "patXXXXXXXX.XXXXXXXX"
    }
  }
}
```

### HubSpot (CRM)
- **Wat:** Contacten, bedrijven, deals, tickets querien
- **Gebruik voor Recruitin:** Client relatiebeheer, recruitment deal pipeline
- **Config:**
```json
{
  "hubspot": {
    "command": "npx",
    "args": ["-y", "@anthropic/hubspot-mcp-server"],
    "env": {
      "HUBSPOT_ACCESS_TOKEN": "pat-your-token"
    }
  }
}
```

### Calendly (Planning)
- **Wat:** Events beheren, invitees bekijken, uitnodigingen versturen
- **Gebruik voor Recruitin:** Interview scheduling, client meetings
- **Package:** `@universal-mcp/calendly`
- **Config:**
```json
{
  "calendly": {
    "command": "npx",
    "args": ["-y", "@universal-mcp/calendly@latest"],
    "env": {
      "CALENDLY_API_KEY": "your_personal_access_token"
    }
  }
}
```

### Mailchimp (Email Marketing)
- **Wat:** Email campagnes, subscriber lijsten, templates, rapporten
- **Gebruik voor Recruitin:** Recruitment nieuwsbrieven, nurture sequences, kandidaat communicatie
- **Setup:** Clone `github.com/mattcoatsworth/mailchip-mcp-server` of gebruik via Zapier MCP
- **Vereist:** Mailchimp API Key + Server Prefix

---

## API Integraties (via Lovable Edge Functions)

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

---

## Snelkeuze: Welke Connectors Heb Je Nodig?

| Prioriteit | Connector | Waarom |
|-----------|-----------|--------|
| **Verplicht** | Supabase | Database — ruggengraat van het systeem |
| **Verplicht** | Lovable Cloud | Edge Functions voor authenticated APIs |
| **Hoog** | Pipedrive | Jullie CRM — client pipeline |
| **Hoog** | Playwright | Market intelligence scraping, career page monitoring |
| **Hoog** | Slack | Team alerts, campagne updates |
| **Hoog** | Clay | ICP prospect verrijking |
| **Medium** | LinkedIn MCP | Kandidaat sourcing, prospect outreach |
| **Medium** | Google Sheets | Rapportages, market intelligence sheets |
| **Medium** | Google Ads | Als jullie ook Google Ads draaien |
| **Medium** | Zapier | Catch-all voor tools zonder eigen MCP |
| **Laag** | Ollama | Privacy-gevoelige data lokaal verwerken |
| **Laag** | n8n | Als jullie self-hosted workflows willen |
| **Laag** | Calendly | Interview scheduling automatisering |
| **Laag** | Mailchimp | Email marketing campagnes |
