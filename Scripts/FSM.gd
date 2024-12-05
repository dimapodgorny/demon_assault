extends Node
class_name FiniteStateMachine

var States : Dictionary = { }
@export var initial_state : State

var current_state
var previous_state

func _ready() -> void:
	for child in get_children():
		if child is State:
			States[child.name.to_lower()] = child
			child.state_transition.connect(change_state)
	
	if initial_state:
		initial_state.Enter()
		current_state = initial_state
	
	

func _process(delta: float) -> void:
	if owner.is_multiplayer_authority():
		if current_state:
			current_state.Update(delta)

func _physics_process(delta: float) -> void:
	if owner.is_multiplayer_authority():
		if current_state:
			current_state.Physics_Update(delta)

func change_state(source_state: State, new_state_name: String):
	if source_state != current_state:
		print("Invalid change_state trying from: " + source_state.name + " but currently in: " + current_state.name)
		return
	
	var new_state = States.get(new_state_name.to_lower())
	previous_state = new_state
	if !new_state:
		print("New state (" + new_state.name + ") is empty.")
		return
	
	if current_state:
		current_state.Exit()
		
	new_state.Enter()
	
	current_state = new_state

func force_change_state(new_state_name: String):
	var new_state = States.get(new_state_name.to_lower())
	previous_state = new_state
	
	if !new_state:
		print("New state (" + new_state.name + ") is empty.")
		return
	
	if current_state == new_state:
		print("State is the same, aborting.")
		return
	
	if current_state:
		var exit_callable = Callable(current_state, "Exit")
		exit_callable.call_deferred()

	
	new_state.Enter()
	current_state = new_state
