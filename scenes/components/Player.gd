extends CharacterBody2D

signal position_changed(position: Vector2)
signal interaction_requested()

@onready var sprite = $Sprite
@onready var name_label = $NameLabel
@onready var interaction_area = $InteractionArea
@onready var state_machine = $StateMachine

var speed: float = 200.0
var current_character: String = "mark"
var character_sprite: AnimatedSprite2D

var input_vector: Vector2 = Vector2.ZERO
var is_attacking: bool = false

func _ready():
	print("Player: Player initialized")
	
	# Setup character sprite
	setup_character_sprite()
	
	# Connect interaction area
	if interaction_area:
		interaction_area.body_entered.connect(_on_interaction_area_entered)
		interaction_area.body_exited.connect(_on_interaction_area_exited)
	
	# Setup state machine
	state_machine.set_physics_process(false)
	setup_state_machine()
	state_machine.change_state("idle")

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

func setup_state_machine():
	state_machine.add_state("idle", _enter_idle, _exit_idle, _update_idle)
	state_machine.add_state("walk", _enter_walk, _exit_walk, _update_walk)
	state_machine.add_state("attack", _enter_attack, _exit_attack, _update_attack)
	
	state_machine.add_transition("idle", "walk", "move")
	state_machine.add_transition("walk", "idle", "stop")
	state_machine.add_transition("idle", "attack", "attack")
	state_machine.add_transition("walk", "attack", "attack")
	state_machine.add_transition("attack", "idle", "attack_finished")

var last_position: Vector2 = Vector2.ZERO
var position_threshold: float = 5.0  # Only emit signal if moved more than 5 pixels

func _physics_process(delta):
	handle_input()
	state_machine._physics_process(delta)
	move_and_slide()
	
	# Only emit position_changed if moved significantly
	if global_position.distance_to(last_position) > position_threshold:
		position_changed.emit(global_position)
		last_position = global_position

func handle_input():
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if input_vector != Vector2.ZERO:
		state_machine.trigger("move")
	else:
		state_machine.trigger("stop")
	
	if input_vector.x != 0:
		character_sprite.flip_h = input_vector.x < 0
	
	if Input.is_action_just_pressed("attack") and not is_attacking:
		state_machine.trigger("attack")
	
	if Input.is_action_just_pressed("interact"):
		interaction_requested.emit()

func _enter_idle():
	character_sprite.play("idle")
	velocity = Vector2.ZERO

func _exit_idle():
	pass

func _update_idle(delta):
	pass

func _enter_walk():
	character_sprite.play("walk")

func _exit_walk():
	pass

func _update_walk(delta):
	velocity = input_vector.normalized() * speed

func _enter_attack():
	is_attacking = true
	var attack_anim = get_attack_animation(current_character)
	character_sprite.play(attack_anim)
	
	# Only connect if not already connected
	if not character_sprite.is_connected("animation_finished", _on_attack_finished):
		character_sprite.connect("animation_finished", _on_attack_finished)

func _exit_attack():
	# Only disconnect if connected
	if character_sprite.is_connected("animation_finished", _on_attack_finished):
		character_sprite.disconnect("animation_finished", _on_attack_finished)
	is_attacking = false

func _update_attack(_delta):
	velocity = Vector2.ZERO

func _on_attack_finished():
	state_machine.trigger("attack_finished")

func get_attack_animation(character_name: String) -> String:
	match character_name:
		"mark": return "drumstick_attack"
		"jenny": return "camera_bomb"
		"glen": return "accident"
		"quinn": return "fix_chaos"
		"jack": return "hipster_pose"
		"acids_joe": return "psychedelic_attack"
		_: return "attack"

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
	
	# Reset to idle if was attacking
	if state_machine.is_state("attack"):
		state_machine.change_state("idle")

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
