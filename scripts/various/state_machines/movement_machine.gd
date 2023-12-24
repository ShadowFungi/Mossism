class_name MoevementMachine
extends FiniteStateMachine


@export_group('Movement')
@export var idle_state: State
@export var crouch_state: State
@export var sprint_state: State
@export var walk_state: State

@export_group('Dependencies')
@export var step_detect: ShapeCast3D
@export var ledge_detect: RayCast3D
