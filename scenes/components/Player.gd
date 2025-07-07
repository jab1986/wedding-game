extends CharacterBody2D

signal position_changed(position: Vector2)
signal interaction_requested()

@onready var sprite = $Sprite
@onready var name_label = $NameLabel
@onready var interaction_area = $InteractionArea

var speed: float = 200.0
var current_character: String = "mark"
var character_sprite: AnimatedSprite2D

var input_buffer: Array = []
var buffer_time: float = 0.1
var last_input_time: float = 0.0

func _ready():
	print("Player: Player initialized")
	
	# Setup character sprite
	setup_character_sprite()
	
	# Connect interaction area
	if interaction_area:
		interaction_area.body_entered.connect(_on_interaction_area_entered)
		interaction_area.body_exited.connect(_on_interaction_area_exited)

func setup_character_sprite():
	print("Player: Setting up character sprite for: %s" % current_character)
	
	# Create sprite using SpriteManager
	if SpriteManager:
		character_sprite = SpriteManager.create_sprite(current_character)
		if character_sprite:
			# Replace the placeholder ColorRect with the actual sprite
			sprite.visible = false
			add_child(character_sprite)
			character_sprite.position = Vector2.ZERO
			character_sprite.play("idle")
			print("Player: Character sprite created successfully")
		else:
			print("Player: Failed to create character sprite, using placeholder")
			sprite.color = Color.GREEN
	else:
		print("Player: SpriteManager not found, using placeholder")
		sprite.color = Color.RED
	
	# Update name label
	name_label.text = current_character.capitalize()

func _physics_process(delta):
	handle_input()
	move_character(delta)
	
	# Emit position changed signal
	position_changed.emit(global_position)

func handle_input():
	var input_vector = Vector2.ZERO
	
	# Movement input
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1
	if Input.is_action_pressed("move_up"):
		input_vector.y -= 1
	if Input.is_action_pressed("move_down"):
		input_vector.y += 1
	
	# Normalize diagonal movement
	if input_vector.length() > 0:
		input_vector = input_vector.normalized()
		
		# Update animation
		if character_sprite:
			if character_sprite.animation != "walk":
				character_sprite.play("walk")
		
		# Flip sprite based on direction
		if character_sprite and input_vector.x != 0:
			character_sprite.flip_h = input_vector.x < 0
		
	else:
		# No movement - play idle animation
		if character_sprite and character_sprite.animation != "idle":
			character_sprite.play("idle")
	
	velocity = input_vector * speed
	
	# Interaction input
	if Input.is_action_just_pressed("interact"):
		interaction_requested.emit()

func move_character(delta):
	# Use built-in CharacterBody2D movement
	move_and_slide()

func switch_character(new_character: String):
	print("Player: Switching to character: %s" % new_character)
	
	if new_character == current_character:
		return
	
	current_character = new_character
	
	# Remove old sprite
	if character_sprite:
		character_sprite.queue_free()
	
	# Setup new sprite
	setup_character_sprite()

func get_current_character() -> String:
	return current_character

func set_speed(new_speed: float):
	speed = new_speed

func get_speed() -> float:
	return speed

func play_animation(animation_name: String):
	if character_sprite and character_sprite.sprite_frames.has_animation(animation_name):
		character_sprite.play(animation_name)

func _on_interaction_area_entered(body):
	print("Player: Interaction area entered: %s" % body.name)

func _on_interaction_area_exited(body):
	print("Player: Interaction area exited: %s" % body.name)

# Debug function
func _input(event):
	if event.is_action_pressed("ui_up"):
		# Debug: Switch to Jenny
		switch_character("jenny")
	elif event.is_action_pressed("ui_down"):
		# Debug: Switch to Mark
		switch_character("mark")
	elif event.is_action_pressed("ui_right"):
		# Debug: Switch to Glen
		switch_character("glen")