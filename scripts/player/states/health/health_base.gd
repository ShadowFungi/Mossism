class_name HealthBase
extends State


@export_category('Health States')
@export var health_normal: HealthBase
@export var health_low: HealthBase
@export var health_zero: HealthBase

func physics_update(delta: float) -> State:
	parent_machine.hud.update_health(parent.current_health, parent_machine.max_health)
	return null
