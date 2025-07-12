# Wedding Game Development Workflow

## Startup
```bash
cd wedding-game
code .                    # Open VS Code
godot --editor &         # Open Godot editor
```

## Development Process
1. **Plan** - Decide what content to create (art, audio, levels, dialogue)
2. **Direct** - Give Claude Code specific implementation tasks
3. **Test** - Verify changes work in Godot
4. **Iterate** - Refine based on results

## Shutdown
```bash
# Save and commit changes
git add .
git commit -m "describe what was accomplished"
git push

# Close applications
# Ctrl+C in terminal to stop Godot
# Ctrl+Q to close VS Code
```

## Quick Commands
- **Test systems**: Open Godot console, try `GameManager.print_game_state()`
- **Check files**: `ls autoload/ scenes/ scripts/`
- **Git status**: `git status`