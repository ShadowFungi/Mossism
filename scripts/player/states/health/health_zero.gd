class_name HealthZero
extends HealthBase


func physics_update(delta: float) -> State:
	parent_machine.hud.update_health(parent.current_health, parent_machine.max_health)
	parent_machine.game_over.show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().set_pause(true)
	return null
