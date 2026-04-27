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
  echo "      [b] Back it up (CLAUDE.md → CLAUDE.md.backup-$(date +%Y%m%d-%H%M)) and continue"
  echo "      [k] Keep it; skip vault seeding (only install skills)"
  echo "      [a] Abort"
  echo
  read -r -p "    Choice: " EXISTING_CHOICE
  case "${EXISTING_CHOICE,,}" in
    b)
      BACKUP_PATH="$VAULT_PATH/CLAUDE.md.backup-$(date +%Y%m%d-%H%M)"
      cp "$VAULT_PATH/CLAUDE.md" "$BACKUP_PATH"
      ok "Backed up CLAUDE.md to $(basename "$BACKUP_PATH")"
      VAULT_SEED_MODE="seed"
      ;;
    k)
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

info "$(dim "If you hit a snag, see docs/troubleshooting.md (ships in a future release).")"
echo
