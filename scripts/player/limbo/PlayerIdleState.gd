extends LimboState


@export var player: CharacterBody3D


func _enter() -> void:
	player.velocity.x = 0
	player.velocity.z = 0

func _update(_delta: float) -> void:
	var input_dir = player.get_input_dir()
	if !input_dir.is_zero_approx():
		dispatch(&'walk_started')
