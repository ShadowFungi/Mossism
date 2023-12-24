class_name DamageLava
extends DamageBaseState

var health_machine

@export var pain : int = 1

func _ready() -> void:
	health_machine = find_state_machine('HealthStateMachine')

#func enter_state():
	#parent_machine.do_damage = true

func physics_update(delta: float) -> State:
	if parent_machine.do_damage == true:
		damage()
	if parent_machine.do_damage == false:
		parent_machine.do_damage = true
	parent_machine.do_damage = false
	return null

func damage() -> State:
	parent.current_health -= pain
	return null
