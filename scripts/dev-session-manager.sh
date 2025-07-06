#!/bin/bash
# Wedding Game - Complete Development Session Manager
# Handles both Cursor integration and TaskMaster coordination

ACTION=${1:-start}

case $ACTION in
    "start")
        echo "🚀 Starting Complete Development Session"
        echo "========================================"
        
        # Ensure project directory
        cd /home/joe/Projects/wedding-game
        
        # Load environment variables
        if [ -f .env ]; then
            export $(cat .env | xargs)
            echo "✅ Environment variables loaded"
        fi
        
        # Check TaskMaster status
        echo "📋 Checking TaskMaster status..."
        if python3 scripts/aggregate_tools.py --test | grep -q "taskmaster"; then
            echo "✅ TaskMaster available via MCP aggregator"
        else
            echo "⚠️  TaskMaster connection issue"
        fi
        
        # Display current active tasks
        echo "📋 Current Development Focus:"
        echo "   - Core Architecture Foundation (State machines, SpriteManager)"
        echo "   - Character Implementation (Mark, Jenny, Glen, Quinn)"
        echo "   - Mobile development support via Termux"
        
        # Check Git status
        echo ""
        echo "📊 Git Status:"
        git status --porcelain | head -5
        BRANCH=$(git branch --show-current)
        echo "🌿 Current branch: $BRANCH"
        
        # Check MCP server status
        echo ""
        echo "🔧 MCP Infrastructure:"
        if python3 scripts/aggregate_tools.py --test | grep -q "Overflow tools available"; then
            TOOL_COUNT=$(python3 scripts/aggregate_tools.py --test | grep "Overflow tools available" | grep -o '[0-9]\+')
            echo "✅ MCP Aggregator: $TOOL_COUNT overflow tools available"
        else
            echo "⚠️  MCP Aggregator may need restart"
        fi
        
        echo ""
        echo "✨ Session initialized! Ready for AI-augmented development."
        
        ;;
        
    "end")
        echo "💾 Ending Complete Development Session"
        echo "====================================="
        
        SESSION_DATE=$(date '+%Y-%m-%d %H:%M')
        SESSION_BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
        SESSION_CHANGES=$(git status --porcelain | wc -l)
        
        echo "📊 Session Summary:"
        echo "  - Date: $SESSION_DATE"
        echo "  - Branch: $SESSION_BRANCH" 
        echo "  - Modified files: $SESSION_CHANGES"
        
        # Check for uncommitted changes
        if [ -n "$(git status --porcelain)" ]; then
            echo ""
            echo "⚠️  Uncommitted Changes Detected:"
            git status --short
            echo ""
            echo "💡 Consider committing changes before ending session"
        else
            echo "✅ All changes committed"
        fi
        
        # Auto-push to GitHub if changes exist
        if [ -n "$(git status --porcelain)" ]; then
            echo ""
            echo "🔄 Auto-pushing changes to GitHub..."
            git add .
            git commit -m "dev session: auto-commit session work - $(date '+%Y-%m-%d %H:%M')

🤖 Generated with Claude Code

Co-Authored-By: Claude <noreply@anthropic.com>"
            
            if git push origin main; then
                echo "✅ Changes pushed to GitHub successfully"
            else
                echo "⚠️  Failed to push to GitHub - check connection"
            fi
        else
            echo "📝 No changes to push"
        fi
        
        echo ""
        echo "🌟 Session ended successfully!"
        
        ;;
        
    "status")
        echo "📊 Development Session Status"
        echo "============================"
        
        echo "🔧 MCP Tools Status:"
        python3 scripts/aggregate_tools.py --test | grep "Overflow tools available" || echo "   MCP aggregator needs check"
        
        echo ""
        echo "🌿 Git Status:"
        echo "   Branch: $(git branch --show-current)"
        echo "   Uncommitted: $(git status --porcelain | wc -l) files"
        
        ;;
        
    *)
        echo "❌ Unknown command: $ACTION"
        echo "Usage: $0 [start|end|status]"
        exit 1
        ;;
esac