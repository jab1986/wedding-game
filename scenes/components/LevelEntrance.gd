extends StaticBody2D

signal entrance_activated(level_name: String)

@export var level_name: String = ""
@export var display_name: String = ""
@export var description: String = ""
@export var unlock_requirements: Array[String] = []

@onready var background = $Background
@onready var level_name_label = $LevelNameLabel
@onready var description_label = $DescriptionLabel
@onready var interaction_area = $InteractionArea
@onready var lock_overlay = $LockOverlay
@onready var lock_icon = $LockOverlay/LockIcon

var is_locked: bool = true
var is_player_nearby: bool = false
var interaction_prompt: Label

func _ready():
	print("LevelEntrance: Level entrance initialized: %s" % level_name)
	
	# Update display
	update_display()
	
	# Connect interaction area
	if interaction_area:
		interaction_area.body_entered.connect(_on_interaction_area_entered)
		interaction_area.body_exited.connect(_on_interaction_area_exited)
	
	# Create interaction prompt
	create_interaction_prompt()

func update_display():
	if level_name_label:
		level_name_label.text = display_name if display_name else level_name
	
	if description_label:
		description_label.text = description
	
	# Update visual based on lock status
	update_lock_visual()

func update_lock_visual():
	if lock_overlay:
		lock_overlay.visible = is_locked
	
	if background:
		if is_locked:
			background.color = Color(0.3, 0.3, 0.3, 1)  # Gray for locked
		else:
			background.color = Color(0.4, 0.4, 0.8, 1)  # Blue for unlocked

func set_locked(locked: bool):
	is_locked = locked
	update_lock_visual()
	print("LevelEntrance: %s is now %s" % [level_name, "locked" if locked else "unlocked"])

func create_interaction_prompt():
	interaction_prompt = Label.new()
	interaction_prompt.text = "Press SPACE to enter"
	interaction_prompt.position = Vector2(-50, -70)
	interaction_prompt.size = Vector2(100, 20)
	interaction_prompt.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	interaction_prompt.add_theme_color_override("font_color", Color.YELLOW)
	interaction_prompt.visible = false
	add_child(interaction_prompt)

func _on_interaction_area_entered(body):
	if body.name == "Player":
		is_player_nearby = true
		show_interaction_prompt()
		print("LevelEntrance: Player entered interaction area for: %s" % level_name)

func _on_interaction_area_exited(body):
	if body.name == "Player":
		is_player_nearby = false
		hide_interaction_prompt()
		print("LevelEntrance: Player exited interaction area for: %s" % level_name)

func show_interaction_prompt():
	if interaction_prompt:
		if is_locked:
			interaction_prompt.text = "🔒 LOCKED"
			interaction_prompt.add_theme_color_override("font_color", Color.RED)
		else:
			interaction_prompt.text = "Press SPACE to enter"
			interaction_prompt.add_theme_color_override("font_color", Color.YELLOW)
		interaction_prompt.visible = true

func hide_interaction_prompt():
	if interaction_prompt:
		interaction_prompt.visible = false

func interact():
	print("LevelEntrance: Interact called for: %s" % level_name)
	
	if is_locked:
		print("LevelEntrance: Cannot enter locked level: %s" % level_name)
		show_locked_message()
		return
	
	if is_player_nearby:
		print("LevelEntrance: Activating level: %s" % level_name)
		entrance_activated.emit(level_name)
	else:
		print("LevelEntrance: Player not nearby for: %s" % level_name)

func show_locked_message():
	# Create temporary locked message
	var locked_message = Label.new()
	locked_message.text = "Complete previous levels to unlock!"
	locked_message.position = Vector2(-80, -90)
	locked_message.size = Vector2(160, 20)
	locked_message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	locked_message.add_theme_color_override("font_color", Color.RED)
	add_child(locked_message)
	
	# Remove after 2 seconds
	var timer = Timer.new()
	timer.wait_time = 2.0
	timer.one_shot = true
	timer.timeout.connect(func(): 
		if locked_message:
			locked_message.queue_free()
	)
	add_child(timer)
	timer.start()

func check_unlock_requirements() -> bool:
	if unlock_requirements.is_empty():
		return true
	
	# Check if all required levels are completed
	# This would connect to a global game state manager
	for requirement in unlock_requirements:
		# Placeholder check - would connect to actual game state
		print("LevelEntrance: Checking requirement: %s" % requirement)
	
	return false

func _input(event):
	if event.is_action_pressed("interact") and is_player_nearby:
		interact()

# Debug function
func _draw():
	if Engine.is_editor_hint():
		return
	
	# Draw interaction radius in debug mode
	if is_player_nearby:
		draw_circle(Vector2.ZERO, 100, Color(1, 1, 0, 0.2))

func get_level_info() -> Dictionary:
	return {
		"level_name": level_name,
		"display_name": display_name,
		"description": description,
		"is_locked": is_locked,
		"unlock_requirements": unlock_requirements
	}