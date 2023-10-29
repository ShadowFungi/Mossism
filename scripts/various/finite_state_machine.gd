class_name FiniteStateMachine
extends Node

signal transition(state_name)

@export var state : State

@onready var parent : RigidBody3D = self.get_parent()

func _ready() -> void:
	for child in get_children():
		child.state_machine = false
	change_state(state.to_string())

func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)

func _process(delta: float) -> void:
	state.update(delta)

func _physics_process(delta: float) -> void:
	state.physics_update(delta)

func _integrate_forces(forces_state):
	state.forces(forces_state)

func change_state(new_state : String):
	if not has_node(new_state):
		return
	if state is State:
		state._exit_state()
	state = get_node(new_state)
	state._enter_state()
	emit_signal("transition", state.name)
