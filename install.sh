#!/usr/bin/env bash
#
# Second Brain OS installer
# Copies skills + scheduled-task templates into your Claude config and seeds your vault.
#
# Re-runnable. Refuses to overwrite an existing personalized install without an explicit
# backup/overwrite/abort choice from you.
#
# Usage: ./install.sh

set -euo pipefail

# --- visual helpers -----------------------------------------------------------

bold()  { printf "\033[1m%s\033[0m" "$*"; }
dim()   { printf "\033[2m%s\033[0m" "$*"; }
green() { printf "\033[32m%s\033[0m" "$*"; }
red()   { printf "\033[31m%s\033[0m" "$*"; }
yellow(){ printf "\033[33m%s\033[0m" "$*"; }
blue()  { printf "\033[34m%s\033[0m" "$*"; }

step()    { printf "\n%s %s\n" "$(blue "==>")" "$(bold "$*")"; }
info()    { printf "    %s\n" "$*"; }
ok()      { printf "    %s %s\n" "$(green "✓")" "$*"; }
warn()    { printf "    %s %s\n" "$(yellow "⚠")" "$*"; }
fail()    { printf "    %s %s\n" "$(red "✗")" "$*" >&2; }

# --- preflight ----------------------------------------------------------------

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
SKILLS_DIR="$CLAUDE_DIR/skills"
SCHEDULED_DIR="$CLAUDE_DIR/scheduled-tasks"

# OS check
case "$(uname -s)" in
  Darwin|Linux) ;;
  *)
    fail "Unsupported OS: $(uname -s). macOS and Linux only for v1."
    fail "Windows support is on the v2 candidate list."
    exit 1
    ;;
esac

# --- banner -------------------------------------------------------------------

cat <<'BANNER'

   ╔══════════════════════════════════════════════════════════════╗
   ║                                                              ║
   ║                   Second Brain OS · Installer                ║
   ║                                                              ║
   ║       Extends your AI context. Gives you a motion to follow. ║
   ║                                                              ║
   ╚══════════════════════════════════════════════════════════════╝

BANNER

info "$(dim "Repo location: ${REPO_ROOT}")"
info "$(dim "Claude config: ${CLAUDE_DIR}")"

# --- step 1: locate the vault -------------------------------------------------

step "Step 1 — Where does your Obsidian vault live?"

read -r -p "    Absolute path to vault (will be created if it does not exist): " VAULT_PATH
VAULT_PATH="${VAULT_PATH/#\~/$HOME}"  # expand ~

if [[ -z "$VAULT_PATH" ]]; then
  fail "Vault path is required. Aborting."
  exit 1
fi

if [[ ! -d "$VAULT_PATH" ]]; then
  warn "Path does not exist: $VAULT_PATH"
  read -r -p "    Create it? [y/N] " CREATE_VAULT
  if [[ "${CREATE_VAULT:-N}" =~ ^[Yy]$ ]]; then
    mkdir -p "$VAULT_PATH"
    ok "Created $VAULT_PATH"
  else
    fail "Need an existing vault path. Aborting."
    exit 1
  fi
fi

# Safety check: existing CLAUDE.md → user has a personalized install already
if [[ -f "$VAULT_PATH/CLAUDE.md" ]]; then
  warn "Existing CLAUDE.md detected at $VAULT_PATH/CLAUDE.md"
  warn "This means you already have a personalized install."
  echo
  echo "    Options:"
  echo "      [b] Back up CLAUDE.md (and Memory.md if present) and replace with fresh templates"
  echo "      [k] Keep yours; skip vault seeding (only install skills)"
  echo "      [a] Abort"
  echo
  read -r -p "    Choice: " EXISTING_CHOICE
  case "$EXISTING_CHOICE" in
    [Bb])
      BACKUP_STAMP="$(date +%Y%m%d-%H%M)"
      # Move (not copy) so the seed loop below sees an empty slot and writes the fresh template.
      mv "$VAULT_PATH/CLAUDE.md" "$VAULT_PATH/CLAUDE.md.backup-$BACKUP_STAMP"
      ok "Backed up CLAUDE.md → CLAUDE.md.backup-$BACKUP_STAMP"
      if [[ -f "$VAULT_PATH/Memory.md" ]]; then
        mv "$VAULT_PATH/Memory.md" "$VAULT_PATH/Memory.md.backup-$BACKUP_STAMP"
        ok "Backed up Memory.md → Memory.md.backup-$BACKUP_STAMP"
      fi
      VAULT_SEED_MODE="seed"
      ;;
    [Kk])
      VAULT_SEED_MODE="skip"
      info "Skipping vault seeding. Skills will still install."
      ;;
    *)
      fail "Aborting at user request."
      exit 0
      ;;
  esac
else
  VAULT_SEED_MODE="seed"
fi

# --- step 1b: dependency checks (advisory; do not block) ----------------------

step "Step 1b — Dependency checks"

# Krisp MCP detection. Check the locations where Claude Code might store
# MCP configuration. We grep for "krisp" (case-insensitive) across all of them.
KRISP_FOUND=0
KRISP_LOCATIONS=(
  "$HOME/.claude/settings.json"
  "$HOME/.claude/mcp.json"
  "$HOME/.claude/config.json"
  "$HOME/Library/Application Support/Claude/claude_desktop_config.json"
  "$HOME/.config/claude/settings.json"
)
for loc in "${KRISP_LOCATIONS[@]}"; do
  if [[ -f "$loc" ]] && grep -qi "krisp" "$loc" 2>/dev/null; then
    KRISP_FOUND=1
    ok "Krisp MCP detected in $loc"
    break
  fi
done

