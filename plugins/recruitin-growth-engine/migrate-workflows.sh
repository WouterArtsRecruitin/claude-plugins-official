#!/usr/bin/env bash
# ============================================================
# Recruitin Workflow Migration — Secrets Configurator
#
# Dit script:
#   1. Leest bestaande secrets uit je andere repos
#   2. Vraagt om ontbrekende waarden
#   3. Configureert alle secrets in claude-plugins-official
#   4. Test de nieuwe workflows
#   5. Disabled de oude workflows
#
# Gebruik: bash migrate-workflows.sh
# Vereist: gh CLI (authenticated)
# ============================================================

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

TARGET_REPO="WouterArtsRecruitin/claude-plugins-official"

echo ""
echo -e "${BOLD}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║  Recruitin Workflow Migration — Secrets & Setup     ║${NC}"
echo -e "${BOLD}╚══════════════════════════════════════════════════════╝${NC}"
echo ""

# ---- Check gh CLI ----
if ! command -v gh &>/dev/null; then
  echo -e "${RED}gh CLI niet gevonden. Installeer:${NC}"
  echo -e "  macOS:  brew install gh"
  echo -e "  Linux:  sudo apt install gh"
  exit 1
fi

if ! gh auth status &>/dev/null; then
  echo -e "${YELLOW}Je bent niet ingelogd bij GitHub. Log nu in:${NC}"
  gh auth login
fi

echo -e "${GREEN}GitHub CLI: authenticated${NC}"
echo ""

# ---- Functie: Secret instellen ----
set_secret() {
  local name="$1"
  local value="$2"

  if [ -z "$value" ] || [ "$value" = "null" ]; then
    echo -e "  ${YELLOW}SKIP${NC} $name (geen waarde)"
    return
  fi

  echo "$value" | gh secret set "$name" --repo "$TARGET_REPO" 2>/dev/null
  if [ $? -eq 0 ]; then
    echo -e "  ${GREEN}OK${NC} $name"
  else
    echo -e "  ${RED}FOUT${NC} $name"
  fi
}

# ---- Stap 1: Secrets verzamelen ----
echo -e "${BOLD}Stap 1: Secrets verzamelen${NC}"
echo ""
echo -e "Ik ga je om de waarden vragen. Plak ze in en druk Enter."
echo -e "(Secrets worden niet op scherm getoond)"
echo ""

# BRAVE_API_KEY
echo -e "${BLUE}1/9: BRAVE_API_KEY${NC}"
echo -e "     Vind je op: https://brave.com/search/api/ of kopieer uit intelligence-hub repo"
echo -ne "     > "
read -rs BRAVE_API_KEY
echo ""

# NOTION_API_KEY
echo -e "${BLUE}2/9: NOTION_API_KEY${NC}"
echo -e "     Vind je op: https://www.notion.so/my-integrations"
echo -ne "     > "
read -rs NOTION_API_KEY
echo ""

# SUPABASE_URL
SUPABASE_URL="https://vaiikkhaulkqdknwvroj.supabase.co"
echo -e "${BLUE}3/9: SUPABASE_URL${NC}"
echo -e "     Auto-ingesteld: ${SUPABASE_URL}"

# SUPABASE_SERVICE_ROLE_KEY
echo -e "${BLUE}4/9: SUPABASE_SERVICE_ROLE_KEY${NC}"
echo -e "     Supabase Dashboard > Settings > Data API > service_role key"
echo -ne "     > "
read -rs SUPABASE_SERVICE_ROLE_KEY
echo ""

# ANTHROPIC_API_KEY
echo -e "${BLUE}5/9: ANTHROPIC_API_KEY${NC}"
echo -e "     Vind je op: https://console.anthropic.com/settings/keys"
echo -ne "     > "
read -rs ANTHROPIC_API_KEY
echo ""

# SLACK_WEBHOOK_URL
echo -e "${BLUE}6/9: SLACK_WEBHOOK_URL${NC}"
echo -e "     Slack > Apps > Incoming Webhooks > kopie URL"
echo -ne "     > "
read -rs SLACK_WEBHOOK_URL
echo ""

