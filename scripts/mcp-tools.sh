#!/bin/bash
# MCP Tools Wrapper Script
# Usage: ./scripts/mcp-tools.sh <tool_name> <arguments_json>

if [ $# -lt 2 ]; then
    echo "Usage: $0 <tool_name> <arguments_json>"
    echo ""
    echo "Available tools:"
    python3 scripts/aggregate_tools.py --test | grep "  - " | head -10
    exit 1
fi

TOOL_NAME="$1"
ARGUMENTS="$2"

echo "🤖 Calling MCP tool: $TOOL_NAME"
echo "📝 Arguments: $ARGUMENTS"
echo ""

python3 scripts/aggregate_tools.py --call "$TOOL_NAME" "$ARGUMENTS"