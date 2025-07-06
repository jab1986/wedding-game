# Master Workflow - Complete Development Guide

## Overview
This guide provides the complete workflow for developing the Wedding Game project, integrating all tools, platforms, and methodologies.

## Daily Development Cycle

### 1. Morning Session Start
```bash
# Desktop Development
cd /home/joe/Projects/wedding-game
./scripts/dev-session-manager.sh start

# Mobile Development (if on mobile)
./scripts/mobile-dev-session.sh start
```

**What This Does:**
- Loads environment variables and API keys
- Checks MCP server status (124+ tools available)
- Validates TaskMaster connection
- Displays current project status
- Shows git branch and changes

### 2. Project Planning (TaskMaster)
```bash
# Check current tasks
python3 scripts/aggregate_tools.py --call taskmaster list_tasks

# Create new epic or task
python3 scripts/aggregate_tools.py --call taskmaster create_task "Feature Description"

# Update task status
python3 scripts/aggregate_tools.py --call taskmaster update_task TASK_ID "in_progress"
```

### 3. Development Work
**Character Implementation:**
```gdscript
# Follow established patterns
extends Node2D

@onready var state_machine = $StateMachine
@onready var sprite_manager = SpriteManager.new()

func _ready():
    sprite_manager.create_sprite("character_name")
    state_machine.start("idle")
```

**Dialogue Creation:**
```yaml
# dialogues/character_name.yaml
start:
  - "Welcome to the wedding!"
  - jump: next_scene
```

### 4. Testing and Quality Assurance
```bash
# Run tests (check project for test framework)
npm test                    # Node.js projects
pytest                     # Python projects
godot --headless --script test_runner.gd  # Godot projects

# Code quality checks
npm run lint               # JavaScript/TypeScript
ruff check                # Python
gdtoolkit                 # GDScript

# Type checking
npm run typecheck         # TypeScript
mypy                      # Python
```

### 5. Mobile Development Integration
```bash
# Start mobile session
./scripts/mobile-dev-session.sh start

# Work on mobile (nano/vim)
nano src/characters/NewCharacter.gd

# Test mobile changes
./scripts/mobile-dev-session.sh test

# Sync to desktop
./scripts/sync-mobile-work.sh push
```

### 6. Version Control
```bash
# Check status
git status

# Stage changes
git add .

# Commit with conventional format
git commit -m "feat: add new character dialogue system

- Implement Mark's drumstick attack mechanics
- Add Jenny's camera bomb feature
- Update state machine for all characters

🤖 Generated with Claude Code

Co-Authored-By: Claude <noreply@anthropic.com>"

# Push to GitHub
git push origin main
```

### 7. Evening Session End
```bash
# End session with summary
./scripts/dev-session-manager.sh end

# Update TaskMaster
python3 scripts/aggregate_tools.py --call taskmaster update_task_status
```

## Feature Development Workflow

### 1. Planning Phase
- **TaskMaster Epic Creation**: Break down feature into tasks
- **Architecture Design**: Review existing patterns
- **Resource Planning**: Identify sprites, sounds, dialogues needed

### 2. Implementation Phase
- **Core Logic**: Implement state machines and behaviors
- **Visual Assets**: Create/integrate sprites and animations
- **Audio Integration**: Add sound effects and music
- **Dialogue System**: Create conversation flows

### 3. Testing Phase
- **Unit Tests**: Test individual components
- **Integration Tests**: Test feature interactions
- **Mobile Testing**: Verify mobile compatibility
- **Performance Testing**: Check frame rates and memory

### 4. Integration Phase
- **Code Review**: Use AI-assisted review
- **Merge Strategy**: Feature branch integration
- **CI/CD Pipeline**: Automated testing and deployment

## Character Development Workflow

### Creating a New Character

#### 1. Character Planning
```bash
# Create TaskMaster epic
python3 scripts/aggregate_tools.py --call taskmaster create_epic "Character: [Name]"

# Define character attributes
# - Personality traits
# - Visual design
# - Abilities and attacks
# - Role in story
```

#### 2. Character Implementation
```gdscript
# characters/[CharacterName].gd
extends Node2D
class_name CharacterName

@onready var state_machine = $StateMachine
@onready var sprite_manager = SpriteManager.new()
@onready var dialogue_manager = $DialogueManager

var character_stats = {
    "health": 100,
    "attack_power": 20,
    "special_ability": "unique_ability"
}

func _ready():
    sprite_manager.create_sprite("character_name")
    state_machine.start("idle")
    setup_dialogue_system()
```

#### 3. Dialogue Integration
```yaml
# dialogues/character_name.yaml
introduction:
  - "Character introduction dialogue"
  - "Personality-specific lines"
  - jump: character_specific_scene

special_ability:
  - "Special ability activation dialogue"
  - trigger: activate_special_ability
```

