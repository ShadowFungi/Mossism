class_name PlayerIdle
extends PlayerState


func enter_state() -> void:
	super()
	parent.velocity.x = 0
	parent.velocity.z = 0

func handle_input(event: InputEvent) -> State:
	var input_dir = Input.get_vector(
		'player-%s_strafe_left' % parent.id,
		'player-%s_strafe_right' % parent.id,
		'player-%s_forward' % parent.id,
		'player-%s_back' % parent.id
		)
	
	if Input.is_action_pressed('player-%s_crouch' % parent.id):
		return crouch_state
	
	if input_dir and Input.is_action_pressed('player-%s_sprint' % parent.id):
		return sprint_state
	
	if input_dir and !Input.is_action_just_pressed('player-%s_jump' % parent.id):
		return walk_state
	
	return null

func physics_update(delta: float):
	parent.velocity.z = 0
	parent.velocity.x = 0
	step(delta)
	parent.move_and_slide()
