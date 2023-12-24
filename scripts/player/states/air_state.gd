class_name AirState
extends State

@export_category('State Options')
@export_group('Enterable States')
@export var jump_state : State
@export var fall_state : State
@export var idle_state : State

func look_follow(state, current_transform, target_position):
	var up_dir = Vector3(0, 1, 0)
	var cur_dir = (current_transform.basis * Vector3(0, 1, 0))
	var target_dir = (target_position - current_transform.origin).normalized()
	var rotation_angle = acos(cur_dir.x) - acos(target_dir.x)
	
	state.angular_velocity = up_dir * (rotation_angle / state.step)

