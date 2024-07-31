extends LimboState


@export var player: CharacterBody3D
@export var ground_ray: RayCast3D

func _enter() -> void:
	player.velocity.y = 0

func _update(delta: float) -> void:
	if Input.is_action_just_pressed("player-{n}_jump".format({"n":1})):
		dispatch(&'jump_started')
	if ground_ray.is_colliding() == false:
		await get_tree().create_timer(0.125, false, true).timeout
		dispatch(&'ground_lost')
