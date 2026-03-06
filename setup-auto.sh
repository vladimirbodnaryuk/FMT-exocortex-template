#!/bin/bash
# Automated setup wrapper for FMT-exocortex-template
# Runs without interactive prompts, using defaults
set -e

LOGFILE="/tmp/exocortex-setup-$(date +%Y%m%d-%H%M%S).log"
TEMPLATE_DIR="$(cd "$(dirname "$0")" && pwd)"
WORKSPACE_DIR="${WORKSPACE_DIR:-$(dirname "$TEMPLATE_DIR")}"
GITHUB_USER="${GITHUB_USER:-your-username}"

echo "=========================================="
echo "  Exocortex Setup (Automated)"
echo "=========================================="
echo ""
echo "Logging to: $LOGFILE"
echo ""

{
    echo "Setup started: $(date)"
    echo "Workspace: $WORKSPACE_DIR"
    echo "Template: $TEMPLATE_DIR"
    echo "GitHub user: $GITHUB_USER"
    echo ""

    # === 1. Substitute placeholders ===
    echo "[1/6] Configuring placeholders..."
    CLAUDE_PROJECT_SLUG="$(echo "$WORKSPACE_DIR" | tr '/' '-')"
    TIMEZONE_HOUR="4"
    TIMEZONE_DESC="${TIMEZONE_HOUR}:00 UTC"
    CLAUDE_PATH="/usr/bin/claude"
    HOME_DIR="$HOME"

    find "$TEMPLATE_DIR" -type f \( -name "*.md" -o -name "*.json" -o -name "*.sh" -o -name "*.plist" -o -name "*.yaml" -o -name "*.yml" \) 2>/dev/null | while read file; do
        sed -i '' \
            -e "s|your-username|$GITHUB_USER|g" \
            -e "s|/mnt/d/Git|$WORKSPACE_DIR|g" \
            -e "s|/usr/bin/claude|$CLAUDE_PATH|g" \
            -e "s|-mnt-d-Git|$CLAUDE_PROJECT_SLUG|g" \
            -e "s|4|$TIMEZONE_HOUR|g" \
            -e "s|4:00 UTC|$TIMEZONE_DESC|g" \
            -e "s|/home/vb|$HOME_DIR|g" \
            "$file" 2>/dev/null || true
    done
    echo "  ✓ Placeholders substituted"

    # === 2. Copy CLAUDE.md ===
    echo "[2/6] Installing CLAUDE.md..."
    mkdir -p "$WORKSPACE_DIR"
    cp "$TEMPLATE_DIR/CLAUDE.md" "$WORKSPACE_DIR/CLAUDE.md"
    echo "  ✓ Copied to $WORKSPACE_DIR/CLAUDE.md"

    # === 3. Copy memory ===
    echo "[3/6] Installing memory..."
    CLAUDE_MEMORY_DIR="$HOME/.claude/projects/$CLAUDE_PROJECT_SLUG/memory"
    mkdir -p "$CLAUDE_MEMORY_DIR"
    cp "$TEMPLATE_DIR/memory/"*.md "$CLAUDE_MEMORY_DIR/" 2>/dev/null || true
    echo "  ✓ Copied to $CLAUDE_MEMORY_DIR ($(ls "$CLAUDE_MEMORY_DIR"/*.md 2>/dev/null | wc -l) files)"

    # === 4. Copy Claude settings ===
    echo "[4/6] Installing Claude settings..."
    mkdir -p "$WORKSPACE_DIR/.claude"
    if [ -f "$TEMPLATE_DIR/.claude/settings.local.json" ]; then
        cp "$TEMPLATE_DIR/.claude/settings.local.json" "$WORKSPACE_DIR/.claude/settings.local.json"
        echo "  ✓ Copied to $WORKSPACE_DIR/.claude/settings.local.json"
    else
        echo "  ○ settings.local.json not found (optional)"
    fi

    # === 5. Create DS-strategy ===
    echo "[5/6] Setting up DS-strategy..."
    MY_STRATEGY_DIR="$WORKSPACE_DIR/DS-strategy"
    STRATEGY_TEMPLATE="$TEMPLATE_DIR/seed/strategy"

    if [ ! -d "$MY_STRATEGY_DIR/.git" ]; then
        if [ -d "$STRATEGY_TEMPLATE" ]; then
            cp -r "$STRATEGY_TEMPLATE" "$MY_STRATEGY_DIR"
            cd "$MY_STRATEGY_DIR"
            git init
            git config user.email "exocortex@local" || true
            git config user.name "Exocortex Setup" || true
            git add -A
            git commit -m "Initial exocortex: DS-strategy governance hub" 2>/dev/null || true
            echo "  ✓ Created local git repo"
        else
            mkdir -p "$MY_STRATEGY_DIR"/{current,inbox,archive/wp-contexts,docs,exocortex}
            cd "$MY_STRATEGY_DIR"
            git init
            git config user.email "exocortex@local" || true
            git config user.name "Exocortex Setup" || true
            git add -A
            git commit -m "Initial exocortex: DS-strategy governance hub (minimal)" 2>/dev/null || true
            echo "  ✓ Created minimal DS-strategy"
        fi
    else
        echo "  ○ DS-strategy already exists"
    fi

    # === 6. Verify installation ===
    echo "[6/6] Verifying installation..."
    
    CHECKS_PASSED=0
    CHECKS_TOTAL=0

    check_file() {
        local path="$1"
        local name="$2"
        CHECKS_TOTAL=$((CHECKS_TOTAL + 1))
        if [ -f "$path" ]; then
            echo "    ✓ $name"
            CHECKS_PASSED=$((CHECKS_PASSED + 1))
        else
            echo "    ✗ $name (missing: $path)"
        fi
    }

    check_dir() {
        local path="$1"
        local name="$2"
        CHECKS_TOTAL=$((CHECKS_TOTAL + 1))
        if [ -d "$path" ]; then
            echo "    ✓ $name"
            CHECKS_PASSED=$((CHECKS_PASSED + 1))
        else
            echo "    ✗ $name (missing: $path)"
        fi
    }

    echo "  Verification checklist:"
    check_file "$WORKSPACE_DIR/CLAUDE.md" "CLAUDE.md at workspace root"
    check_dir "$CLAUDE_MEMORY_DIR" "Memory directory"
    check_file "$WORKSPACE_DIR/.claude/settings.local.json" "Claude settings"
    check_dir "$MY_STRATEGY_DIR" "DS-strategy local repo"
    check_file "$MY_STRATEGY_DIR/.git/config" "DS-strategy is a git repo"

    echo ""
    echo "  Status: $CHECKS_PASSED/$CHECKS_TOTAL checks passed"
    echo ""

    # === Done ===
    echo "=========================================="
    echo "  Setup Complete!"
    echo "=========================================="
    echo ""
    echo "Summary:"
    echo "  CLAUDE.md   → $WORKSPACE_DIR/CLAUDE.md"
    echo "  Memory      → $CLAUDE_MEMORY_DIR"
    echo "  DS-strategy → $MY_STRATEGY_DIR"
    echo "  Template    → $TEMPLATE_DIR"
    echo ""
    echo "Next steps:"
    echo "  1. cd $WORKSPACE_DIR"
    echo "  2. Open workspace in VS Code or your editor"
    echo "  3. Start a new Claude Code session"
    echo "  4. Ask Claude: «Проведём первую стратегическую сессию»"
    echo ""
    echo "Updates:"
    echo "  cd $TEMPLATE_DIR && bash update.sh"
    echo ""
    echo "Setup finished: $(date)"

} | tee "$LOGFILE"

echo ""
echo "Full log saved to: $LOGFILE"
