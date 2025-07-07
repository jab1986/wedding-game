# Wedding Game - Architecture & Core Code Plan

This document summarizes the architectural decisions and provides the initial code for the core components of the Wedding Game, based on our discussion.

## 1. Core Game Vision

The game is a surreal, 2D top-down RPG adventure with a dark, nonsensical sense of humor.

- **World Structure:** A central "hub world" (like Pallet Town) is used to explore and access different levels.
- **Goal:** The initial goal is to "get to the wedding," but the true gameplay is exploring the world and completing bizarre, genre-hopping mini-games.
- **Levels:** The levels are self-contained mini-games in various genres (e.g., beat-'em-up, quiz show) that are mostly disconnected from the wedding theme.
- **Characters:** The player recruits a party of characters in the hub world and can switch between them within the levels to utilize their unique abilities.

---

## 2. GameManager.gd (Global Autoload)

This script will act as the game's central "brain." It's a global autoload that persists across all scenes and is responsible for tracking the player's party and overall progression.

**File Path:** `autoload/GameManager.gd`

### Suggested Code:
```gdscript
# GameManager.gd
# The central brain for the game. Manages party, progression, and game state.
extends Node

# Enum to track the player's high-level state
enum PlayerState { IN_HUB_WORLD, IN_MINIGAME, IN_MENU }
var current_player_state: PlayerState = PlayerState.IN_MENU

# --- Party Management ---
# An array to hold the node references of characters in the party.
var player_party: Array[Node] = []
# The character currently being controlled by the player.
var active_character: Node = null

# --- Progression Tracking ---
# A dictionary to track the status of each level.
# Example: { "beat_em_up": "completed", "quiz_game": "unlocked" }
var level_progress: Dictionary = {}

# --- Signals ---
# Emitted when the party composition changes (a character is added or removed).
signal party_updated(new_party)
# Emitted when the player switches control to a different character.
signal active_character_changed(new_character)
# Emitted when a level is unlocked or completed.
signal level_status_changed(level_name, new_status)


### --- PUBLIC METHODS --- ###

# Call this from a character's script when they are recruited.
func add_character_to_party(character: Node):
    if not player_party.has(character):
        player_party.append(character)
        # If this is the first character, make them active immediately.
        if active_character == null:
            set_active_character(character)
        party_updated.emit(player_party)
        print("Added ", character.name, " to party.")

# Call this to switch which character the player is controlling.
func set_active_character(character: Node):
    # Ensure the character is actually in the party before switching.
    if player_party.has(character) and active_character != character:
        active_character = character
        active_character_changed.emit(active_character)
        print("Active character is now ", active_character.name)

# Call this when a level is completed or a new one is discovered.
func update_level_status(level_name: String, status: String):
    level_progress[level_name] = status
    level_status_changed.emit(level_name, status)
    print("Level ", level_name, " is now ", status)

```

---

## 3. AudioManager.gd (Scene-Based & Reusable)

This script is designed to be part of a reusable scene (`LevelAudioManager.tscn`). You will instance this scene into each of your level templates (e.g., `BeatEmUp_Template.tscn`). This keeps each level's audio self-contained.

**File Path:** `scenes/templates/LevelAudioManager.gd` (suggested)

### Suggested Code:
```gdscript
# LevelAudioManager.gd
# A reusable, scene-based audio manager. Instance this into level templates.
extends Node

## --- EXPORTED VARIABLES --- ##
# In the Godot editor, you can drag your audio files directly into these slots
# for each unique level instance.

# The background music for this specific level.
@export var background_music: AudioStream

# A dictionary to hold named sound effects for this level.
# In the editor, you can add keys (e.g., "punch", "jump", "correct_answer")
# and assign an AudioStream to each one.
@export var sound_effects: Dictionary = {}


## --- PRIVATE VARIABLES --- ##
var music_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer


func _ready():
    # Create the necessary nodes to play audio.
    music_player = AudioStreamPlayer.new()
    sfx_player = AudioStreamPlayer.new()
    add_child(music_player)
    add_child(sfx_player)

    # Assign them to the correct audio bus for volume control.
    # (Assumes you have "Music" and "SFX" buses in your project settings).
    music_player.bus = "Music"
    sfx_player.bus = "SFX"

    # Automatically play the configured background music when the level starts.
    if background_music:
        music_player.stream = background_music
        music_player.play()

### --- PUBLIC METHODS --- ###

# Call this from other scripts within the level to play a sound effect.
# Example: get_node("LevelAudioManager").play_sfx("punch")
func play_sfx(sfx_name: String):
    if sound_effects.has(sfx_name):
        var sfx_stream = sound_effects[sfx_name]
        sfx_player.stream = sfx_stream
        sfx_player.play()
    else:
        print_warning("Sound effect not found: ", sfx_name)

func stop_music():
    music_player.stop()

```

---

## 4. Main.tscn Structure

This is the main scene for the entire game. It acts as a container for the world, the UI, and the dynamically loaded mini-game levels.

**File Path:** `scenes/Main.tscn`

### Suggested Node Structure:
```
Node2D (named "Main")
│
├── World (Node2D)
│   # This node contains the persistent hub world. The game camera will
│   # live here and follow the active character.
│   └── HubWorld (Instance of your HubWorld.tscn)
│
├── LevelContainer (Node)
│   # This is an empty container. When the player enters a mini-game,
│   # the level scene will be loaded from a file and added as a child here.
│   # When the player leaves, the level scene is destroyed (queue_free()).
│   └── <Mini-game scenes will be loaded here>
│
└── UICanvas (CanvasLayer)
    # This layer is drawn on top of everything else. It's perfect for UI.
    # It does not move with the camera.
    ├── MainMenu (Control Node)
    ├── PauseMenu (Control Node)
    └── GameHUD (Control Node)
        # The HUD would contain things like the party display, which would
        # update by listening to the GameManager's 'party_updated' signal.
        └── PartyDisplay (HBoxContainer)
```