if [[ $KRISP_FOUND -eq 0 ]]; then
  warn "Krisp MCP not detected in any standard config location."
  warn "Krisp powers meeting capture — the morning brief and evening wrap"
  warn "lean on its transcripts. The system still installs without it, but"
  warn "the daily processes will run thinner."
  echo
  echo "    See docs/krisp-setup.md for configuration steps."
  echo
  read -r -p "    Continue without Krisp? [y/N] " KRISP_SKIP
  if [[ ! "${KRISP_SKIP:-N}" =~ ^[Yy]$ ]]; then
    info "Aborting. Configure Krisp, then re-run ./install.sh."
    exit 0
  fi
fi

# Obsidian plugin check. Tasks and Dataview are required for Tasks Dashboard
# to render. Read .obsidian/community-plugins.json if present.
PLUGINS_FILE="$VAULT_PATH/.obsidian/community-plugins.json"
TASKS_OK=0
DATAVIEW_OK=0

if [[ -f "$PLUGINS_FILE" ]]; then
  if grep -q '"obsidian-tasks-plugin"' "$PLUGINS_FILE" 2>/dev/null; then
    TASKS_OK=1
  fi
  if grep -q '"dataview"' "$PLUGINS_FILE" 2>/dev/null; then
    DATAVIEW_OK=1
  fi

  if [[ $TASKS_OK -eq 1 && $DATAVIEW_OK -eq 1 ]]; then
    ok "Obsidian Tasks + Dataview plugins enabled."
  else
    [[ $TASKS_OK -eq 0 ]]    && warn "Obsidian Tasks plugin not enabled — required for Tasks Dashboard."
    [[ $DATAVIEW_OK -eq 0 ]] && warn "Obsidian Dataview plugin not enabled — required for Tasks Dashboard."
    info "Enable them in Obsidian: Settings → Community plugins → Browse → search Tasks / Dataview → install + enable."
    info "(Continuing — TASKS.md and skills work without these; only the dashboard view needs them.)"
  fi
else
  warn "$VAULT_PATH/.obsidian/ not found. Open the vault in Obsidian once first to initialize, then enable Tasks + Dataview plugins."
  info "(Continuing — the vault still seeds correctly. Plugin check moot until you open Obsidian.)"
fi

# --- step 2: install skills ---------------------------------------------------

step "Step 2 — Install skills to ~/.claude/skills/"

mkdir -p "$SKILLS_DIR"

if [[ ! -d "$REPO_ROOT/skills" ]]; then
  fail "Repo skills/ directory missing — was the repo cloned correctly?"
  exit 1
fi

INSTALLED=0
SKIPPED=0

for skill_path in "$REPO_ROOT"/skills/*/; do
  skill_name="$(basename "$skill_path")"
  target="$SKILLS_DIR/$skill_name"

  if [[ -d "$target" ]]; then
    warn "Skill already exists, skipping: $skill_name (delete it first to reinstall)"
    SKIPPED=$((SKIPPED + 1))
    continue
  fi

  cp -R "$skill_path" "$target"
  ok "Installed skill: $skill_name"
  INSTALLED=$((INSTALLED + 1))
done

info "$(dim "Installed: $INSTALLED · Skipped: $SKIPPED")"

# --- step 3: install scheduled-task templates (if present) --------------------

step "Step 3 — Install scheduled-task templates"

if [[ -z "$(ls -A "$REPO_ROOT/scheduled-tasks" 2>/dev/null | grep -v '^\.gitkeep$' || true)" ]]; then
  warn "No scheduled-task templates in this repo yet (this is expected during early access)."
  info "When morning-brief.template.md and evening-wrap.template.md ship in a future"
  info "release, re-running this installer will pick them up."
else
  mkdir -p "$SCHEDULED_DIR"
  for template in "$REPO_ROOT"/scheduled-tasks/*.template.md; do
    [[ -f "$template" ]] || continue
    name="$(basename "$template" .template.md)"
    target_dir="$SCHEDULED_DIR/$name"
    target="$target_dir/SKILL.md"

    if [[ -f "$target" ]]; then
      warn "Template already installed, skipping: $name (re-run /personalize-second-brain --update to refresh)"
      continue
    fi

    mkdir -p "$target_dir"
    cp "$template" "$target"
    ok "Installed template: $name"
  done
fi

# --- step 4: seed the vault (if requested) ------------------------------------

step "Step 4 — Seed your vault"

if [[ "$VAULT_SEED_MODE" == "skip" ]]; then
  info "Skipping per your earlier choice."
elif [[ -z "$(ls -A "$REPO_ROOT/vault-template" 2>/dev/null | grep -v '^\.gitkeep$' || true)" ]]; then
  warn "No vault-template content in this repo yet (this is expected during early access)."
  info "/personalize-second-brain will generate Memory.md and CLAUDE.md from your interview answers."
  info "Vault-template scaffolding (PARA folders, dashboard queries) ships in a future release."
else
  for entry in "$REPO_ROOT"/vault-template/*; do
    [[ -e "$entry" ]] || continue
    base="$(basename "$entry")"
    [[ "$base" == ".gitkeep" ]] && continue

    target="$VAULT_PATH/$base"
    if [[ -e "$target" ]]; then
      warn "Vault entry already exists, skipping: $base"
      continue
    fi

    cp -R "$entry" "$target"
    ok "Seeded: $base"
  done
fi

# --- step 5: next steps -------------------------------------------------------

step "Done. One more step."

cat <<EOF

    Open Claude Code (or Cowork) in your vault:

      $(bold "cd $VAULT_PATH")
      $(bold "claude")    # or open Cowork

    Then run:

      $(bold "/personalize-second-brain")

    This will interview you once and generate your personalized files.
    Total time from here to your first morning brief: ~30 minutes.

EOF

info "$(dim "If you hit a snag, see docs/troubleshooting.md.")"
echo
