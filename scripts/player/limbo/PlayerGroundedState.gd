extends LimboState


@export var player: CharacterBody3D
@export var ground_ray: RayCast3D

func _enter() -> void:
	player.velocity.y = 0

func _update(_delta: float) -> void:
	_pre_update()
	_post_update.call_deferred()
	
	#if player.step_shape.is_colliding() == true:
		#var step = player.step_shape.get_collider(0)
		#if player.can_step_up == true and step != null:
			#player.can_snap_down = false
			##print(step.get_child(0).get_aabb().size.y)]
			#if step.is_in_group("ground") or step.is_in_group("wall"):
				#if step.get_child(0).get_aabb().size.y <= 1.25:
					#if player.smooth_step == false:
						#player.global_position.y = player.global_position.move_toward(step.global_position, 0.2).y + 2.0
					#if player.smooth_step == true:
						#player.global_position.y = player.global_position.lerp(step.global_position, 0.2).y + 2.0
					#player.can_step_up = false
				#dispatch(&'ground_lost')

func _pre_update():
	if Input.is_action_just_pressed("jump".format({"n":1})):
		dispatch(&'jump_started')
	if player.is_on_floor() == false:
		dispatch(&'ground_lost')

func _post_update():
	pass

func _exit() -> void:
	player.can_snap_down = true
	player.can_step_up = false
