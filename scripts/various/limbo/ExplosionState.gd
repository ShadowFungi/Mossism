extends LimboState


@onready var holder: CharacterBody3D = get_parent().holder
@onready var pain_hsm: LimboHSM = get_parent()
@onready var fire_damage_multiplier: int = get_parent().fire_damage_multiplier
@onready var fire_res: bool = get_parent().fire_res
@onready var damage_multiplier: int = get_parent().damage_multiplier
@onready var damage_additional: int = get_parent().damage_additional


var ended: bool = false
var strength: int = 1.0


func _enter() -> void:
	randomize()
	pain_hsm.current_health -= randi_range(15, 25)
	#await get_tree().create_timer(randf_range(2.5, 7.5), false).timeout
	#await get_tree().create_timer(0.1, false).timeout
	pain_hsm.damage_type = 'none'


func _update(_delta: float) -> void:
	if pain_hsm.damage_type == 'none':
		dispatch(&'pain_stopped')
	#while pain_hsm.damage_type == 'fire':
	#if ended == true:
	#	_prolonged_damage(strength)

func _prolonged_damage(prolonged_time: int):
	ended = false
	for m in prolonged_time:
		randomize()
		await get_tree().create_timer(randf_range(0.1, 0.7), false).timeout
		var damage: int = randi_range(4, 8) * fire_damage_multiplier
		if fire_res == true:
			damage = damage / 1.25
		pain_hsm.current_health -= damage
	ended = true


