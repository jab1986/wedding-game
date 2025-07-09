#!/bin/bash
# Test OpenRouter Models Script
# Usage: ./scripts/test-openrouter-models.sh

echo "🧪 Testing OpenRouter Models..."

# Check if environment is set up
if [ -z "$OPENROUTER_API_KEY" ]; then
    echo "⚠️  OpenRouter API key not set. Run: source ./scripts/setup-terminal-models.sh"
    exit 1
fi

# Test Cline model (Code Generation)
echo ""
echo "🤖 Testing Cline Model ($CLINE_MODEL)..."
curl -s -X POST "https://openrouter.ai/api/v1/chat/completions" \
  -H "Authorization: Bearer $OPENROUTER_API_KEY" \
  -H "Content-Type: application/json" \
  -d "{
    \"model\": \"$CLINE_MODEL\",
    \"messages\": [
      {\"role\": \"user\", \"content\": \"Write a simple Python function that adds two numbers\"}
    ],
    \"max_tokens\": 150
  }" | jq -r '.choices[0].message.content' | head -5

# Test Roo model (Analysis)
echo ""
echo "🔍 Testing Roo Model ($ROO_MODEL)..."
curl -s -X POST "https://openrouter.ai/api/v1/chat/completions" \
  -H "Authorization: Bearer $OPENROUTER_API_KEY" \
  -H "Content-Type: application/json" \
  -d "{
    \"model\": \"$ROO_MODEL\",
    \"messages\": [
      {\"role\": \"user\", \"content\": \"Analyze this code: def add(a, b): return a + b\"}
    ],
    \"max_tokens\": 150
  }" | jq -r '.choices[0].message.content' | head -5

# Test Kilo model (Documentation)
echo ""
echo "📚 Testing Kilo Model ($KILO_MODEL)..."
curl -s -X POST "https://openrouter.ai/api/v1/chat/completions" \
  -H "Authorization: Bearer $OPENROUTER_API_KEY" \
  -H "Content-Type: application/json" \
  -d "{
    \"model\": \"$KILO_MODEL\",
    \"messages\": [
      {\"role\": \"user\", \"content\": \"Write documentation for a Python add function\"}
    ],
    \"max_tokens\": 150
  }" | jq -r '.choices[0].message.content' | head -5

echo ""
echo "✅ OpenRouter model testing complete!"
echo "💡 Models are ready for use in VS Code addons"