extends Node2D

signal level_entered(level_name: String)
signal player_moved(position: Vector2)

@onready var player = $Player
@onready var camera = $Camera2D
@onready var level_entrances = $LevelEntrances

var hub_size := Vector2(1920, 1080)

func _ready():
	print("HubWorld: Hub world initialized")
	
	# Connect player signals
	if player:
		player.position_changed.connect(_on_player_position_changed)
		player.interaction_requested.connect(_on_player_interaction)
	
	# Setup camera to follow player
	if camera and player:
		camera.position = player.position
	
	# Initialize level entrances
	setup_level_entrances()

func setup_level_entrances():
	print("HubWorld: Setting up level entrances")
	
	var entrances = level_entrances.get_children()
	for entrance in entrances:
		if entrance.has_method("set_locked"):
			# Lock all levels except the first one initially
			var is_unlocked = (entrance.level_name == "glen_bingo")
			entrance.set_locked(not is_unlocked)
		
		# Connect entrance signals
		if entrance.has_signal("entrance_activated"):
			entrance.entrance_activated.connect(_on_entrance_activated)

func _on_player_position_changed(position: Vector2):
	player_moved.emit(position)
	
	# Update camera to follow player
	if camera:
		camera.position = position

func _on_player_interaction():
	print("HubWorld: Player interaction requested")
	
	# Check for nearby interactables
	var nearby_objects = get_nearby_interactables()
	for obj in nearby_objects:
		if obj.has_method("interact"):
			obj.interact()

func _on_entrance_activated(level_name: String):
	print("HubWorld: Level entrance activated: %s" % level_name)
	level_entered.emit(level_name)

func get_nearby_interactables() -> Array:
	var interactables = []
	var player_pos = player.global_position
	var interaction_range = 100.0
	
	# Check level entrances
	for entrance in level_entrances.get_children():
		var distance = player_pos.distance_to(entrance.global_position)
		if distance <= interaction_range:
			interactables.append(entrance)
	
	# Check NPCs
	var npcs = $NPCs.get_children()
	for npc in npcs:
		var distance = player_pos.distance_to(npc.global_position)
		if distance <= interaction_range:
			interactables.append(npc)
	
	return interactables

func update_level_access(level_name: String, unlocked: bool):
	print("HubWorld: Updating level access - %s: %s" % [level_name, unlocked])
	
	var entrances = level_entrances.get_children()
	for entrance in entrances:
		if entrance.level_name == level_name and entrance.has_method("set_locked"):
			entrance.set_locked(not unlocked)

func get_player_position() -> Vector2:
	if player:
		return player.global_position
	return Vector2.ZERO

func set_player_position(position: Vector2):
	if player:
		player.global_position = position
		if camera:
			camera.position = position

# Debug function to show hub layout
func _draw():
	if Engine.is_editor_hint():
		return
	
	# Draw grid for debugging
	var grid_size = 100
	var grid_color = Color(0.3, 0.3, 0.3, 0.3)
	
	for x in range(0, int(hub_size.x), grid_size):
		draw_line(Vector2(x, 0), Vector2(x, hub_size.y), grid_color, 1.0)
	
	for y in range(0, int(hub_size.y), grid_size):
		draw_line(Vector2(0, y), Vector2(hub_size.x, y), grid_color, 1.0)
	
	# Draw hub boundaries
	var boundary_color = Color(0.8, 0.8, 0.8, 0.5)
	draw_rect(Rect2(Vector2.ZERO, hub_size), boundary_color, false, 2.0)

func _input(event):
	if event.is_action_pressed("ui_select"):
		# Debug: show player position
		print("HubWorld: Player position: %s" % get_player_position())
	
	if event.is_action_pressed("ui_cancel"):
		# Debug: center camera on player
		if camera and player:
			camera.position = player.global_position