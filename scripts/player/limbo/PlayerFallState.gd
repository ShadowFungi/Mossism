extends LimboState


@export var player: CharacterBody3D
@export var ground_ray: RayCast3D

@onready var max_step_down : float = player.max_step_down


#func _setup() -> void:
#	add_event_handler(&'jump_end', _jump)

func _enter() -> void:
	pass

func _update(delta: float) -> void:
	_pre_update(delta)
	_post_update.call_deferred()

func _pre_update(delta: float):
	if Input.is_action_just_pressed("ledge_grab".format({"n":1})):
		dispatch(&'grab_started')
	player.velocity.y -= (player.gravity * 2) * delta
	if player.is_on_floor() == true:
		dispatch(&'grounded')

func _post_update():
	#player.move_and_slide()
	
	step_down()

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
	player.can_step_up = true
