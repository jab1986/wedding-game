#!/bin/bash

# Wedding Game Development Session Startup
# Forces awareness of existing project before development

clear
echo "🎮 WEDDING GAME DEVELOPMENT SESSION"
echo "=================================="
echo ""

# Check if user has discovered their project
if [ ! -f ".project_discovered" ]; then
    echo "🚨 FIRST TIME SETUP REQUIRED"
    echo "============================="
    echo ""
    echo "You need to discover your project first!"
    echo "Your project is complete but you haven't explored it yet."
    echo ""
    echo "Run: ./project_discovery.sh"
    echo ""
    echo "This will guide you through understanding what you already have."
    echo "❌ NO DEVELOPMENT UNTIL YOU DISCOVER YOUR PROJECT!"
    exit 1
fi

echo "✅ Project discovered! Loading session..."
echo ""

# Display current project state
echo "📊 PROJECT STATUS SUMMARY"
echo "========================="
echo ""

echo "🎯 CORE SYSTEMS (Ready to Use):"
echo "  ✅ GameManager.gd - Game state, level progression"
echo "  ✅ AudioManager.gd - Music, SFX, character sounds"
echo "  ✅ SpriteManager.gd - Sprite management, placeholders"
echo "  ✅ StateMachine.gd - Entity behavior management"
echo "  ✅ DialogueManager - Full dialogue system"
echo ""

echo "🎮 CHARACTERS (Ready for Art):"
echo "  ✅ Mark, Jenny, Glen, Quinn, Jack, Acids Joe"
echo ""

echo "🎵 AUDIO SYSTEM (Ready for Files):"
echo "  ✅ Music: Hub, Battle, Victory, Boss, Wedding themes"
echo "  ✅ SFX: Menu, footsteps, attacks, character sounds"
echo ""

echo "🎲 LEVEL PROGRESSION (Ready for Content):"
echo "  ✅ glen_bingo → beat_em_up → wedding_adventure → boss_fight"
echo ""

# Check git status
echo "📁 GIT STATUS:"
git status -s
echo ""

# Show recent commits
echo "📝 RECENT COMMITS:"
git log --oneline -3
echo ""

# Show what's been modified
if [ -n "$(git status --porcelain)" ]; then
    echo "⚠️  MODIFIED FILES:"
    git status --porcelain
    echo ""
fi

echo "🎯 DEVELOPMENT FOCUS OPTIONS"
echo "==========================="
echo ""
echo "What do you want to work on today?"
echo ""
echo "1. 🎨 CREATE SPRITE ART"
echo "   - Character sprites for Mark, Jenny, Glen, Quinn, Jack, Acids Joe"
echo "   - Animation frames (idle, walk, attack, special)"
echo "   - Your SpriteManager will handle everything else"
echo ""
echo "2. 🎵 CREATE AUDIO FILES"
echo "   - Background music for different levels"
echo "   - Character-specific sound effects"
echo "   - Your AudioManager is ready for files"
echo ""
echo "3. 🎲 CREATE LEVEL CONTENT"
echo "   - Design glen_bingo gameplay"
echo "   - Create beat_em_up level"
echo "   - Your progression system is complete"
echo ""
echo "4. 💬 CREATE DIALOGUE CONTENT"
echo "   - Character conversations"
echo "   - Story elements"
echo "   - Your DialogueManager is fully integrated"
echo ""
echo "5. 🧪 TEST & DEBUG"
echo "   - Test existing systems in Godot"
echo "   - Debug current functionality"
echo "   - Verify all systems work"
echo ""

echo "🎯 READY FOR DEVELOPMENT"
echo "========================"
echo ""

echo "🔧 QUICK TEST COMMANDS"
echo "====================="
echo ""
echo "Open Godot and try these in the console:"
echo "  GameManager.print_game_state()"
echo "  AudioManager.list_audio_files()"
echo "  SpriteManager.list_all_characters()"
echo ""

echo "🔍 QUALITY ASSURANCE TOOLS"
echo "=========================="
echo ""
echo "Run quality checks before development:"
echo "  ./scripts/dev-qa-tools.sh all      - Run all QA checks"
echo "  ./scripts/dev-qa-tools.sh gdscript - Check GDScript syntax"
echo "  ./scripts/dev-qa-tools.sh quality  - Check code quality"
echo ""

echo "📋 SESSION CHECKLIST"
echo "===================="
echo ""
echo "Before starting development:"
echo "  □ Read .claude-code-config"
echo "  □ Run ./scripts/dev-qa-tools.sh all"
echo "  □ Choose content focus (not systems)"
echo "  □ Test in Godot"
echo "  □ Commit changes when done"
echo ""

echo "🎯 CHOOSE YOUR FOCUS:"
echo "What content do you want to create today?"
echo ""
echo "Type 1-5 to choose your focus area:"
read -r choice

case $choice in
    1)
        echo "🎨 SPRITE ART FOCUS"
        echo "=================="
        echo ""
        echo "Your SpriteManager is ready for character art!"
        echo "Characters need 64x64 sprites (96x96 for Acids Joe)"
        echo ""
        echo "Recommended workflow:"
        echo "1. Create art for one character"
        echo "2. Test in Godot with SpriteManager"
        echo "3. Verify animations work"
        echo "4. Move to next character"
        echo ""
        echo "Start with: claude-code 'Help me create sprite art for Mark character'"
        ;;
    2)
        echo "🎵 AUDIO FOCUS"
        echo "=============="
        echo ""
        echo "Your AudioManager is ready for audio files!"
        echo "Audio paths are already configured in the system"
        echo ""
        echo "Recommended workflow:"
        echo "1. Create hub world music"
        echo "2. Test with AudioManager.play_music()"
        echo "3. Create character sound effects"
        echo "4. Test character-specific sounds"
        echo ""
        echo "Start with: claude-code 'Help me create hub world music'"
        ;;
    3)
        echo "🎲 LEVEL CONTENT FOCUS"
        echo "====================="
        echo ""
        echo "Your progression system is ready for level content!"
        echo "Level flow: glen_bingo → beat_em_up → wedding_adventure → boss_fight"
        echo ""
        echo "Recommended workflow:"
        echo "1. Design glen_bingo gameplay"
        echo "2. Create level scene"
        echo "3. Test level progression"
        echo "4. Verify character unlocking"
        echo ""
        echo "Start with: claude-code 'Help me design the glen_bingo level gameplay'"
        ;;
    4)
        echo "💬 DIALOGUE FOCUS"
        echo "=================="
        echo ""
        echo "Your DialogueManager is ready for dialogue content!"
        echo "Full dialogue system is already integrated"
        echo ""
        echo "Recommended workflow:"
        echo "1. Write character introductions"
        echo "2. Create level dialogue"
        echo "3. Test dialogue system"
        echo "4. Add story elements"
        echo ""
        echo "Start with: claude-code 'Help me write character dialogue for Mark'"
        ;;
    5)
        echo "🧪 TESTING FOCUS"
        echo "================"
        echo ""
        echo "Time to test your existing systems!"
        echo ""
        echo "1. Open Godot: godot --editor"
        echo "2. Run the project (F5)"
        echo "3. Try the debug commands listed above"
        echo "4. Verify all systems work"
        echo ""
        echo "Report any issues you find!"
        ;;
    *)
        echo "Invalid choice. Choose 1-5."
        ;;
esac

echo ""
echo "🎮 DEVELOPMENT SESSION READY!"
echo "============================"
echo ""
echo "Remember: Focus on CONTENT, not SYSTEMS!"
echo "Your architecture is already complete!"
echo ""