# GOOGLE_CREDENTIALS
echo -e "${BLUE}7/9: GOOGLE_CREDENTIALS${NC}"
echo -e "     Google Cloud Console > Service Account > JSON key (plak hele JSON)"
echo -e "     (Optioneel — druk Enter om over te slaan)"
echo -ne "     > "
read -rs GOOGLE_CREDENTIALS
echo ""

# SHEET_ID
echo -e "${BLUE}8/9: SHEET_ID${NC}"
echo -e "     Google Sheets URL: docs.google.com/spreadsheets/d/<SHEET_ID>/edit"
echo -e "     (Optioneel — druk Enter om over te slaan)"
echo -ne "     > "
read -r SHEET_ID
echo ""

# GH_PAT
echo -e "${BLUE}9/9: GH_PAT (GitHub Personal Access Token)${NC}"
echo -e "     Nodig om intelligence-hub repo te checkout-en vanuit workflows"
echo -e "     Maak aan op: https://github.com/settings/tokens > Generate new token (classic)"
echo -e "     Scope: 'repo' (full control)"
echo -ne "     > "
read -rs GH_PAT
echo ""

# CLAUDE_CODE_OAUTH_TOKEN (voor claude.yml workflows)
echo ""
echo -e "${BLUE}Bonus: CLAUDE_CODE_OAUTH_TOKEN${NC}"
echo -e "     Voor @claude mentions in issues/PRs. Kopieer uit intelligence-hub repo."
echo -e "     (Optioneel — druk Enter om over te slaan)"
echo -ne "     > "
read -rs CLAUDE_CODE_OAUTH_TOKEN
echo ""

# ---- Stap 2: Secrets instellen ----
echo ""
echo -e "${BOLD}Stap 2: Secrets instellen in ${TARGET_REPO}${NC}"
echo ""

set_secret "BRAVE_API_KEY" "$BRAVE_API_KEY"
set_secret "NOTION_API_KEY" "$NOTION_API_KEY"
set_secret "SUPABASE_URL" "$SUPABASE_URL"
set_secret "SUPABASE_SERVICE_ROLE_KEY" "$SUPABASE_SERVICE_ROLE_KEY"
set_secret "ANTHROPIC_API_KEY" "$ANTHROPIC_API_KEY"
set_secret "SLACK_WEBHOOK_URL" "$SLACK_WEBHOOK_URL"
set_secret "GOOGLE_CREDENTIALS" "${GOOGLE_CREDENTIALS:-}"
set_secret "SHEET_ID" "${SHEET_ID:-}"
set_secret "GH_PAT" "$GH_PAT"
set_secret "CLAUDE_CODE_OAUTH_TOKEN" "${CLAUDE_CODE_OAUTH_TOKEN:-}"

# ---- Stap 3: Test nieuwe workflows ----
echo ""
echo -e "${BOLD}Stap 3: Nieuwe workflows testen${NC}"
echo ""
echo -e "Wil je de nieuwe workflows nu testen? (j/n)"
read -r TEST_NOW

if [ "$TEST_NOW" = "j" ] || [ "$TEST_NOW" = "y" ]; then
  echo ""
  echo -e "  ${BLUE}Triggering daily-news-pipeline...${NC}"
  gh workflow run daily-news-pipeline.yml --repo "$TARGET_REPO" 2>/dev/null && \
    echo -e "  ${GREEN}Triggered${NC}" || echo -e "  ${YELLOW}Workflow niet gevonden (merge PR eerst)${NC}"

  echo -e "  ${BLUE}Triggering weekly-intelligence-pipeline (market-trends only)...${NC}"
  gh workflow run weekly-intelligence-pipeline.yml --repo "$TARGET_REPO" -f step=market-trends 2>/dev/null && \
    echo -e "  ${GREEN}Triggered${NC}" || echo -e "  ${YELLOW}Workflow niet gevonden (merge PR eerst)${NC}"

  echo ""
  echo -e "  Check status op: ${BLUE}https://github.com/${TARGET_REPO}/actions${NC}"
