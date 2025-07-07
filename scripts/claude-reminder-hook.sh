#!/bin/bash
# Claude reminder hook - run this when Claude needs context

echo "🤖 CLAUDE CONTEXT REMINDER"
echo "=========================="
echo ""

# Check if Claude has been primed recently
if [ -f ".claude-last-primed" ]; then
    last_primed=$(cat .claude-last-primed)
    echo "📅 Last primed: $last_primed"
else
    echo "⚠️  Claude has not been primed this session"
fi

echo ""
echo "🔄 TO PRIME CLAUDE:"
echo "  • Run: make prime-claude"
echo "  • Or say: 'prime' in chat"
echo "  • Or read: CLAUDE.md manually"
echo ""

echo "🚨 EMERGENCY PROTOCOL:"
echo "  • If Claude starts implementing without discussion:"
echo "  • Say: 'Stop - discuss first'"
echo "  • Claude will immediately switch to design questions"
echo ""

echo "📋 DISCUSSION CHECKLIST:"
echo "  ✅ Ask 'What aesthetic are you envisioning?'"
echo "  ✅ Present 2-3 options for user choice"
echo "  ✅ Get approval before any implementation"
echo "  ✅ Reference TaskMaster tasks for priorities"
echo ""

echo "🎯 CURRENT FOCUS:"
echo "  • Discussion-driven development"
echo "  • Hub world visual design decisions"
echo "  • Character behavior planning"
echo "  • Creative collaboration over code"
echo ""

# Update primed timestamp
echo "$(date '+%Y-%m-%d %H:%M:%S')" > .claude-last-primed