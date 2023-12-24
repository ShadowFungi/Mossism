class_name PlayerCrouch
extends PlayerState

@export_category('Crouch Options')
@export var crouch_size: float

@export_group('Dependencies')
@export var collision_shape: CollisionShape3D
@export var pivot: Node3D

var shape: CapsuleShape3D
var og_size: float

func enter_state() -> void:
	super()
	shape = collision_shape.get_shape()
	can_step_down = true
	og_size = shape.height
	shape.height = crouch_size
	pivot.position = (pivot.position / 2.1)
	collision_shape.position = (collision_shape.position / 1.4)

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
	
	if input_dir and !Input.is_action_pressed('player-%s_crouch' % parent.id):
		return walk_state
	
	if input_dir == Vector2.ZERO:
		return idle_state
	return null

func exit_state():
	pivot.position = (pivot.position * 2.1)
	shape.height = og_size
	collision_shape.position = (collision_shape.position * 1.4)
