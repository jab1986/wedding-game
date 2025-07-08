# Wedding Game - Complete Development Setup

## Overview
This is a chaotic wedding adventure game built with Godot 4.3+, featuring an AI-augmented development environment with MCP (Model Context Protocol) integration.

## Quick Start

### Session Management
```bash
# Start development session
./scripts/dev-session-manager.sh start

# Check session status
./scripts/dev-session-manager.sh status

# End session
./scripts/dev-session-manager.sh end
```

### Environment Setup
1. Copy `example.env.txt` to `.env`
2. Fill in your API keys:
   - `TAVILY_API_KEY`: For web search capabilities
   - `OPENAI_API_KEY`: For AI features
   - `GITHUB_TOKEN`: For GitHub integration
   - `CONTEXT7_API_KEY`: For context management

## MCP Integration

### Architecture
- **Cursor Direct**: 40 priority tools (file operations, git, core development)
- **Overflow Aggregator**: 84+ additional tools via Python aggregator
- **Total Access**: 124+ specialized development tools

### Available MCP Servers
- **file-system**: File operations and management
- **github**: Repository management and API access
- **puppeteer**: Web automation and testing
- **taskmaster**: Project management and task coordination
- **context7**: Context and memory management
- **sequential-thinking**: Structured problem solving
- **godot-mcp**: Godot-specific development tools
- **serena**: AI assistant coordination
- **zen**: Meditation and focus tools
- **tavily**: Web search and research
- **browser-tools**: Browser automation

### Configuration Files
- **Global MCP**: `/home/joe/.cursor/mcp.json`
- **Local Config**: `./mcp-config.json`
- **Practical Config**: `./mcp-config-practical.json`

## Project Structure

```
wedding-game/
├── scripts/
│   ├── aggregate_tools.py      # MCP overflow aggregator
│   ├── dev-session-manager.sh  # Session management
│   ├── mobile-dev-session.sh   # Mobile development
│   └── sync-mobile-work.sh     # Mobile sync
├── docs/
│   ├── termux-setup.md         # Mobile development setup
│   └── master-workflow.md      # Complete workflow guide
├── .cursorrules                # AI collaboration rules
├── .env                        # Environment variables
├── mcp-config.json             # MCP server configuration
└── README-DEVELOPMENT.md       # This file
```

## Development Workflow

### 1. Session Initialization
```bash
# Automated session start
./scripts/dev-session-manager.sh start
```

**What it does:**
- Loads environment variables
- Checks MCP server status
- Displays current tasks
- Shows git status
- Validates tool availability

### 2. Core Development
- **State Machine Pattern**: All entities use state machines
- **Sprite Management**: Centralized through `SpriteConfig.gd`
- **Dialogue System**: Integrated with Dialogue Manager plugin
- **Behavior Trees**: Boss AI using Beehave plugin

### 3. Character System
- **Mark**: Punk drummer with drumstick attacks
- **Jenny**: Photographer with camera bombs
- **Glen**: Confused dad who makes things worse
- **Quinn**: Competent mom managing chaos
- **Jack**: Hipster cafe owner
- **Acids Joe**: Psychedelic final boss

### 4. Mobile Development
```bash
# Start mobile development session
./scripts/mobile-dev-session.sh start

# Sync work to mobile
./scripts/sync-mobile-work.sh push

# Sync work from mobile
./scripts/sync-mobile-work.sh pull
```

## TaskMaster Integration

### Project Epics
1. **Core Architecture Foundation**
   - State machine implementation
   - Sprite management system
   - Plugin integration

2. **Character Implementation**
   - Character behavior trees
   - Dialogue system integration
   - Combat mechanics

3. **Mobile Development Support**
   - Termux environment setup
   - Cross-platform workflows
   - Synchronization scripts

### Memory Storage
- Character personalities and behaviors
- Technical architecture patterns
- Development workflow preferences
- Mobile development configurations

## Testing and Quality

### Commands
```bash
# Run tests (check for test framework first)
npm test  # or pytest, or godot --headless --script test_runner.gd

# Lint code
npm run lint  # or ruff check, or gdtoolkit

# Type checking
npm run typecheck  # or mypy, or gdscript analyzer
```

### Pre-commit Hooks
- Code formatting
- Lint checking
- Type validation
- Test execution

## Troubleshooting

### MCP Server Issues
```bash
# Test MCP aggregator
python3 scripts/aggregate_tools.py --test

# Check individual server status
python3 scripts/aggregate_tools.py --status taskmaster

# Restart MCP services
./scripts/dev-session-manager.sh start
```

### Mobile Development
- **Termux**: Use `./scripts/mobile-dev-session.sh` for environment setup
- **Sync Issues**: Check network connectivity and API keys
- **Tool Limitations**: Some MCP servers may not be available on mobile

### Git and GitHub
- **Push Protection**: Use placeholder API keys in commits
- **Large Files**: Use Git LFS for assets
- **Branch Strategy**: Feature branches for major changes

## Security

### API Key Management
- Store in `.env` file (git-ignored)
- Use placeholder values in example files
- Rotate keys regularly
- Never commit real keys to repository

### GitHub Integration
- Personal access tokens for API access
- Push protection enabled
- Secret scanning active
- Branch protection rules

## Performance Optimization

### MCP Aggregator
- Overflow handling for 40+ tool limit
- Intelligent routing based on tool priority
- Connection pooling for server efficiency

### Development Environment
- Session state persistence
- Context preservation across restarts
- Mobile-desktop synchronization

## Contributing

### Code Style
- GDScript: `snake_case` functions and variables
- Python: PEP 8 compliance
- Shell: POSIX compatibility
- Documentation: Markdown format

### Commit Messages
- Use conventional commits format
- Include tool attribution: "🤖 Generated with Claude Code"
- Co-authored by: Claude <noreply@anthropic.com>

## Mobile Development with Termux

### Setup
1. Install Termux from F-Droid
2. Run setup script: `./scripts/mobile-dev-session.sh setup`
3. Configure SSH keys for synchronization
4. Install required packages: `python3`, `git`, `nodejs`

### Workflow
1. Start mobile session: `./scripts/mobile-dev-session.sh start`
2. Work on code using nano/vim
3. Test changes: `./scripts/mobile-dev-session.sh test`
4. Sync to desktop: `./scripts/sync-mobile-work.sh push`

### Limitations
- Limited MCP server support
- Reduced tool availability
- Network dependency for synchronization
- Battery and performance constraints

## Advanced Features

### AI-Augmented Development
- 124+ specialized tools via MCP
- Intelligent code generation
- Automated testing and validation
- Context-aware suggestions

### Cross-Platform Support
- Desktop development (primary)
- Mobile development (Termux)
- Cloud synchronization
- Offline capability

### Integration Ecosystem
- Godot 4.3+ game engine
- Multiple MCP servers
- TaskMaster project management
- GitHub repository integration

## Support and Documentation

### Quick Reference
- See `QUICK-REFERENCE.md` for command cheatsheet
- Check `docs/` directory for detailed guides
- Review `.cursorrules` for AI collaboration patterns

### Getting Help
- Check session status: `./scripts/dev-session-manager.sh status`
- Test MCP tools: `python3 scripts/aggregate_tools.py --test`
- Review logs in `.claude/` directory

---

*Generated with AI-augmented development tools - Wedding Game Project 2024*