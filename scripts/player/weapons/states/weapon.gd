class_name Weapon
extends State

@onready var weapon_pivot : Node3D = owner.get_node('MetaRig/Pivot/Camera3D/Weapons')

func _ready() -> void:
	await owner.ready
	
	assert(weapon_pivot != null)
