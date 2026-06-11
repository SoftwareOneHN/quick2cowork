#!/bin/bash
# quick2cowork installer
# Tự detect Claude Desktop (Cowork) / Kiro / Claude Code trên macOS & Windows
# Hỗ trợ: macOS (bash/zsh), Windows (Git Bash / WSL)

set -e

REPO_URL="https://github.com/SoftwareOneHN/quick2cowork.git"
TMP_DIR=$(mktemp -d)

# Colors (skip if no tty)
if [ -t 1 ]; then
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  BLUE='\033[0;34m'
  RED='\033[0;31m'
  NC='\033[0m'
else
  GREEN='' YELLOW='' BLUE='' RED='' NC=''
fi

echo -e "${BLUE}╔══════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     quick2cowork skill installer     ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════╝${NC}"
echo ""

# ─── Detect OS ───────────────────────────────────────────────
detect_os() {
  case "$(uname -s)" in
    Darwin*) echo "macos" ;;
    MINGW*|MSYS*|CYGWIN*) echo "windows" ;;
    Linux*)
      if grep -qi microsoft /proc/version 2>/dev/null; then
        echo "wsl"
      else
        echo "linux"
      fi
      ;;
    *) echo "unknown" ;;
  esac
}

OS=$(detect_os)
echo -e "OS: ${GREEN}$OS${NC}"

# ─── Detect source (local or clone) ─────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"

if [ -f "$SCRIPT_DIR/document-conversion/SKILL.md" ]; then
  SOURCE_DIR="$SCRIPT_DIR"
  echo -e "${GREEN}✓${NC} Using local skills from: $SOURCE_DIR"
else
  echo "Cloning from GitHub..."
  git clone --depth 1 "$REPO_URL" "$TMP_DIR/quick2cowork" 2>/dev/null
  SOURCE_DIR="$TMP_DIR/quick2cowork"
  echo -e "${GREEN}✓${NC} Cloned repository"
fi

# ─── Find skill directories in source ────────────────────────
count_skills() {
  find "$SOURCE_DIR" -maxdepth 2 -name "SKILL.md" -type f 2>/dev/null | wc -l | tr -d ' '
}

SKILL_COUNT=$(count_skills)
echo -e "Found ${GREEN}$SKILL_COUNT${NC} skills"
echo ""

# ─── Platform-specific paths ─────────────────────────────────

# Returns Windows APPDATA path (works in Git Bash, WSL, native)
get_appdata() {
  if [ -n "$APPDATA" ]; then
    echo "$APPDATA"
  elif [ "$OS" = "wsl" ]; then
    wslpath "$(cmd.exe /C 'echo %APPDATA%' 2>/dev/null | tr -d '\r')" 2>/dev/null
  fi
}

TARGETS=()

# ─── Claude Desktop / Cowork (skills-plugin with dynamic UUIDs) ───

find_claude_desktop_skills() {
  local base_dir=""

  case "$OS" in
    macos)
      # Check both Claude-3p (Cowork 3P) and Claude (standard)
      for app_name in "Claude-3p" "Claude"; do
        base_dir="$HOME/Library/Application Support/$app_name/local-agent-mode-sessions/skills-plugin"
        if [ -d "$base_dir" ]; then
          # Find the skills directory (nested under dynamic UUIDs)
          local found
          found=$(find "$base_dir" -type d -name "skills" 2>/dev/null | head -1)
          if [ -n "$found" ]; then
            echo "$found"
            return
          fi
        fi
      done
      ;;
    windows|wsl)
      local appdata
      appdata=$(get_appdata)
      if [ -n "$appdata" ]; then
        for app_name in "Claude-3p" "Claude"; do
          base_dir="$appdata/$app_name/local-agent-mode-sessions/skills-plugin"
          if [ -d "$base_dir" ]; then
            local found
            found=$(find "$base_dir" -type d -name "skills" 2>/dev/null | head -1)
            if [ -n "$found" ]; then
              echo "$found"
              return
            fi
          fi
        done
      fi
      ;;
  esac
}

CLAUDE_DESKTOP_SKILLS=$(find_claude_desktop_skills)
if [ -n "$CLAUDE_DESKTOP_SKILLS" ]; then
  TARGETS+=("Claude Desktop (Cowork):$CLAUDE_DESKTOP_SKILLS")
fi

# ─── Kiro ─────────────────────────────────────────────────────

find_kiro_skills() {
  local kiro_dir=""

  case "$OS" in
    macos|linux|wsl)
      kiro_dir="$HOME/.kiro"
      ;;
    windows)
      kiro_dir="$USERPROFILE/.kiro"
      [ ! -d "$kiro_dir" ] && kiro_dir="$HOME/.kiro"
      ;;
  esac

  if [ -d "$kiro_dir" ]; then
    echo "$kiro_dir/skills"
  fi
}

