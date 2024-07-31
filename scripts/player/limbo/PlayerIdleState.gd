extends LimboState


@export var player: CharacterBody3D


func _enter() -> void:
	player.velocity.x = 0
	player.velocity.z = 0

func _update(_delta: float) -> void:
	var input_dir = Input.get_vector(
		"player-{n}_strafe_left".format({"n":1}),
		"player-{n}_strafe_right".format({"n":1}),
		"player-{n}_forward".format({"n":1}),
		"player-{n}_back".format({"n":1})
	).normalized()
	if !input_dir.is_zero_approx():
		dispatch(EVENT_FINISHED)
