class_name SawedOff
extends Weapon

var weapon = load('res://nodes/player/sawed_off.tscn')
var weapon_instance : CharacterBody3D

## Preload the weapon projectile scene(s)
@onready var sawed_off_bullet = preload("res://nodes/player/SawedOffBullet.tscn")


func _ready() -> void:
	weapon_instance = weapon.instantiate()
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)
	weapon_pivot.add_child(weapon_instance)

func _exit_state() -> void:
	set_physics_process(false)
	if weapon_pivot.get_child_count(false) >= 1:
		weapon_pivot.get_child(0, false)

func fire() -> void:
	## Prepare sawed_off_bullet instances
	var shot1 = sawed_off_bullet.instantiate()
	var shot2 = sawed_off_bullet.instantiate()
	
	## Add sawed_off_bullet instances to the world
	get_tree().root.get_node("/root/Node3D/GridContainer/SubViewportContainer/SubViewport/NavigationRegion3D").add_child(shot1)
	get_tree().root.get_node("/root/Node3D/GridContainer/SubViewportContainer/SubViewport/NavigationRegion3D").add_child(shot2)
	
	## Set sawed_off_bullets to appropriate position1
	shot1.transform = weapon_pivot.get_node("SawedOff/Model/Muzzle").global_transform.translated(Vector3(0.2, 0, 0))
	shot2.transform = weapon_pivot.get_node("SawedOff/Model/Muzzle").global_transform.translated(Vector3(-0.2, 0, 0))
	
	## FIRE!
	## Launch sawed_off_bullets through a central impulse
	shot1.apply_central_impulse(-weapon_pivot.get_node("SawedOff/Model/Muzzle").global_transform.basis.z * 80)
	shot2.apply_central_impulse(-weapon_pivot.get_node("SawedOff/Model/Muzzle").global_transform.basis.z * 80)

