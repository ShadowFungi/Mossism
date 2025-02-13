extends LimboState


@export var player: CharacterBody3D
var start_fall: bool = false

#
#func _setup() -> void:
#	add_event_handler(&'jump_started', _jump)

func _enter() -> void:
	start_fall = false
	player.velocity.y = player.JUMP_VELOCITY
	await get_tree().create_timer(0.4, false, true).timeout
	start_fall = true

#func _jump() -> bool:
#	player.velocity.y += 50
#	return true

func _update(delta: float) -> void:
	if !Input.is_action_pressed("jump".format({"n":1})):
		await get_tree().create_timer(0.055, false, true).timeout
		start_fall = true
	if start_fall == true:
		player.velocity = player.velocity.cubic_interpolate(Vector3(player.velocity.x, 0.2, player.velocity.z), Vector3(player.velocity.x, player.velocity.y, player.velocity.z), Vector3(player.velocity.x, 0.0, player.velocity.z), 0.75) * delta
		#player.velocity.y = player.gravity * delta / 2
	if player.velocity.y <= 0.5:
		start_fall = false
		dispatch(&'jump_end')
