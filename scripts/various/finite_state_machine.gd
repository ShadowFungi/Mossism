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

func _integrate_forces(player : PlayerRigid, forces_state : PhysicsDirectBodyState3D, dir):
	if state.has_method('forces'):
		state.forces(player, forces_state, dir)

func fire():
	if state.has_method('fire'):
		state.fire()

func jump(player : PlayerRigid, jump_height : float, force_state : PhysicsDirectBodyState3D):
	if state.has_method('jump'):
		state.jump(player, jump_height, force_state)

func change_state(new_state : String):
	if not has_node(new_state):
		print(new_state + "not found")
		return
	if state is State:
		state._exit_state()
	state = get_node(new_state)
	state._enter_state()
	emit_signal('transition', state.name)
	#print(state.name)
