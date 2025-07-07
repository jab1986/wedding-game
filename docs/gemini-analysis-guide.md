# Using Gemini CLI for Wedding Game Codebase Analysis

When analyzing large codebases or multiple files that might exceed context limits, use the Gemini CLI with its massive context window. Use `gemini -p` to leverage Google Gemini's large context capacity.

## File and Directory Inclusion Syntax

Use the `@` syntax to include files and directories in your Gemini prompts. The paths should be relative to WHERE you run the gemini command:

### Examples:

**Single file analysis:**
```bash
gemini -p "@autoload/GameManager.gd Explain this autoload's purpose and structure"

Multiple files:
gemini -p "@project.godot @autoload/SpriteManager.gd Analyze the project configuration and sprite management"

Entire directory:
gemini -p "@scripts/ Summarize the architecture of the game scripts"

Multiple directories:
gemini -p "@autoload/ @scripts/ Analyze the autoload system and game scripts interaction"

Current directory and subdirectories:
gemini -p "@./ Give me an overview of this entire wedding game project"

# Or use --all_files flag:
gemini --all_files -p "Analyze the wedding game project structure and dependencies"
```

## Wedding Game Specific Analysis Examples

### Game System Verification

**Check if player movement is implemented:**
```bash
gemini -p "@scripts/ @autoload/ Has player movement been implemented? Show me the relevant scripts and input handling"
```

**Verify dialogue system implementation:**
```bash
gemini -p "@autoload/ @scripts/ Is the dialogue system fully implemented? List all dialogue-related functions and their usage"
```

**Check for wedding-specific mechanics:**
```bash
gemini -p "@scripts/ @autoload/ Are there any wedding ceremony mechanics implemented? Show the relevant code and systems"
```

**Verify audio management:**
```bash
gemini -p "@autoload/AudioManager.gd @scripts/ Is background music and sound effects properly implemented? Show audio handling code"
```

**Check save/load system:**
```bash
gemini -p "@autoload/ @scripts/ Is game save/load functionality implemented? Show the persistence system code"
```

### Architecture Analysis

**Verify state machine implementation:**
```bash
gemini -p "@scripts/StateMachine.gd @autoload/ Is the state machine properly integrated with game systems? Show state transitions"
```

**Check autoload dependencies:**
```bash
gemini -p "@autoload/ @project.godot How are the autoload singletons structured? Show dependencies and initialization order"
```

**Verify scene management:**
```bash
gemini -p "@autoload/ @scenes/ Is scene loading and management properly implemented? Show scene transition code"
```

### Performance and Optimization

**Check for performance bottlenecks:**
```bash
gemini -p "@scripts/ @autoload/ Are there any performance issues in the codebase? Show expensive operations and optimization opportunities"
```

**Verify memory management:**
```bash
gemini -p "@autoload/ @scripts/ Is proper memory management implemented? Show object pooling and resource cleanup"
```

### Wedding Game Feature Verification

**Check wedding party character system:**
```bash
gemini -p "@scripts/ @autoload/ Is a wedding party character system implemented? Show character management and interaction code"
```

**Verify wedding venue mechanics:**
```bash
gemini -p "@scripts/ @autoload/ Are wedding venue mechanics implemented? Show environment interaction and event systems"
```

**Check mini-game systems:**
```bash
gemini -p "@scripts/ @autoload/ Are there mini-games implemented for wedding activities? Show game mode switching and scoring"
```

**Verify wedding chaos mechanics:**
```bash
gemini -p "@scripts/ @autoload/ Are chaos/disaster mechanics implemented? Show event triggers and consequence systems"
```

### Input and UI Analysis

**Check input handling:**
```bash
gemini -p "@project.godot @scripts/ @autoload/ Is input handling properly configured? Show input mapping and processing code"
```

**Verify UI systems:**
```bash
gemini -p "@scripts/ @autoload/ Are UI systems implemented? Show menu handling and game interface code"
```

## When to Use Gemini CLI for Wedding Game

Use `gemini -p` when:
- Analyzing the entire Godot project structure
- Comparing multiple .gd script files
- Understanding autoload system architecture
- Current context window is insufficient for the task
- Working with the complete game codebase
- Verifying if specific wedding game mechanics are implemented
- Checking for consistent coding patterns across all scripts
- Analyzing scene dependencies and resource usage

## Important Notes for Godot Projects

- Paths in @ syntax are relative to your current working directory when invoking gemini
- Include `@project.godot` for project configuration analysis
- Use `@autoload/` to analyze singleton systems
- Use `@scripts/` for game logic analysis
- The CLI will include file contents directly in the context
- No need for --yolo flag for read-only analysis
- Gemini's context window can handle entire Godot projects that would overflow Claude's context
- When checking implementations, be specific about wedding game mechanics you're looking for
- Include both .gd script files and .tscn scene files for complete analysis