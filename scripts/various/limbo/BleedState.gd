extends LimboState


@onready var holder: CharacterBody3D = get_parent().holder
@onready var pain_hsm: LimboHSM = get_parent()


func _enter() -> void:
	print('stab')
	randomize()
	var damage_amount = randi_range(5, 10)
	pain_hsm.current_health -= damage_amount
	_prolonged_damage(randi_range(2, 6))
	pain_hsm.damage_type = 'none'
	dispatch(&'pain_stopped')


func _update(_delta: float) -> void:
	if get_parent().damage_type == 'none':
		dispatch(&'pain_stopped')


func _prolonged_damage(stabs: int) -> void:
	randomize()
	for i in stabs:
		await get_tree().create_timer(randf_range(1, 2), false).timeout
		var damage_amount = randi_range(1, 2)
		pain_hsm.current_health -= damage_amount
