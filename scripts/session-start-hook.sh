#!/bin/bash
# Session start hook - automatically run when starting development

echo "🚀 STARTING WEDDING GAME DEVELOPMENT SESSION"
echo "============================================="
echo ""

# Auto-prime Claude if in Claude Code environment
if [ "$CLAUDE_CODE_SESSION" = "true" ] || [ -n "$ANTHROPIC_API_KEY" ]; then
    echo "🤖 Auto-priming Claude with project context..."
    ./scripts/prime-claude.sh
    echo ""
fi

# Validate session setup
echo "🔍 Validating session setup..."
./scripts/validate-session-setup.sh
echo ""

# Check TaskMaster status
echo "📋 TaskMaster Status Check..."
if [ -f ".taskmaster/tasks.json" ]; then
    pending_tasks=$(grep '"status": "pending"' .taskmaster/tasks.json | wc -l)
    in_progress_tasks=$(grep '"status": "in_progress"' .taskmaster/tasks.json | wc -l)
    echo "  📍 $pending_tasks pending tasks, $in_progress_tasks in progress"
    
    # Show current phase
    current_phase=$(grep '"current_phase"' .taskmaster/tasks.json | cut -d'"' -f4)
    echo "  📍 Current phase: $current_phase"
    
    # Show next recommended task
    echo ""
    echo "🎯 RECOMMENDED NEXT ACTIONS:"
    if [ "$current_phase" = "discussion_foundation" ]; then
        echo "  1. Start with high-priority discussion task:"
        echo "     • hub_visual_style - What aesthetic matches the chaos?"
        echo "     • level_entrance_ideas - How should players access mini-games?"
        echo "     • character_hub_behaviors - How does Glen cause chaos?"
        echo ""
        echo "  2. Use discussion-driven approach:"
        echo "     • Ask design questions first"
        echo "     • Present 2-3 options"
        echo "     • Get approval before implementing"
    fi
else
    echo "  ❌ TaskMaster not available"
fi

echo ""
echo "🛠️  QUICK COMMANDS:"
echo "  • Prime Claude: make prime-claude"
echo "  • Check git status: git status"
echo "  • View MCP tools: python3 scripts/aggregate_tools.py --test"
echo "  • Validate setup: ./scripts/validate-session-setup.sh"
echo ""
echo "✅ SESSION READY FOR COLLABORATIVE DEVELOPMENT!"
echo "   Remember: Discussion first, implementation second"
echo ""