extends CharacterBody3D


const BASE_SPEED = 10.0
const WALKING_MODIFIER = 2.5
const RUNNING_MODIFIER = 3.5
const JUMP_VELOCITY = 12.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var id: float = 1


func get_input_dir() -> Vector2:
	var input_dir = Input.get_vector(
		'player-%s_strafe_left' % id,
		'player-%s_strafe_right' % id,
		'player-%s_forward' % id,
		'player-%s_back' % id
		)
	return input_dir


func _physics_process(delta):
	move_and_slide()


func _on_walking_state_state_physics_processing(delta):
	var input_dir = get_input_dir()
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * (BASE_SPEED * WALKING_MODIFIER)
		velocity.z = direction.z * (BASE_SPEED * WALKING_MODIFIER)
	if input_dir == Vector2.ZERO:
		%PlayerStateChart.send_event('not_moving')
	if Input.is_action_pressed('player-%s_sprint' % id):
		%PlayerStateChart.send_event('run_pressed')


func _on_running_state_state_physics_processing(delta):
	var input_dir = get_input_dir()
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * (BASE_SPEED * RUNNING_MODIFIER)
		velocity.z = direction.z * (BASE_SPEED * RUNNING_MODIFIER)
	if input_dir == Vector2.ZERO:
		%PlayerStateChart.send_event('not_moving')


func _on_grounded_state_state_physics_processing(delta):
	velocity.y = 0
	if Input.is_action_just_pressed('player-%s_jump' % id):
		%PlayerStateChart.send_event('jumped')
	if !is_on_floor():
		%PlayerStateChart.send_event('not_grounded')


func _on_falling_state_state_physics_processing(delta):
	velocity.y -= gravity * delta
	if is_on_floor():
		%PlayerStateChart.send_event('grounded')


func _on_jumping_state_entered():
	velocity.y = JUMP_VELOCITY
	await get_tree().create_timer(0.05).timeout
	%PlayerStateChart.send_event('not_grounded')


func _on_jumping_state_state_physics_processing(delta):
	if Input.is_action_just_released('player-%s_jump' % id):
		%PlayerStateChart.send_event('not_grounded')


func _on_idle_state_state_physics_processing(delta):
	if get_input_dir() != Vector2.ZERO:
		%PlayerStateChart.send_event('walking')
	velocity.x = move_toward(velocity.x, 0, BASE_SPEED)
	velocity.z = move_toward(velocity.z, 0, BASE_SPEED)
