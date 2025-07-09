#!/bin/bash
# Model Aliases for VS Code Addons with OpenRouter Free Models
# Usage: source ./scripts/model-aliases.sh

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}🤖 Loading VS Code Addon Model Aliases...${NC}"

# Cline aliases (Code Generation)
alias cline-code='export CLINE_MODEL="qwen/qwen-2.5-coder-32b:free" && echo "Cline set to: Code Generation (Qwen 2.5 Coder 32B)"'
alias cline-impl='export CLINE_MODEL="qwen/qwen-2.5-coder-32b:free" && echo "Cline set to: Implementation (Qwen 2.5 Coder 32B)"'
alias cline-backup='export CLINE_MODEL="qwen/qwq-32b:free" && echo "Cline set to: Backup Model (Qwen QwQ 32B)"'

# Roo Code aliases (Code Analysis)
alias roo-analyze='export ROO_MODEL="deepseek/deepseek-v3-base:free" && echo "Roo set to: Code Analysis (DeepSeek V3 Base)"'
alias roo-debug='export ROO_MODEL="deepseek/deepseek-v3-base:free" && echo "Roo set to: Debugging (DeepSeek V3 Base)"'
alias roo-backup='export ROO_MODEL="meta-llama/llama-4-scout:free" && echo "Roo set to: Backup Model (Llama 4 Scout)"'

# Kilo Code aliases (Documentation)
alias kilo-docs='export KILO_MODEL="openrouter/optimus-alpha:free" && echo "Kilo set to: Documentation (OpenRouter Optimus Alpha)"'
alias kilo-explain='export KILO_MODEL="openrouter/optimus-alpha:free" && echo "Kilo set to: Explanations (OpenRouter Optimus Alpha)"'
alias kilo-backup='export KILO_MODEL="nous-research/deephermes-3:free" && echo "Kilo set to: Backup Model (DeepHermes-3)"'

# Combined workflow aliases
alias dev-code='cline-code && roo-analyze && kilo-docs && echo -e "${GREEN}✅ Development workflow ready: Cline(Code) + Roo(Analysis) + Kilo(Docs)${NC}"'
alias dev-debug='roo-debug && cline-impl && kilo-explain && echo -e "${GREEN}✅ Debug workflow ready: Roo(Debug) + Cline(Fix) + Kilo(Explain)${NC}"'
alias dev-docs='kilo-docs && roo-analyze && cline-impl && echo -e "${GREEN}✅ Documentation workflow ready: Kilo(Docs) + Roo(Analysis) + Cline(Examples)${NC}"'

# Gemini CLI aliases for large codebase analysis
alias gemini-full='gemini -p "@./ Analyze entire wedding-game project structure and architecture"'
alias gemini-godot='gemini -p "@autoload/ @scenes/ @scripts/ Analyze Godot game architecture and patterns"'
alias gemini-tests='gemini -p "@tests/ @src/ Analyze test coverage and identify missing tests"'
alias gemini-docs='gemini -p "@docs/ @README.md @CLAUDE.md Analyze project documentation completeness"'
alias gemini-config='gemini -p "@mcp-config*.json @.vscode/ @scripts/ Analyze MCP and VS Code configuration"'

# MCP integration aliases
alias mcp-memory='python3 scripts/aggregate_tools.py --test | grep memory && echo -e "${GREEN}✅ Memory tools available${NC}"'
alias mcp-thinking='python3 scripts/aggregate_tools.py --test | grep sequential-thinking && echo -e "${GREEN}✅ Sequential thinking available${NC}"'
alias mcp-search='python3 scripts/aggregate_tools.py --test | grep brave-search && echo -e "${GREEN}✅ Brave search available${NC}"'
alias mcp-all='mcp-memory && mcp-thinking && mcp-search'

# Status check aliases
alias model-status='echo -e "${YELLOW}Current Models:${NC}" && echo "Cline: $CLINE_MODEL" && echo "Roo: $ROO_MODEL" && echo "Kilo: $KILO_MODEL"'
alias addon-help='echo -e "${BLUE}Available Aliases:${NC}" && echo "Code Gen: cline-code, cline-impl" && echo "Analysis: roo-analyze, roo-debug" && echo "Docs: kilo-docs, kilo-explain" && echo "Workflows: dev-code, dev-debug, dev-docs" && echo "Gemini: gemini-full, gemini-godot, gemini-tests, gemini-docs, gemini-config" && echo "MCP: mcp-memory, mcp-thinking, mcp-search" && echo "Status: model-status"'

# Initialize with optimal models
export CLINE_MODEL="qwen/qwen-2.5-coder-32b:free"
export ROO_MODEL="deepseek/deepseek-v3-base:free"
export KILO_MODEL="openrouter/optimus-alpha:free"

echo -e "${GREEN}✅ Model aliases loaded!${NC}"
echo -e "${YELLOW}💡 Type 'addon-help' to see available commands${NC}"
echo -e "${YELLOW}💡 Type 'model-status' to check current models${NC}"
echo -e "${YELLOW}💡 Type 'dev-code' to set up development workflow${NC}"