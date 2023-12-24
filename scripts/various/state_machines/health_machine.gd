class_name HealthMachine
extends FiniteStateMachine


@export_category('Health Properties')
@export var max_health: int = 500

@export_group('Dependencies')
@export var hud: Control
@export var game_over: Control
