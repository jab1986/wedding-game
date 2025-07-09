#!/bin/bash
# Setup Terminal Environment for OpenRouter Models
# Usage: source ./scripts/setup-terminal-models.sh

echo "🚀 Setting up OpenRouter models in terminal environment..."

# Export API key from VS Code settings
export OPENROUTER_API_KEY="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"

# Export model configurations
export CLINE_MODEL="qwen/qwen-2.5-coder-32b:free"
export ROO_MODEL="deepseek/deepseek-v3-base:free"
export KILO_MODEL="openrouter/optimus-alpha:free"

# Test OpenRouter connection
echo "🔑 Testing OpenRouter API connection..."
if curl -s -H "Authorization: Bearer $OPENROUTER_API_KEY" -H "Content-Type: application/json" https://openrouter.ai/api/v1/models | grep -q "qwen"; then
    echo "✅ OpenRouter API key is working!"
else
    echo "⚠️  OpenRouter API key may have issues - check your connection"
fi

# Display current configuration
echo ""
echo "📋 Current Model Configuration:"
echo "  Cline (Code Snippets): $CLINE_MODEL"
echo "  Roo (Analysis): $ROO_MODEL"
echo "  Kilo (Documentation): $KILO_MODEL"
echo "  OpenRouter API: ${OPENROUTER_API_KEY:0:20}..."

# Load aliases
if [ -f "./scripts/model-aliases.sh" ]; then
    source ./scripts/model-aliases.sh
fi

echo ""
echo "✨ Terminal environment ready for OpenRouter models!"
echo "💡 Use 'dev-code', 'dev-debug', or 'dev-docs' to set workflows"
echo "📖 See CLAUDE.md for AI Tool Stack Integration details"
echo "🎯 Claude Code remains primary code generator (discussion-driven)"