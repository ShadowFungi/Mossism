class_name FiniteStateMachine
extends Node

signal transition(state_name)

var current_state: State
@export var parent: CharacterBody3D
@export_category('States')

@export_group('General')
@export var start_state: State

@export_category('State Machines')
@export var machines: Array[FiniteStateMachine]
@export_category('Animation')
@export var anim_player: AnimationPlayer

func init(_parent: CharacterBody3D, player_id : int = 1):
	for child in get_children():
		if "parent" in child:
			child.parent = parent
		if "player_id" in child:
			child.player_id = player_id
	change_state(start_state)

func handle_input(event: InputEvent) -> void:
	var new_state = current_state.handle_input(event)
	if new_state:
		change_state(new_state)

func frame_update(delta: float) -> void:
	var new_state = current_state.frame_update(delta)
	if new_state:
		change_state(new_state)

func physics_update(delta: float) -> void:
	var new_state = current_state.physics_update(delta)
	if new_state:
		change_state(new_state)

func change_state(new_state : State):
	if not has_node(str(new_state)):
		print(str(new_state) + "not found")
		return
	if current_state is State:
		current_state.exit_state()
	current_state = new_state
	current_state.enter_state()
	emit_signal('transition', current_state.name)
	#print(current_state.name)
