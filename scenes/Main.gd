extends Node2D

@onready var hub_world = $HubWorld
@onready var debug_label = $UI/HUD/DebugLabel

var game_state: Dictionary = {
	"player_position": Vector2.ZERO,
	"unlocked_levels": ["glen_bingo"],  # Start with one level unlocked
	"character_stats": {
		"level": 1,
		"experience": 0,
		"health": 100,
		"max_health": 100
	},
	"current_character": "mark"
}

func _ready():
	print("Main: Wedding Game Hub World initialized")
	
	# Connect to hub world signals
	if hub_world:
		hub_world.level_entered.connect(_on_level_entered)
		hub_world.player_moved.connect(_on_player_moved)
	
	# Initialize game state
	load_game_state()
	update_debug_info()

func _on_level_entered(level_name: String):
	print("Main: Entering level: %s" % level_name)
	
	# Check if level is unlocked
	if level_name in game_state.unlocked_levels:
		change_to_level(level_name)
	else:
		print("Main: Level %s is locked" % level_name)
		show_locked_message(level_name)

func change_to_level(level_name: String):
	print("Main: Changing to level: %s" % level_name)
	
	# Save current position
	if hub_world and hub_world.player:
		game_state.player_position = hub_world.player.global_position
	
	# Load level scene
	var level_scene_path = "res://scenes/levels/%s.tscn" % level_name
	
	if ResourceLoader.exists(level_scene_path):
		save_game_state()
		get_tree().change_scene_to_file(level_scene_path)
	else:
		print("Main: Level scene not found: %s" % level_scene_path)
		show_placeholder_level(level_name)

func show_placeholder_level(level_name: String):
	print("Main: Showing placeholder for level: %s" % level_name)
	# Create simple placeholder notification
	var placeholder_label = Label.new()
	placeholder_label.text = "Level '%s' coming soon!\nPress ESC to return to hub" % level_name
	placeholder_label.position = Vector2(100, 100)
	placeholder_label.add_theme_font_size_override("font_size", 24)
	add_child(placeholder_label)
	
	# Remove after 3 seconds
	var timer = Timer.new()
	timer.wait_time = 3.0
	timer.one_shot = true
	timer.timeout.connect(func(): placeholder_label.queue_free())
	add_child(timer)
	timer.start()

func show_locked_message(level_name: String):
	print("Main: Level %s is locked" % level_name)
	# Show locked message
	var locked_label = Label.new()
	locked_label.text = "Level '%s' is locked!\nComplete more levels to unlock." % level_name
	locked_label.position = Vector2(100, 150)
	locked_label.add_theme_font_size_override("font_size", 20)
	locked_label.modulate = Color.RED
	add_child(locked_label)
	
	# Remove after 2 seconds
	var timer = Timer.new()
	timer.wait_time = 2.0
	timer.one_shot = true
	timer.timeout.connect(func(): locked_label.queue_free())
	add_child(timer)
	timer.start()

func _on_player_moved(position: Vector2):
	game_state.player_position = position
	update_debug_info()

func update_debug_info():
	if debug_label:
		debug_label.text = "Hub World - Character: %s | Level: %d | Health: %d/%d" % [
			game_state.current_character,
			game_state.character_stats.level,
			game_state.character_stats.health,
			game_state.character_stats.max_health
		]

func unlock_level(level_name: String):
	if level_name not in game_state.unlocked_levels:
		game_state.unlocked_levels.append(level_name)
		print("Main: Unlocked level: %s" % level_name)
		save_game_state()
		
		# Notify hub world of unlocked level
		if hub_world:
			hub_world.update_level_access(level_name, true)

func save_game_state():
	var save_file = FileAccess.open("user://game_state.json", FileAccess.WRITE)
	if save_file:
		save_file.store_string(JSON.stringify(game_state))
		save_file.close()
		print("Main: Game state saved")

func load_game_state():
	if FileAccess.file_exists("user://game_state.json"):
		var save_file = FileAccess.open("user://game_state.json", FileAccess.READ)
		if save_file:
			var json_text = save_file.get_as_text()
			save_file.close()
			
			var json = JSON.new()
			var parse_result = json.parse(json_text)
			
			if parse_result == OK:
				game_state = json.data
				print("Main: Game state loaded")
			else:
				print("Main: Failed to parse save file")
	else:
		print("Main: No save file found, using default game state")

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		# ESC key - show pause menu or quit
		print("Main: ESC pressed - pause functionality")
	
	# Debug keys
	if event.is_action_pressed("ui_accept") and Input.is_action_pressed("ui_left"):
		# Debug: unlock all levels
		game_state.unlocked_levels = ["glen_bingo", "beat_em_up", "wedding_adventure", "boss_fight"]
		print("Main: Debug - All levels unlocked")
		if hub_world:
			for level in game_state.unlocked_levels:
				hub_world.update_level_access(level, true)