#### 4. State Machine Setup
```gdscript
# characters/states/[CharacterName]StateMachine.gd
extends StateMachine

func _ready():
    add_state("idle")
    add_state("attacking")
    add_state("special_ability")
    add_state("dialogue")
    
    add_transition("idle", "attacking", "attack_input")
    add_transition("attacking", "idle", "attack_complete")
```

## Mobile Development Workflow

### 1. Mobile Session Setup
```bash
# Start Termux
./scripts/mobile-dev-session.sh start

# Pull latest changes
./scripts/sync-mobile-work.sh pull
```

### 2. Mobile Development
```bash
# Edit code
nano src/characters/Mark.gd
vim scripts/gameplay_logic.py

# Test changes
./scripts/mobile-dev-session.sh test
```

### 3. Synchronization
```bash
# Push to desktop
./scripts/sync-mobile-work.sh push

# Handle conflicts (if any)
git status
git merge --no-ff mobile-branch
```

## MCP Tool Integration

### TaskMaster Integration
```bash
# Project management
python3 scripts/aggregate_tools.py --call taskmaster list_epics
python3 scripts/aggregate_tools.py --call taskmaster create_task "Task description"
python3 scripts/aggregate_tools.py --call taskmaster update_task TASK_ID "completed"
```

### Context7 Integration
```bash
# Store project context
python3 scripts/aggregate_tools.py --call context7 store_context "project_state"
python3 scripts/aggregate_tools.py --call context7 retrieve_context "character_details"
```

### Tavily Research
```bash
# Research game mechanics
python3 scripts/aggregate_tools.py --call tavily search "wedding game mechanics"
python3 scripts/aggregate_tools.py --call tavily search "godot state machine patterns"
```

## Advanced Workflows

### AI-Augmented Development
1. **Code Generation**: Use MCP tools for boilerplate
2. **Code Review**: AI-assisted quality checking
3. **Testing**: Automated test generation
4. **Documentation**: Auto-generated docs

### Cross-Platform Development
1. **Desktop Primary**: Main development on desktop
2. **Mobile Secondary**: Quick edits and testing
3. **Cloud Sync**: Continuous synchronization
4. **Testing Matrix**: Test on all platforms

### Collaborative Development
1. **Version Control**: Git-based collaboration
2. **Task Assignment**: TaskMaster coordination
3. **Code Review**: Pull request workflow
4. **Knowledge Sharing**: Documentation updates

## Performance Optimization

### Development Environment
```bash
# Optimize MCP aggregator
python3 scripts/aggregate_tools.py --optimize

# Clear caches
rm -rf .cache/ __pycache__/ node_modules/.cache/

# Update dependencies
pip install --upgrade -r requirements.txt
npm update
```

### Game Performance
```gdscript
# Profile critical paths
func _ready():
    if OS.is_debug_build():
        print("Performance profiling enabled")
    optimize_sprites()
    preload_audio()
```

## Deployment Workflow

### Pre-deployment Checks
```bash
# Run full test suite
./scripts/dev-session-manager.sh test

# Check for security issues
git-secrets --scan
rg "API_KEY|SECRET|TOKEN" --type=not-ignore

# Validate build
godot --headless --export "Linux/X11" wedding-game.x86_64
```

### GitHub Deployment
```bash
# Tag release
git tag -a v1.0.0 -m "Version 1.0.0 release"

# Push release
git push origin v1.0.0

# Create GitHub release
gh release create v1.0.0 --generate-notes
```

## Troubleshooting Guide

### Common Issues

#### MCP Server Problems
```bash
# Check aggregator status
python3 scripts/aggregate_tools.py --test

# Restart servers
./scripts/dev-session-manager.sh start

# Check logs
ls -la .claude/
```

#### Git Issues
```bash
# Check remote
git remote -v

# Reset to known good state
git reset --hard origin/main

# Clean working directory
git clean -fdx
```

#### Mobile Sync Issues
```bash
# Test connection
./scripts/sync-mobile-work.sh test

# Manual sync
rsync -av src/ desktop:~/Projects/wedding-game/src/
```

### Performance Issues
```bash
# Check system resources
top
df -h
free -m

# Optimize Git
git gc --aggressive
git prune
```

## Best Practices

### Code Organization
- Use consistent naming conventions
- Follow established patterns
- Document complex algorithms
- Maintain clean git history

### Security
- Never commit real API keys
- Use environment variables
- Rotate secrets regularly
- Enable 2FA on all accounts

### Testing
- Write tests for critical paths
- Test on multiple platforms
- Use automated testing
- Perform security testing

### Documentation
- Keep README updated
- Document complex workflows
- Maintain API documentation
- Update troubleshooting guides

---

*Master workflow for comprehensive game development - Wedding Game Project 2024*