extends LimboState


@export var player: CharacterBody3D
@export var ground_ray: RayCast3D

@onready var max_step_down : float = player.max_step_down
@onready var max_step_up : float = player.max_step_up


func _enter() -> void:
	await get_tree().create_timer(0.125, true, true).timeout
	#if player.is_on_floor() == false:
	dispatch(&'coyote_ended')


func _update(_delta: float) -> void:
	#if ground_ray.is_colliding() == true and player.can_snap_down == true:
	#	var body = ground_ray.get_collider()
	#	if body.is_in_group("ground") or body.is_in_group("wall"):
	#		if body.get_child(0).get_aabb().size.y <= 1.25:
	#			#print("AABB")
	#			if player.global_position.distance_to(ground_ray.get_collision_point()) > 0.5 and player.global_position.distance_to(ground_ray.get_collision_point()) < 5.9:
	#				#print(player.global_position.distance_to(ground_ray.get_collision_point()))
	#				#player.global_position = player.global_position.move_toward(ground_ray.get_collision_point(), 0.2)
	#				player.velocity.y -= player.gravity * 10
	#				dispatch(&'coyote_ended')
	if Input.is_action_just_pressed("jump".format({"n":1})):
		dispatch(&'jump_started')
	step_up()
	_post_update.call_deferred()

func _post_update():
	await get_tree().create_timer(0.025, true, true).timeout
	step_down()

func step_up() -> bool:
	var player_dir_a = Vector3(player.get_input_dir().x, 0, player.get_input_dir().y)
	var player_dir_b = Vector3(player.get_input_dir().y, 0, player.get_input_dir().x)
	if player_dir_a == Vector3.ZERO and player_dir_b == Vector3.ZERO:
		return false
	
	var test_params = PhysicsTestMotionParameters3D.new()
	var test_results = PhysicsTestMotionResult3D.new()
	var test_transform = player.global_transform
	var distance_a = player_dir_a * 0.1
	var distance_b = player_dir_a * -0.1
	var distance_c = player_dir_b * 0.1
	var distance_d = player_dir_b * -0.1
	test_params.from = player.global_transform
	for distance in [distance_a, distance_b, distance_c, distance_d]:
		test_params.motion = distance
		if PhysicsServer3D.body_test_motion(player.get_rid(), test_params, test_results) == false:
			continue
		
		var remainder = test_results.get_remainder()
		test_transform = test_transform.translated(test_results.get_travel())
		var step_up = max_step_up * Vector3(0, 1, 0)
		test_params.from = test_transform
		test_params.motion = step_up
		PhysicsServer3D.body_test_motion(player.get_rid(), test_params, test_results)
		test_transform = test_transform.translated(test_results.get_travel())
		
		test_params.from = test_transform
		test_params.motion = remainder
		PhysicsServer3D.body_test_motion(player.get_rid(), test_params, test_results)
		test_transform = test_transform.translated(test_results.get_travel())
		
		if test_results.get_collision_count() != 0:
			remainder = test_results.get_remainder().length()
			var wall_normal = test_results.get_collision_normal()
			var dot_div_magnitude = player_dir_a.dot(wall_normal) / (wall_normal * wall_normal).length()
			var projected_vector = (player_dir_a - dot_div_magnitude * wall_normal).normalized()
			
			test_params.from = test_transform
			test_params.motion = remainder * projected_vector
			PhysicsServer3D.body_test_motion(player.get_rid(), test_params, test_results)
			test_transform = test_transform.translated(test_results.get_travel())
		test_params.from = test_transform
		test_params.motion = max_step_up * -Vector3(0, 1, 0)
		if PhysicsServer3D.body_test_motion(player.get_rid(), test_params, test_results) == false:
			continue
		test_transform = test_transform.translated(test_results.get_travel())
		var surface_normal = test_results.get_collision_normal()
		#if (snappedf(surface_normal.angle_to(Vector3(0, 1, 0)), 0.01) > player.floor_max_angle):
		#	return
		var global_pos = player.global_position
		var step_up_dist = test_transform.origin.y - global_pos.y
		
		#player.velocity.y = 0
		global_pos.y = test_transform.origin.y
		player.global_position = global_pos
	return true

func step_down():
	if player.is_grounded == true:
		return
	var test_params = PhysicsTestMotionParameters3D.new()
	var test_results = PhysicsTestMotionResult3D.new()
	var test_transform = player.global_transform
	test_params.from = player.global_transform
	test_params.motion = Vector3(0, max_step_down, 0)
	if PhysicsServer3D.body_test_motion(player.get_rid(), test_params, test_results):
		player.position.y += test_results.get_travel().y
		player.apply_floor_snap()
		player.is_grounded = true

func _exit() -> void:
	player.can_snap_down = false
