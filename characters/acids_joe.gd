extends Node2D

@onready var state_machine = $StateMachine
var sprite: AnimatedSprite2D  # Will be set by setup_sprite()

var health: int = 500
var max_health: int = 500
var attack_damage: int = 50
var player_target: Node = null

func _ready():
	setup_sprite()
	setup_state_machine()
	state_machine.change_state("idle")

func setup_sprite():
	sprite = SpriteManager.create_sprite("acids_joe")
	if sprite:
		add_child(sprite)
		sprite.position = Vector2.ZERO

func setup_state_machine():
	state_machine.add_state("idle", _enter_idle, _exit_idle, _update_idle)
	state_machine.add_state("attack", _enter_attack, _exit_attack, _update_attack)
	state_machine.add_state("rage", _enter_rage, _exit_rage, _update_rage)
	state_machine.add_state("defeat", _enter_defeat, _exit_defeat)

	state_machine.add_transition("idle", "attack", "player_near")
	state_machine.add_transition("attack", "idle", "attack_finished")
	state_machine.add_transition("idle", "rage", "low_health")
	state_machine.add_transition("rage", "idle", "rage_finished")
	state_machine.add_transition("any", "defeat", "health_zero") # Assuming 'any' can be handled in trigger

func _physics_process(delta):
	# Custom trigger logic
	if state_machine.current_state != "defeat":
		if health <= 0:
			state_machine.change_state("defeat")
		elif health < max_health * 0.3:
			state_machine.trigger("low_health")
		elif player_target and global_position.distance_to(player_target.global_position) < 200:
			state_machine.trigger("player_near")

func _enter_idle():
	sprite.play("idle")

func _exit_idle():
	pass

func _update_idle(delta):
	pass

func _enter_attack():
	sprite.play("psychedelic_attack")
	# Implement attack logic, e.g., spawn projectiles

func _exit_attack():
	pass

func _update_attack(delta):
	pass

func _enter_rage():
	sprite.play("boss_rage")
	# Increase speed or damage

func _exit_rage():
	pass

func _update_rage(delta):
	pass

func _enter_defeat():
	sprite.play("defeat")
	# Trigger level completion

func _exit_defeat():
	queue_free()

func take_damage(amount: int):
	health -= amount
	if health < 0:
		health = 0

# Connect to animation finished if needed
