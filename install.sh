#!/bin/bash
# quick2cowork installer — tự detect Claude Desktop / Kiro / Claude Code và cài skills

set -e

REPO_URL="https://github.com/SoftwareOneHN/quick2cowork.git"
TMP_DIR=$(mktemp -d)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔══════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     quick2cowork skill installer     ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════╝${NC}"
echo ""

# Detect source — local or clone
if [ -f "$SCRIPT_DIR/document-conversion/SKILL.md" ]; then
  SOURCE_DIR="$SCRIPT_DIR"
  echo -e "${GREEN}✓${NC} Using local skills from: $SOURCE_DIR"
else
  echo "Cloning from GitHub..."
  git clone --depth 1 "$REPO_URL" "$TMP_DIR/quick2cowork" 2>/dev/null
  SOURCE_DIR="$TMP_DIR/quick2cowork"
  echo -e "${GREEN}✓${NC} Cloned repository"
fi

# Detect targets
TARGETS=()

# Claude Desktop (macOS)
CLAUDE_DESKTOP="$HOME/Library/Application Support/Claude-3p/local-agent-mode-sessions/skills-plugin/00000000-0000-4000-8000-000000000001"
if [ -d "$CLAUDE_DESKTOP" ]; then
  # Find the skills subfolder (UUID varies)
  CLAUDE_SKILLS=$(find "$CLAUDE_DESKTOP" -maxdepth 2 -type d -name "skills" 2>/dev/null | head -1)
  if [ -n "$CLAUDE_SKILLS" ]; then
    TARGETS+=("claude-desktop:$CLAUDE_SKILLS")
  fi
fi

# Kiro IDE
KIRO_GLOBAL="$HOME/.kiro/skills"
if [ -d "$HOME/.kiro" ]; then
  TARGETS+=("kiro-global:$KIRO_GLOBAL")
fi

# Claude Code
CLAUDE_CODE="$HOME/.claude/skills"
if [ -d "$HOME/.claude" ]; then
  TARGETS+=("claude-code:$CLAUDE_CODE")
fi

# No targets found
if [ ${#TARGETS[@]} -eq 0 ]; then
  echo -e "${YELLOW}⚠ No Claude/Kiro installation detected.${NC}"
  echo ""
  echo "Manual install options:"
  echo "  Claude Code:    cp -r skills/* ~/.claude/skills/"
  echo "  Kiro:           cp -r skills/* ~/.kiro/skills/"
  echo "  Project-level:  cp -r skills/* .claude/skills/"
  rm -rf "$TMP_DIR"
  exit 1
fi

# Show detected targets
echo ""
echo "Detected installations:"
for target in "${TARGETS[@]}"; do
  name="${target%%:*}"
  path="${target##*:}"
  echo -e "  ${GREEN}●${NC} $name → $path"
done

# Ask user
echo ""
echo "Install to which target?"
echo ""
idx=1
for target in "${TARGETS[@]}"; do
  name="${target%%:*}"
  echo "  $idx) $name"
  idx=$((idx + 1))
done
echo "  a) All"
echo "  q) Quit"
echo ""
read -p "Choice [a]: " choice
choice=${choice:-a}

# Determine install targets
INSTALL_TARGETS=()
if [ "$choice" = "q" ]; then
  echo "Cancelled."
  rm -rf "$TMP_DIR"
  exit 0
elif [ "$choice" = "a" ]; then
  INSTALL_TARGETS=("${TARGETS[@]}")
else
  idx=$((choice - 1))
  INSTALL_TARGETS=("${TARGETS[$idx]}")
fi

# Install
SKILL_DIRS=$(find "$SOURCE_DIR" -maxdepth 1 -type d ! -name ".*" ! -path "$SOURCE_DIR" | sort)
SKILL_COUNT=$(echo "$SKILL_DIRS" | wc -l | tr -d ' ')

for target in "${INSTALL_TARGETS[@]}"; do
  name="${target%%:*}"
  path="${target##*:}"

  mkdir -p "$path"

  for skill_dir in $SKILL_DIRS; do
    skill_name=$(basename "$skill_dir")
    # Skip non-skill directories
    if [ ! -f "$skill_dir/SKILL.md" ]; then
      continue
    fi
    cp -r "$skill_dir" "$path/"
  done

  echo -e "${GREEN}✓${NC} Installed to $name ($path)"
done

# Cleanup
rm -rf "$TMP_DIR"

# Count actual skills installed
INSTALLED=$(find "$SOURCE_DIR" -maxdepth 2 -name "SKILL.md" | wc -l | tr -d ' ')

echo ""
echo -e "${GREEN}Done!${NC} $INSTALLED skills installed."
echo ""
echo "Skills will auto-activate in your next conversation."
echo "Or type / in chat to see available slash commands."
