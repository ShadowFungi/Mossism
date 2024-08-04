extends LimboState


@export var player: CharacterBody3D


func _enter() -> void:
	pass

func _update(_delta: float) -> void:
	var input_dir: Vector2 = player.get_input_dir()
	var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if Input.is_action_pressed('player-%s_sprint' % player.id):
		dispatch(&'run_started')
	player.velocity.x = direction.x * (player.BASE_SPEED * player.WALKING_MODIFIER)
	player.velocity.z = direction.z * (player.BASE_SPEED * player.WALKING_MODIFIER)
	if input_dir.is_zero_approx():
		dispatch(&'walk_ended')
