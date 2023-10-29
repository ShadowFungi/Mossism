class_name PlayerGroundIdle
extends PlayerState

func _ready() -> void:
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)

func _exit_state() -> void:
	set_physics_process(false)

func forces(player : PlayerRigid, forces_state : PhysicsDirectBodyState3D, _dir):
	#player.linear_velocity.y = -((player.gravity * forces_state.step) * player.gravity_multiplier)
	look_follow(forces_state, get_parent().get_parent().global_transform, get_parent().get_parent().get_node('LookPivot/LookTarget').global_transform.origin)

