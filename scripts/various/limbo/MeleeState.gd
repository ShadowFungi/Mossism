extends LimboState


@onready var holder: CharacterBody3D = get_parent().holder
@onready var pain_hsm: LimboHSM = get_parent()


func _enter() -> void:
	randomize()
	holder.cur_health -= randi_range(7, 15)
	dispatch(&'pain_stopped')


func _update(_delta: float) -> void:
	if get_parent().damage_type == 'none':
		dispatch(&'pain_stopped')


func _exit() -> void:
	pain_hsm.damage_type = 'none'
