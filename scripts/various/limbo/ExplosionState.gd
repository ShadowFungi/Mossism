extends LimboState


@onready var holder: CharacterBody3D = get_parent().holder


func _enter() -> void:
	randomize()
	holder.cur_health -= randi_range(10, 18)
	dispatch(&'caught_fire')
