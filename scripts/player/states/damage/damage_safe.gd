class_name DamageSafe
extends DamageBaseState


func physics_update(delta: float) -> State:
	if parent_machine.do_damage == true:
		damage()
	if parent_machine.do_damage == false:
		parent_machine.do_damage = true
	parent_machine.do_damage = false
	return null

func damage():
	return null
