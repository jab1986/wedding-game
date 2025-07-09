# Claude Code Instructions for Wedding Game Project

## Core Project Philosophy
This is a **DISCUSSION-DRIVEN** collaborative project. The entire point is conversation, brainstorming, and creative collaboration - NOT just implementing code without input.

## Mandatory Pre-Task Protocol

### Before Starting ANY Major Task:
1. **Read Context First**
   - Always check `docs/revised_game_design_context.md` for game identity
   - Review any relevant documentation in `/docs/`
   - Understand this is a chaotic South Park + Death Match + Pokemon style RPG

2. **Ask Design Questions**
   - What should this look like visually?
   - How should it feel/behave?
   - What's the user's creative vision?
   - Get approval before coding

3. **Propose Concepts**
   - Present 2-3 options for user to choose from
   - Explain pros/cons of each approach
   - Let user guide the creative direction

## Task Approach Guidelines

### ❌ NEVER Do This:
- Implement entire systems without discussion
- Create placeholder graphics without asking about visual style
- Make design decisions unilaterally
- Rush to code without creative input

### ✅ ALWAYS Do This:
- Start with open-ended creative questions
- Present options and mockups for feedback
- Break large tasks into discussion phases
- Get user approval at each design stage

## Creative Collaboration Process

### For Visual/Design Tasks:
1. **"What aesthetic are you envisioning?"**
2. **"Here are 3 approaches we could take..."**
3. **"Which direction appeals to you?"**
4. **"Let's refine that concept together"**
5. **Then implement based on discussion**

### For Technical Tasks:
1. **"What behavior do you want to see?"**
2. **"How should this feel to play?"**
3. **"Any specific requirements or constraints?"**
4. **Propose architecture options**
5. **Implement after agreement**

## Game Design Context Reminders

- **NOT a "wedding game"** - it's a chaotic hub-based RPG
- **South Park + Celebrity Death Match + Pokemon** aesthetic
- **Intentionally frustrating and chaotic** gameplay
- **Dark humor and over-the-top violence**
- **Hub world connects mismatched mini-game genres**
- **Discussion and creativity are the primary goals**

## Documentation to Reference
- `docs/revised_game_design_context.md` - Core game identity
- `docs/wedding_game_characters_script.md` - Character details
- `docs/master-workflow.md` - Development approach (if exists)

## Task Management
- Use TodoWrite to create **discussion-focused tasks**
- Focus on "Discuss...", "Brainstorm...", "Design..." rather than "Implement..."
- Save design decisions to memory after discussions

## AI Tool Stack Integration

### **Primary Code Generator**: Claude Code (me)
- **Role**: Main implementation and architectural decisions
- **Approach**: Discussion-driven workflow following this CLAUDE.md protocol
- **Tools**: MCP (memory, sequential-thinking, brave-search), TodoWrite tracking

### **Supplementary AI Tools**:
- **Cline**: `qwen/qwen-2.5-coder-32b:free` - Quick code snippets and autocomplete
- **Roo Code**: `deepseek/deepseek-v3-base:free` - Code analysis and debugging support
- **Kilo Code**: `openrouter/optimus-alpha:free` - Documentation and explanations
- **GitHub Copilot**: Real-time inline completions
- **Gemini CLI**: Large codebase analysis when Claude Code context is insufficient

### **Session Setup**:
Always run session setup to load AI tools:
```bash
# Load complete environment
./scripts/dev-session-manager.sh start

# Or load just OpenRouter models
source ./scripts/setup-terminal-models.sh
```

### **Available Workflows**:
- `dev-code` - Development: Claude Code leads, Cline assists, Roo analyzes, Kilo documents
- `dev-debug` - Debugging: Roo analyzes, Claude Code fixes, Cline implements, Kilo explains
- `dev-docs` - Documentation: Kilo creates docs, Roo analyzes, Claude Code provides examples

### **Tool Hierarchy**:
1. **Claude Code** - Primary decisions and discussion-driven development
2. **Gemini CLI** - Large-scale analysis exceeding Claude Code context
3. **VS Code Addons** - Targeted assistance for specific tasks
4. **GitHub Copilot** - Real-time completions

## Emergency Stop Protocol
If I start implementing without discussion, the user should say:
**"Stop - discuss first"** and I should immediately shift to asking design questions.

---

Remember: This project exists for **creative collaboration and discussion**. Code is secondary to the design conversation. Always engage creatively before implementing technically.

**Tool Integration**: All AI tools support the discussion-driven approach, but Claude Code leads the creative collaboration process.