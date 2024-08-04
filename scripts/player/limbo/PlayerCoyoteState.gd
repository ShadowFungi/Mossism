extends LimboState


@export var player: CharacterBody3D
@export var ground_ray: RayCast3D


func _enter() -> void:
	await get_tree().create_timer(0.125, false, true).timeout
	if player.is_on_floor() == false:
		dispatch(&'coyote_ended')


func _update(delta: float) -> void:
	if ground_ray.is_colliding() == true and player.can_snap_down == true:
		var body = ground_ray.get_collider()
		if body.is_in_group("ground") or body.is_in_group("wall"):
			if body.get_child(0).get_aabb().size.y <= 1.25:
				print("AABB")
				if player.global_position.distance_to(ground_ray.get_collision_point()) > 0.5 and player.global_position.distance_to(ground_ray.get_collision_point()) < 5.9:
					print(player.global_position.distance_to(ground_ray.get_collision_point()))
					#player.global_position = player.global_position.move_toward(ground_ray.get_collision_point(), 0.2)
					player.velocity.y -= player.gravity * 10
				dispatch(&'coyote_ended')
	if Input.is_action_just_pressed("player-{n}_jump".format({"n":1})):
		dispatch(&'jump_started')


func _exit() -> void:
	player.can_snap_down = false