KIRO_SKILLS=$(find_kiro_skills)
if [ -n "$KIRO_SKILLS" ]; then
  TARGETS+=("Kiro (global):$KIRO_SKILLS")
fi

# ─── Claude Code ──────────────────────────────────────────────

find_claude_code_skills() {
  local claude_dir=""

  case "$OS" in
    macos|linux|wsl)
      claude_dir="$HOME/.claude"
      ;;
    windows)
      claude_dir="$USERPROFILE/.claude"
      [ ! -d "$claude_dir" ] && claude_dir="$HOME/.claude"
      ;;
  esac

  if [ -d "$claude_dir" ]; then
    echo "$claude_dir/skills"
  fi
}

CLAUDE_CODE_SKILLS=$(find_claude_code_skills)
if [ -n "$CLAUDE_CODE_SKILLS" ]; then
  TARGETS+=("Claude Code (global):$CLAUDE_CODE_SKILLS")
fi

# ─── No targets? ─────────────────────────────────────────────

if [ ${#TARGETS[@]} -eq 0 ]; then
  echo -e "${YELLOW}⚠ No Claude/Kiro installation detected.${NC}"
  echo ""
  echo "Manual install:"
  echo ""
  echo "  macOS/Linux:"
  echo "    Claude Code:  mkdir -p ~/.claude/skills && cp -r skills/* ~/.claude/skills/"
  echo "    Kiro:         mkdir -p ~/.kiro/skills && cp -r skills/* ~/.kiro/skills/"
  echo ""
  echo "  Windows (PowerShell):"
  echo "    Claude Code:  Copy-Item -Recurse skills\\* \$env:USERPROFILE\\.claude\\skills\\"
  echo "    Kiro:         Copy-Item -Recurse skills\\* \$env:USERPROFILE\\.kiro\\skills\\"
  echo ""
  rm -rf "$TMP_DIR"
  exit 1
fi

# ─── Show targets & ask ──────────────────────────────────────

echo "Detected installations:"
echo ""
idx=1
for target in "${TARGETS[@]}"; do
  name="${target%%:*}"
  path="${target##*:}"
  echo -e "  ${GREEN}$idx)${NC} $name"
  echo -e "     ${BLUE}→ $path${NC}"
  idx=$((idx + 1))
done
echo ""
echo -e "  ${GREEN}a)${NC} All of the above"
echo -e "  ${RED}q)${NC} Quit"
echo ""
read -p "Install to [a]: " choice
choice=${choice:-a}

# ─── Resolve choice ──────────────────────────────────────────

INSTALL_TARGETS=()
if [ "$choice" = "q" ] || [ "$choice" = "Q" ]; then
  echo "Cancelled."
  rm -rf "$TMP_DIR"
  exit 0
elif [ "$choice" = "a" ] || [ "$choice" = "A" ]; then
  INSTALL_TARGETS=("${TARGETS[@]}")
elif [[ "$choice" =~ ^[0-9]+$ ]]; then
  idx=$((choice - 1))
  if [ $idx -ge 0 ] && [ $idx -lt ${#TARGETS[@]} ]; then
    INSTALL_TARGETS=("${TARGETS[$idx]}")
  else
    echo -e "${RED}Invalid choice.${NC}"
    rm -rf "$TMP_DIR"
    exit 1
  fi
else
  echo -e "${RED}Invalid choice.${NC}"
  rm -rf "$TMP_DIR"
  exit 1
fi

# ─── Install ─────────────────────────────────────────────────

echo ""

for target in "${INSTALL_TARGETS[@]}"; do
  name="${target%%:*}"
  path="${target##*:}"

  # Create target dir
  mkdir -p "$path"

  # Copy each skill directory
  installed=0
  for skill_dir in "$SOURCE_DIR"/*/; do
    if [ -f "$skill_dir/SKILL.md" ]; then
      skill_name=$(basename "$skill_dir")
      cp -r "$skill_dir" "$path/"
      installed=$((installed + 1))
    fi
  done

  echo -e "${GREEN}✓${NC} $name — $installed skills installed"
  echo -e "  ${BLUE}$path${NC}"
done

# ─── Cleanup ─────────────────────────────────────────────────
rm -rf "$TMP_DIR"

echo ""
echo -e "${GREEN}═══ Done! ═══${NC}"
echo ""
echo "Skills auto-activate when your request matches their description."
echo "Or type / in chat to see available slash commands."
echo ""
echo "Installed skills:"
echo "  Planning:   plan-mode, deep-analysis, parallel-orchestration"
echo "  Execution:  browser-automation, knowledge-graph, memory-management"
echo "  Output:     document-generation, highcharts, html-design"
echo "  Meta:       skill-authoring, skill-improvement"
