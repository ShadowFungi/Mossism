extends LimboState


@export var player: CharacterBody3D


func _enter() -> void:
	pass


func _update(_delta: float) -> void:
	if !Input.is_action_pressed('player-%s_sprint' % player.id):
		dispatch(&'run_ended')
	var input_dir: Vector2 = player.get_input_dir()
	var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	player.velocity.x = direction.x * (player.BASE_SPEED * player.RUNNING_MODIFIER)
	player.velocity.z = direction.z * (player.BASE_SPEED * player.RUNNING_MODIFIER)
