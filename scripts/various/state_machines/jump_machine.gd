class_name JumpMachine
extends FiniteStateMachine


@export_group('Movement')
@export var jump_state: State
@export var fall_state: State
@export var idle_state: State

@export_group('Dependencies')
@export var step_detect: ShapeCast3D
@export var ledge_detect: RayCast3D
