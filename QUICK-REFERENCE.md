# Wedding Game - Quick Reference

## Essential Commands

### Session Management
```bash
# Start development session
./scripts/dev-session-manager.sh start

# Check session status  
./scripts/dev-session-manager.sh status

# End session
./scripts/dev-session-manager.sh end
```

### Mobile Development
```bash
# Start mobile session
./scripts/mobile-dev-session.sh start

# Sync to mobile
./scripts/sync-mobile-work.sh push

# Sync from mobile
./scripts/sync-mobile-work.sh pull

# Test on mobile
./scripts/mobile-dev-session.sh test
```

### MCP Tools
```bash
# Test MCP aggregator
python3 scripts/aggregate_tools.py --test

# Check server status
python3 scripts/aggregate_tools.py --status [server_name]

# List available tools
python3 scripts/aggregate_tools.py --list
```

## Development Workflow

### 1. Daily Start
```bash
cd /home/joe/Projects/wedding-game
./scripts/dev-session-manager.sh start
```

### 2. Work on Feature
- Edit code in Cursor with full MCP integration
- Use TaskMaster for project management
- Test changes regularly

### 3. Mobile Development
```bash
./scripts/mobile-dev-session.sh start
# Work on mobile
./scripts/sync-mobile-work.sh push
```

### 4. End Session
```bash
./scripts/dev-session-manager.sh end
```

## File Locations

### Configuration
- `.env` - Environment variables (API keys)
- `.cursorrules` - AI collaboration rules
- `mcp-config.json` - MCP server configuration
- `/home/joe/.cursor/mcp.json` - Global MCP config

### Scripts
- `scripts/aggregate_tools.py` - MCP overflow aggregator
- `scripts/dev-session-manager.sh` - Session management
- `scripts/mobile-dev-session.sh` - Mobile development
- `scripts/sync-mobile-work.sh` - Mobile synchronization

### Documentation
- `README-DEVELOPMENT.md` - Complete development guide
- `QUICK-REFERENCE.md` - This file
- `docs/termux-setup.md` - Mobile setup guide
- `docs/master-workflow.md` - Complete workflow

## Character System

### Main Characters
- **Mark**: Punk drummer, drumstick attacks
- **Jenny**: Photographer, camera bombs
- **Glen**: Confused dad, makes things worse
- **Quinn**: Competent mom, manages chaos
- **Jack**: Hipster cafe owner
- **Acids Joe**: Psychedelic final boss

### Implementation Pattern
```gdscript
# All characters use state machines
extends Node2D

@onready var state_machine = $StateMachine
@onready var sprite_manager = SpriteManager.new()

func _ready():
    sprite_manager.create_sprite(character_name)
    state_machine.start("idle")
```

## MCP Server Overview

### Cursor Direct (40 tools)
- file-system: File operations
- github: Git and GitHub
- puppeteer: Web automation
- memory: Context storage

### Overflow Aggregator (84+ tools)
- taskmaster: Project management
- context7: Advanced context
- sequential-thinking: Problem solving  
- godot-mcp: Godot development
- serena: AI coordination
- zen: Focus tools
- tavily: Web search
- browser-tools: Browser automation

## Testing and Quality

### Test Commands
```bash
# Check for test framework first
ls package.json pyproject.toml Cargo.toml

# Run appropriate tests
npm test          # Node.js
pytest           # Python
cargo test       # Rust
godot --headless --script test_runner.gd  # Godot
```

### Code Quality
```bash
# Linting
npm run lint     # JavaScript/TypeScript
ruff check      # Python
gdtoolkit       # GDScript

# Type checking
npm run typecheck  # TypeScript
mypy            # Python
```

## Troubleshooting

### MCP Issues
```bash
# Test aggregator
python3 scripts/aggregate_tools.py --test

# Check specific server
python3 scripts/aggregate_tools.py --status taskmaster

# Restart session
./scripts/dev-session-manager.sh start
```

### Mobile Issues
```bash
# Check Termux setup
./scripts/mobile-dev-session.sh status

# Test connection
./scripts/sync-mobile-work.sh test

# Reinstall mobile environment
./scripts/mobile-dev-session.sh setup
```

### Git Issues
```bash
# Check status
git status

# Check remote
git remote -v

# Check API keys (should be placeholder)
grep -r "ghp_" .  # Should return no real tokens
```

## API Keys Required

### Essential
- `TAVILY_API_KEY`: Web search
- `GITHUB_TOKEN`: GitHub integration
- `OPENAI_API_KEY`: AI features

### Optional
- `CONTEXT7_API_KEY`: Advanced context
- `TASKMASTER_API_KEY`: Remote TaskMaster
- `ZEN_API_KEY`: Remote Zen tools

## Common Tasks

### Add New Character
1. Create character script in `characters/`
2. Add sprite config in `SpriteConfig.gd`
3. Create dialogue files in `dialogues/`
4. Add behavior tree in `behaviors/`

### Debug MCP Issues
1. Check session status: `./scripts/dev-session-manager.sh status`
2. Test aggregator: `python3 scripts/aggregate_tools.py --test`
3. Review logs: `ls .claude/`
4. Restart session: `./scripts/dev-session-manager.sh start`

### Mobile Development
1. Start mobile session: `./scripts/mobile-dev-session.sh start`
2. Edit code with nano/vim
3. Test changes: `./scripts/mobile-dev-session.sh test`
4. Sync to desktop: `./scripts/sync-mobile-work.sh push`

### Deploy Changes
1. Test locally: `./scripts/dev-session-manager.sh test`
2. Commit changes: `git add . && git commit -m "feat: description"`
3. Push to GitHub: `git push origin main`
4. Check CI/CD: `gh run list`

---

*Keep this reference handy for daily development!*