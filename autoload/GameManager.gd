extends Node

signal game_state_changed(state: Dictionary)
signal level_completed(level_name: String)
signal character_unlocked(character_name: String)

var game_state: Dictionary = {
	"current_level": "",
	"completed_levels": [],
	"unlocked_characters": ["mark"],
	"current_character": "mark",
	"player_stats": {
		"level": 1,
		"experience": 0,
		"health": 100,
		"max_health": 100,
		"chaos_points": 0
	},
	"settings": {
		"master_volume": 1.0,
		"sfx_volume": 1.0,
		"music_volume": 1.0
	}
}

var level_progression: Dictionary = {
	"glen_bingo": {
		"unlocks": ["beat_em_up"],
		"completion_requirements": ["complete_bingo_game"]
	},
	"beat_em_up": {
		"unlocks": ["wedding_adventure"],
		"completion_requirements": ["defeat_alien_waves"]
	},
	"wedding_adventure": {
		"unlocks": ["boss_fight"],
		"completion_requirements": ["complete_wedding_journey"]
	},
	"boss_fight": {
		"unlocks": ["credits"],
		"completion_requirements": ["defeat_acids_joe"]
	}
}

func _ready():
	print("GameManager: Game manager initialized")
	load_game_state()

func complete_level(level_name: String):
	print("GameManager: Level completed: %s" % level_name)
	
	if level_name not in game_state.completed_levels:
		game_state.completed_levels.append(level_name)
		
		# Unlock next levels
		if level_name in level_progression:
			var unlocks = level_progression[level_name].get("unlocks", [])
			for unlock in unlocks:
				print("GameManager: Unlocking level: %s" % unlock)
		
		# Special character unlocks
		match level_name:
			"glen_bingo":
				unlock_character("jenny")
			"beat_em_up":
				unlock_character("glen")
			"wedding_adventure":
				unlock_character("quinn")
		
		# Award experience
		award_experience(100)
		
		# Save state
		save_game_state()
		
		# Emit signals
		level_completed.emit(level_name)
		game_state_changed.emit(game_state)

func unlock_character(character_name: String):
	if character_name not in game_state.unlocked_characters:
		game_state.unlocked_characters.append(character_name)
		print("GameManager: Character unlocked: %s" % character_name)
		character_unlocked.emit(character_name)

func award_experience(amount: int):
	game_state.player_stats.experience += amount
	print("GameManager: Awarded %d experience" % amount)
	
	# Check for level up
	check_level_up()

func check_level_up():
	var current_level = game_state.player_stats.level
	var required_exp = current_level * 200  # 200 exp per level
	
	if game_state.player_stats.experience >= required_exp:
		game_state.player_stats.level += 1
		game_state.player_stats.max_health += 20
		game_state.player_stats.health = game_state.player_stats.max_health
		print("GameManager: Level up! New level: %d" % game_state.player_stats.level)

func set_current_character(character_name: String):
	if character_name in game_state.unlocked_characters:
		game_state.current_character = character_name
		print("GameManager: Current character set to: %s" % character_name)
		game_state_changed.emit(game_state)

func get_unlocked_levels() -> Array:
	var unlocked = ["glen_bingo"]  # Always start with first level
	
	for completed_level in game_state.completed_levels:
		if completed_level in level_progression:
			var unlocks = level_progression[completed_level].get("unlocks", [])
			for unlock in unlocks:
				if unlock not in unlocked:
					unlocked.append(unlock)
	
	return unlocked

func is_level_unlocked(level_name: String) -> bool:
	return level_name in get_unlocked_levels()

func is_character_unlocked(character_name: String) -> bool:
	return character_name in game_state.unlocked_characters

func get_game_state() -> Dictionary:
	return game_state

func save_game_state():
	# Use async save to prevent main thread blocking
	_save_game_state_async()

func _save_game_state_async():
	# Schedule save operation for next frame to prevent blocking
	await get_tree().process_frame
	
	var save_file = FileAccess.open("user://game_state.json", FileAccess.WRITE)
	if save_file:
		var json_string = JSON.stringify(game_state)
		save_file.store_string(json_string)
		save_file.close()
		print("GameManager: Game state saved asynchronously")
	else:
		print("GameManager: Error: Could not open save file for writing")

func load_game_state():
	# Use async load to prevent main thread blocking
	_load_game_state_async()

func _load_game_state_async():
	# Schedule load operation for next frame
	await get_tree().process_frame
	
	if not FileAccess.file_exists("user://game_state.json"):
		print("GameManager: No save file found, using defaults")
		return
	
	var save_file = FileAccess.open("user://game_state.json", FileAccess.READ)
	if not save_file:
		print("GameManager: Error: Could not open save file for reading")
		return
	
	var json_text = save_file.get_as_text()
	save_file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(json_text)
	
	if parse_result == OK and json.data is Dictionary:
		# Validate and merge loaded state with defaults
		var loaded_data = json.data as Dictionary
		for key in loaded_data:
			# Only merge valid game state keys
			if key in game_state:
				game_state[key] = loaded_data[key]
		print("GameManager: Game state loaded asynchronously")
		
		# Emit signal to notify other systems
		game_state_changed.emit(game_state)
	else:
		print("GameManager: Failed to parse save file")

func reset_game():
	game_state = {
		"current_level": "",
		"completed_levels": [],
		"unlocked_characters": ["mark"],
		"current_character": "mark",
		"player_stats": {
			"level": 1,
			"experience": 0,
			"health": 100,
			"max_health": 100,
			"chaos_points": 0
		},
		"settings": {
			"master_volume": 1.0,
			"sfx_volume": 1.0,
			"music_volume": 1.0
		}
	}
	save_game_state()
	print("GameManager: Game state reset")

# Debug functions
func unlock_all_levels():
	game_state.completed_levels = ["glen_bingo", "beat_em_up", "wedding_adventure"]
	game_state.unlocked_characters = ["mark", "jenny", "glen", "quinn"]
	save_game_state()
	print("GameManager: Debug - All levels and characters unlocked")

func print_game_state():
	print("=== GAME STATE ===")
	print("Completed Levels: %s" % game_state.completed_levels)
	print("Unlocked Characters: %s" % game_state.unlocked_characters)
	print("Current Character: %s" % game_state.current_character)
	print("Player Level: %d" % game_state.player_stats.level)
	print("Experience: %d" % game_state.player_stats.experience)
	print("Health: %d/%d" % [game_state.player_stats.health, game_state.player_stats.max_health])