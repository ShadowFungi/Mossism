extends LimboState


@export var player: CharacterBody3D


func _enter() -> void:
	pass

func _update(_delta: float) -> void:
	var input_dir = Input.get_vector(
		"player-{n}_strafe_left".format({"n":1}),
		"player-{n}_strafe_right".format({"n":1}),
		"player-{n}_forward".format({"n":1}),
		"player-{n}_back".format({"n":1})
	).normalized()
	var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	player.velocity.x = direction.x * player.SPEED
	player.velocity.z = direction.z * player.SPEED
