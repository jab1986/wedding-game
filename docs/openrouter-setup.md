# OpenRouter Setup Guide for VS Code Addons

## 🎯 Recommended Model Configuration

### **Cline (Code Generation)**
- **Model**: `qwen/qwen-2.5-coder-32b:free`
- **Purpose**: Primary code generation and implementation
- **Strengths**: 32B parameters optimized for coding, excellent syntax understanding
- **Perfect for**: Godot GDScript development, implementing game features

### **Roo Code (Code Analysis)**
- **Model**: `deepseek/deepseek-v3-base:free`
- **Purpose**: Code analysis and debugging
- **Strengths**: Technical domain optimization, strong reasoning
- **Perfect for**: Understanding existing codebase, debugging issues

### **Kilo Code (Documentation)**
- **Model**: `openrouter/optimus-alpha:free`
- **Purpose**: Documentation and explanations
- **Strengths**: General-purpose assistant, excellent instruction following
- **Perfect for**: Discussion-driven workflow, creating documentation

### **GitHub Copilot**
- **Model**: GitHub's native model
- **Purpose**: Real-time code completion
- **Strengths**: Inline suggestions, context-aware completions
- **Perfect for**: Autocomplete and code snippets

### **Gemini CLI**
- **Tool**: `gemini` command line
- **Purpose**: Large codebase analysis with massive context window
- **Strengths**: Handles entire codebases, @ syntax for file inclusion
- **Perfect for**: Project-wide analysis when Claude Code's context is insufficient

## 🔧 Setup Instructions

### 1. Get OpenRouter API Key
1. Visit [OpenRouter.ai](https://openrouter.ai)
2. Create account and get your API key
3. Add to your environment or VS Code settings

### 2. Update VS Code Settings
Replace `"your-openrouter-api-key-here"` in `.vscode/settings.json`:
```json
"OPENROUTER_API_KEY": "your-actual-api-key-here"
```

### 3. Load Model Aliases
```bash
# In your terminal (run in same session)
source ./scripts/model-aliases.sh
model-status  # Check current models

# Or run the dev session manager (recommended)
./scripts/dev-session-manager.sh start
```

### 4. Add to Your Shell Profile (Optional)
Add to `~/.bashrc` or `~/.zshrc`:
```bash
# Auto-load model aliases for wedding-game project
if [ -f "$HOME/Projects/wedding-game/scripts/model-aliases.sh" ]; then
    source "$HOME/Projects/wedding-game/scripts/model-aliases.sh"
fi
```

## 📱 Available Aliases

### **Individual Model Selection**
```bash
cline-code       # Set Cline to code generation
roo-analyze      # Set Roo to code analysis  
kilo-docs        # Set Kilo to documentation
```

### **Workflow Combinations**
```bash
dev-code         # Development: Cline(Code) + Roo(Analysis) + Kilo(Docs)
dev-debug        # Debugging: Roo(Debug) + Cline(Fix) + Kilo(Explain)  
dev-docs         # Documentation: Kilo(Docs) + Roo(Analysis) + Cline(Examples)
```

### **MCP Integration**
```bash
mcp-memory       # Test memory tools
mcp-thinking     # Test sequential thinking
mcp-search       # Test brave search
mcp-all          # Test all MCP tools
```

### **Gemini CLI Analysis**
```bash
gemini-full      # Analyze entire project
gemini-godot     # Analyze Godot architecture
gemini-tests     # Check test coverage
gemini-docs      # Analyze documentation
gemini-config    # Analyze MCP/VS Code config
```

### **Status & Help**
```bash
model-status     # Show current models
addon-help       # Show all available commands
```

## 🎮 Game Development Workflow

### **For New Features**
1. `dev-code` - Set up development workflow
2. Use **Claude Code** for main implementation (discussion-driven)
3. Use **Gemini CLI** for large codebase analysis if needed
4. Use **Roo** for targeted code analysis
5. Use **Cline** for quick implementations
6. Use **Kilo** for documentation
7. Use **GitHub Copilot** for real-time completions

### **For Debugging**
1. `dev-debug` - Set up debugging workflow
2. Use **Roo** for issue analysis
3. Use **Cline** for fixes
4. Use **Kilo** for explanations

### **For Documentation**
1. `dev-docs` - Set up documentation workflow
2. Use **Kilo** for writing docs
3. Use **Roo** for code analysis
4. Use **Cline** for code examples

## 🔄 MCP Integration Benefits

Each addon can leverage our MCP tools:
- **Memory**: Store design decisions and context
- **Sequential Thinking**: Complex problem solving
- **Brave Search**: Web research for solutions
- **Postgres**: Database queries (when needed)

## 🧠 When to Use Gemini CLI

**Use Gemini CLI when:**
- Analyzing entire codebase structure
- Claude Code's context window is insufficient
- Need project-wide pattern analysis
- Checking if features are implemented across multiple files
- Verifying test coverage across the entire project
- Understanding complex architectural relationships

**Example Gemini CLI commands:**
```bash
# Check if character abilities are implemented
gemini -p "@autoload/ @scenes/ @scripts/ Has Mark's drumstick ability system been implemented? Show all related files"

# Analyze game architecture
gemini -p "@./ Analyze the South Park + Pokemon style game architecture and identify missing components"

# Check test coverage
gemini -p "@tests/ @scenes/ @autoload/ What percentage of the codebase has test coverage? List untested files"
```

## 🆓 Free Model Limits

All recommended models are free but have rate limits:
- **Qwen 2.5 Coder 32B**: Excellent for coding tasks
- **DeepSeek V3 Base**: Great for analysis
- **OpenRouter Optimus Alpha**: Perfect for documentation

## 🛠️ Troubleshooting

### **If a model isn't working:**
1. Check your OpenRouter API key
2. Try backup models: `cline-backup`, `roo-backup`, `kilo-backup`
3. Check rate limits on OpenRouter dashboard

### **If MCP tools aren't working:**
1. Run `mcp-all` to test connections
2. Check `python3 scripts/aggregate_tools.py --test`
3. Restart VS Code if needed

---

**Remember**: This setup integrates perfectly with our discussion-driven development workflow from `CLAUDE.md`!