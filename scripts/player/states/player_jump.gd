class_name PlayerJump
extends PlayerState


var gravity_scale_old


func jump(player : PlayerRigid, jump_height : float, state : PhysicsDirectBodyState3D):
	player.linear_velocity.y = jump_height
	get_node('../../JumpTime').start()
	await get_node('../../JumpTime').timeout
	get_node('../../JumpStateMachine').change_state('PlayerGroundIdle')

func _ready() -> void:
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)

func _exit_state() -> void:
	set_physics_process(false)
