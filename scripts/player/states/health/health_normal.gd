class_name HealthNormal
extends HealthBase


func physics_update(delta: float) -> State:
	parent_machine.hud.update_health(parent.current_health, parent_machine.max_health)
	if parent.current_health <= (parent_machine.max_health * 0.30):
		return health_low
	return null
