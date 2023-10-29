class_name PlayerState
extends State

var player : PlayerRigid

func look_follow(state, current_transform, target_position):
	var up_dir = Vector3(0, 1, 0)
	var cur_dir = (current_transform.basis * Vector3(0, 1, 0))
	var target_dir = (target_position - current_transform.origin).normalized()
	var rotation_angle = acos(cur_dir.x) - acos(target_dir.x)
	
	state.angular_velocity = up_dir * (rotation_angle / state.step)

func _ready() -> void:
	await owner.ready
	
	player = owner as PlayerRigid
	
	assert(player != null)
