extends LimboState


@export var player: CharacterBody3D
var start_fall: bool = false
var needs_fall: bool = false

#
#func _setup() -> void:
#	add_event_handler(&'jump_started', _jump)

func _enter() -> void:
	player.velocity.y = 5
	await get_tree().create_timer(0.25, false, true).timeout
	needs_fall = true

#func _jump() -> bool:
#	player.velocity.y += 50
#	return true

func _update(delta: float) -> void:
	if !Input.is_action_pressed("player-{n}_jump".format({"n":1})):
		await get_tree().create_timer(0.0025, false, true).timeout
		start_fall = true
	if start_fall == true:
		player.velocity = player.velocity.lerp(Vector3(player.velocity.x, 0, player.velocity.z), delta * 2.0)
	if needs_fall == true:
		player.velocity = player.velocity.lerp(Vector3(player.velocity.x, 0, player.velocity.z), delta * 2.0)
	if player.velocity.y <= 0.5:
		start_fall = false
		needs_fall = false
		dispatch(&'jump_end')
