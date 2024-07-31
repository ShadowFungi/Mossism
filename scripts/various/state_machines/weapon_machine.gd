class_name WeaponMachine
extends FiniteStateMachine


@export_group('Weapon')
@export var weapon_one: State

@export_group('Dependencies')
@export var right_arm_ik: SkeletonIK3D


func _ready() -> void:
	pass
	#right_arm_ik.target_node = start_state.weapon_instance.get_path()

func change_state(new_state: State):
	super(new_state)
	#right_arm_ik.target_node = new_state.weapon_instance.get_path()