fi

# ---- Stap 4: Disable oude workflows ----
echo ""
echo -e "${BOLD}Stap 4: Oude workflows disablen${NC}"
echo ""
echo -e "Wil je de oude falende workflows NU disablen? (j/n)"
echo -e "${YELLOW}(Aanbevolen: doe dit pas als de nieuwe workflows succesvol draaien)${NC}"
read -r DISABLE_NOW

if [ "$DISABLE_NOW" = "j" ] || [ "$DISABLE_NOW" = "y" ]; then
  echo ""
  echo -e "  ${BLUE}Disabling intelligence-hub workflows...${NC}"

  INTEL_WORKFLOWS=(
    "Intelligence Hub - Weekly Scraping"
    "Weekly Market Trends"
    "Weekly ICP Activity"
    "Weekly Concurrent Activity"
    "Weekly - Job Board Tracker"
    "Weekly - Intent Signals Tracker"
    "Weekly - Email Engagement Tracker"
    "Weekly - Reporting Dashboard"
    "LinkedIn Newsletter Automation"
    "YAML Linter"
  )

  for wf in "${INTEL_WORKFLOWS[@]}"; do
    gh workflow disable "$wf" --repo "WouterArtsRecruitin/intelligence-hub" 2>/dev/null && \
      echo -e "  ${GREEN}Disabled:${NC} $wf" || \
      echo -e "  ${YELLOW}Skip:${NC} $wf (niet gevonden)"
  done

  echo ""
  echo -e "  ${BLUE}Disabling content-intelligence-system workflows...${NC}"
  gh workflow disable "Notion Content Manager - Daily Automation" --repo "WouterArtsRecruitin/recruitin-content-intelligence-system" 2>/dev/null && \
    echo -e "  ${GREEN}Disabled:${NC} Notion Content Manager" || \
    echo -e "  ${YELLOW}Skip:${NC} Notion Content Manager (niet gevonden)"

  echo ""
  echo -e "  ${BLUE}Disabling recruitin-mcp-servers workflows...${NC}"
  gh workflow disable "Daily News Scraper" --repo "WouterArtsRecruitin/recruitin-mcp-servers" 2>/dev/null && \
    echo -e "  ${GREEN}Disabled:${NC} Daily News Scraper" || \
    echo -e "  ${YELLOW}Skip:${NC} Daily News Scraper (niet gevonden)"
  gh workflow disable "Weekly Content Generator" --repo "WouterArtsRecruitin/recruitin-mcp-servers" 2>/dev/null && \
    echo -e "  ${GREEN}Disabled:${NC} Weekly Content Generator" || \
    echo -e "  ${YELLOW}Skip:${NC} Weekly Content Generator (niet gevonden)"

  echo ""
  echo -e "  ${GREEN}Claude Code workflows (claude.yml, claude-code-review.yml) BEHOUDEN in alle repos${NC}"
fi

# ---- Klaar ----
echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  Migratie voltooid!                                  ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${BOLD}Wat is geconfigureerd:${NC}"
echo -e "  ✅ Secrets ingesteld in ${TARGET_REPO}"
echo -e "  ✅ Nieuwe pipelines: daily-news, weekly-intelligence, weekly-content"
echo ""
echo -e "  ${BOLD}Monitor op:${NC}"
echo -e "  📊 GitHub Actions: https://github.com/${TARGET_REPO}/actions"
echo -e "  💬 Slack: Check je webhook kanaal voor pipeline notificaties"
echo -e "  🗄️  Supabase: market_intelligence tabel voor nieuwe data"
echo ""
echo -e "  ${BOLD}Commando's:${NC}"
echo -e "  /recruitin-workflows status  — Pipeline status checken"
echo -e "  /recruitin-workflows debug   — Failures analyseren"
echo ""
