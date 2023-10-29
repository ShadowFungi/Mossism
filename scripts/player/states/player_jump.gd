class_name PlayerJump
extends PlayerState


var gravity_scale_old


func jump(player : PlayerRigid, jump_height : float):
	if gravity_scale_old == null:
		gravity_scale_old = player.gravity_scale
	player.gravity_scale = 0
	player.apply_central_impulse((Vector3.UP * jump_height))
	get_node('../../JumpTime').start()
	await get_node('../../JumpTime').timeout
	player.gravity_scale = gravity_scale_old

func _ready() -> void:
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)

func _exit_state() -> void:
	set_physics_process(false)
