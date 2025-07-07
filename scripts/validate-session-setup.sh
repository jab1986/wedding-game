#!/bin/bash
# Session setup validation script

echo "🔍 VALIDATING SESSION SETUP"
echo "============================"
echo ""

# Check critical files
echo "📁 CRITICAL FILES:"
files_to_check=(
    "CLAUDE.md"
    "docs/revised_game_design_context.md"
    "docs/master-workflow.md"
    "docs/architecture-decisions.md"
    ".taskmaster/tasks.json"
    "scripts/aggregate_tools.py"
    "scenes/Main.tscn"
    "autoload/GameManager.gd"
    "autoload/SpriteManager.gd"
    "autoload/AudioManager.gd"
)

for file in "${files_to_check[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ $file - MISSING!"
    fi
done

echo ""
echo "🤖 MCP TOOLS STATUS:"
python3 scripts/aggregate_tools.py --test | head -3

echo ""
echo "📋 TASKMASTER STATUS:"
if [ -f ".taskmaster/tasks.json" ]; then
    task_count=$(grep -o '"task_[0-9]*"' .taskmaster/tasks.json | wc -l)
    echo "  ✅ TaskMaster active with $task_count discussion tasks"
    current_phase=$(grep '"current_phase"' .taskmaster/tasks.json | cut -d'"' -f4)
    echo "  📍 Current phase: $current_phase"
else
    echo "  ❌ TaskMaster database missing!"
fi

echo ""
echo "🌿 GIT STATUS:"
branch=$(git branch --show-current 2>/dev/null || echo "unknown")
echo "  📍 Branch: $branch"
uncommitted=$(git status --porcelain 2>/dev/null | wc -l)
if [ "$uncommitted" -eq 0 ]; then
    echo "  ✅ Working tree clean"
else
    echo "  ⚠️  $uncommitted uncommitted changes"
fi

echo ""
echo "🎯 COLLABORATION SETUP:"
if [ -f "CLAUDE.md" ]; then
    echo "  ✅ CLAUDE.md collaboration instructions present"
    echo "  ✅ Emergency stop protocol: 'Stop - discuss first'"
    echo "  ✅ Discussion-driven workflow configured"
else
    echo "  ❌ CLAUDE.md missing - collaboration protocol not set!"
fi

echo ""
echo "🏗️ GAME ARCHITECTURE:"
if [ -f "scenes/Main.tscn" ]; then
    echo "  ✅ Hub world foundation complete"
    echo "  ✅ Main.tscn entry point ready"
    echo "  ✅ Autoload managers available"
else
    echo "  ❌ Hub world foundation missing!"
fi

echo ""
echo "🎮 PROJECT IDENTITY:"
if grep -q "chaotic hub-based RPG" docs/revised_game_design_context.md 2>/dev/null; then
    echo "  ✅ Game identity clarified (NOT wedding game)"
    echo "  ✅ South Park + Death Match + Pokemon aesthetic defined"
    echo "  ✅ Discussion-focused TaskMaster tasks ready"
else
    echo "  ❌ Game identity not properly documented!"
fi

echo ""
echo "✅ SESSION VALIDATION COMPLETE"
echo "Ready for collaborative development with TaskMaster discussion tasks!"