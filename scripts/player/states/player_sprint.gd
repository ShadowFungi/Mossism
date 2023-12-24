class_name PlayerSprint
extends PlayerState


func enter_state() -> void:
	super()
	can_step_down = true

func handle_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('player-%s_jump' % parent.id):
		if parent.is_on_floor() or parent.can_jump:
			can_step_down = false
	return null

func physics_update(delta: float) -> State:
	var input_dir = Input.get_vector(
		'player-%s_strafe_right' % parent.id,
		'player-%s_strafe_left' % parent.id,
		'player-%s_back' % parent.id,
		'player-%s_forward' % parent.id
		)
	
	var direction = (parent.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	parent.velocity.z = direction.z * move_speed
	parent.velocity.x = direction.x * move_speed
	
	step(delta)
	step_down()
	
	parent.move_and_slide()
	
	if input_dir and !Input.is_action_pressed('player-%s_sprint' % parent.id):
		return walk_state
	
	if input_dir and Input.is_action_pressed('player-%s_crouch' % parent.id):
		return crouch_state
	
	if parent.is_on_floor():
		parent.can_jump = true
	
	if input_dir == Vector2.ZERO:
		return idle_state
	return null
