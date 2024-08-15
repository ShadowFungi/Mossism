extends LimboState


@onready var fire_damage_multiplier: int = get_parent().fire_damage_multiplier
@onready var holder: CharacterBody3D = get_parent().holder
@onready var pain_hsm: LimboHSM = get_parent()
@onready var fire_res: bool = get_parent().fire_res
@onready var damage_multiplier: int = get_parent().damage_multiplier
@onready var damage_additional: int = get_parent().damage_additional

var ended: bool = false
var strength: int


func _enter() -> void:
	randomize()
	strength = randi_range(2, 10)
	if fire_res == true:
		await get_tree().create_timer(2.5, false, true).timeout
	_fire_damage(strength)


func _update(_delta: float) -> void:
	if pain_hsm.damage_type == 'none':
		dispatch(&'pain_stopped')
	#while pain_hsm.damage_type == 'fire':
	if ended == true:
		_fire_damage(strength)

func _fire_damage(fire_strength: int):
	ended = false
	for m in fire_strength:
		randomize()
		await get_tree().create_timer(randf_range(0.2, 0.5), false).timeout
		var damage: int = randi_range(4, 8) * fire_damage_multiplier
		pain_hsm.current_health -= damage
	ended = true
