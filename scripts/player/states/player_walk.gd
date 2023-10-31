class_name PlayerWalk
extends PlayerState

var speed : float = 14

func physics_update(_delta) -> void:
	pass

func forces(player : PlayerRigid, forces_state : PhysicsDirectBodyState3D, direction : Vector3):
	player.linear_velocity.x = -(direction.x * speed)
	player.linear_velocity.z = -(direction.z * speed)
	#player.linear_velocity.y = -((player.gravity * forces_state.step) * player.gravity_scale)
	look_follow(forces_state, get_parent().get_parent().global_transform, get_parent().get_parent().get_node('LookPivot/LookTarget').global_transform.origin)

func _ready() -> void:
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)

func _exit_state() -> void:
	set_physics_process(false)

