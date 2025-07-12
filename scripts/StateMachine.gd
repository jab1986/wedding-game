extends Node
class_name StateMachine
## Core state machine implementation for all game entities
## Provides structured state management with transitions, entry/exit handling

signal state_changed(from_state: String, to_state: String)
signal state_entered(state_name: String)
signal state_exited(state_name: String)

@export var initial_state: String = "idle"
@export var debug_states: bool = false

var current_state: String = ""
var previous_state: String = ""
var states: Dictionary = {}
var transitions: Dictionary = {}
var state_timers: Dictionary = {}

func _ready():
	# Initialize after all states are registered
	call_deferred("_initialize_state_machine")

func _initialize_state_machine():
	if not states.is_empty() and initial_state in states:
		change_state(initial_state)
	elif debug_states:
		print("StateMachine Warning: No states registered or initial_state '%s' not found" % initial_state)

## Register a new state with optional enter/exit callbacks
func add_state(state_name: String, enter_callback: Callable = Callable(), exit_callback: Callable = Callable(), update_callback: Callable = Callable()) -> void:
	states[state_name] = {
		"enter": enter_callback,
		"exit": exit_callback,
		"update": update_callback,
		"duration": 0.0
	}
	
	# Initialize transitions for this state
	if not state_name in transitions:
		transitions[state_name] = {}
	
	if debug_states:
		print("StateMachine: Added state '%s'" % state_name)

## Add a transition between states with optional condition
func add_transition(from_state: String, to_state: String, trigger: String, condition: Callable = Callable()) -> void:
	if not from_state in transitions:
		transitions[from_state] = {}
	
	transitions[from_state][trigger] = {
		"to_state": to_state,
		"condition": condition
	}
	
	if debug_states:
		print("StateMachine: Added transition '%s' -> '%s' on '%s'" % [from_state, to_state, trigger])

## Attempt to trigger a state transition
func trigger(event: String) -> bool:
	if current_state.is_empty():
		if debug_states:
			print("StateMachine: Cannot trigger '%s' - no current state" % event)
		return false
	
	if not current_state in transitions:
		if debug_states:
			print("StateMachine: No transitions from state '%s'" % current_state)
		return false
	
	if not event in transitions[current_state]:
		if debug_states:
			print("StateMachine: No transition for event '%s' from state '%s'" % [event, current_state])
		return false
	
	var transition = transitions[current_state][event]
	
	# Check condition if provided
	if transition.condition.is_valid():
		if not transition.condition.call():
			if debug_states:
				print("StateMachine: Transition condition failed for '%s'" % event)
			return false
	
	change_state(transition.to_state)
	return true

## Force a state change (bypasses transitions)
func change_state(new_state: String) -> void:
	if not new_state in states:
		if debug_states:
			print("StateMachine Error: State '%s' not registered" % new_state)
		return
	
	# Exit current state
	if not current_state.is_empty():
		_exit_state(current_state)
	
	# Change state
	previous_state = current_state
	current_state = new_state
	
	# Enter new state
	_enter_state(current_state)
	
	# Emit signals
	if not previous_state.is_empty():
		state_changed.emit(previous_state, current_state)
	state_entered.emit(current_state)
	
	if debug_states:
		print("StateMachine: Changed state '%s' -> '%s'" % [previous_state, current_state])

func _enter_state(state_name: String) -> void:
	var state = states[state_name]
	
	# Reset state timer
	state_timers[state_name] = 0.0
	
	# Call enter callback
	if state.enter.is_valid():
		state.enter.call()

func _exit_state(state_name: String) -> void:
	var state = states[state_name]
	
	# Update state duration
	if state_name in state_timers:
		state.duration = state_timers[state_name]
	
	# Call exit callback
	if state.exit.is_valid():
		state.exit.call()
	
	state_exited.emit(state_name)

func _process(delta: float) -> void:
	# Update state timer
	if not current_state.is_empty():
		if current_state in state_timers:
			state_timers[current_state] += delta

func _physics_process(delta: float) -> void:
	if not current_state.is_empty():
		var state = states[current_state]
		if state.update.is_valid():
			state.update.call(delta)

## Get current state information
func get_current_state() -> String:
	return current_state

func get_previous_state() -> String:
	return previous_state

func get_state_time() -> float:
	if current_state.is_empty() or not current_state in state_timers:
		return 0.0
	return state_timers[current_state]

func get_state_duration(state_name: String) -> float:
	if not state_name in states:
		return 0.0
	return states[state_name].duration

## Check state conditions
func is_state(state_name: String) -> bool:
	return current_state == state_name

func can_transition_to(state_name: String) -> bool:
	if current_state.is_empty() or not current_state in transitions:
		return false
	
	# Check if any trigger can lead to the target state
	for trigger in transitions[current_state]:
		if transitions[current_state][trigger].to_state == state_name:
			var condition = transitions[current_state][trigger].condition
			if not condition.is_valid() or condition.call():
				return true
	
	return false

## Utility methods
func get_all_states() -> Array:
	return states.keys()

func get_available_transitions() -> Array:
	if current_state.is_empty() or not current_state in transitions:
		return []
	return transitions[current_state].keys()

## Debug helpers
func print_state_info() -> void:
	print("=== StateMachine Debug Info ===")
	print("Current State: %s" % current_state)
	print("Previous State: %s" % previous_state)
	print("State Time: %.2f" % get_state_time())
	print("Available Transitions: %s" % str(get_available_transitions()))
	print("All States: %s" % str(get_all_states()))

func print_transition_graph() -> void:
	print("=== State Transition Graph ===")
	for from_state in transitions:
		for trigger in transitions[from_state]:
			var to_state = transitions[from_state][trigger].to_state
			print("%s --[%s]--> %s" % [from_state, trigger, to_state])
