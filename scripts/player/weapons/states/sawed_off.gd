class_name SawedOff
extends Weapon


var weapon = load('res://nodes/player/sawed_off.tscn')
var weapon_instance: CharacterBody3D

## Preload the weapon projectile scene(s)
@onready var sawed_off_bullet = preload('res://nodes/player/SawedOffBullet.tscn')


func _ready() -> void:
	weapon_instance = weapon.instantiate()
	weapon_instance.parent = weapon_pivot
	weapon_pivot.add_child(weapon_instance)

func enter_state() -> void:
	weapon_instance.show()

func exit_state() -> void:
	if weapon_pivot.get_child_count(false) >= 1:
		weapon_pivot.get_child(0, false)

func handle_input(event: InputEvent):
	if Input.is_action_just_pressed('player-%s_tool_mouse' % parent.id) && Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED or Input.is_action_just_pressed('player-%s_tool_key' % parent.id):
		if has_method('fire'):
			fire()

func fire() -> void:
	weapon_instance.get_node('Model/Muzzle/AudioStreamPlayer3D').play()
	## Prepare sawed_off_bullet instances
	var shot1 = sawed_off_bullet.instantiate()
	var shot2 = sawed_off_bullet.instantiate()
	
	## Add sawed_off_bullet instances to the world
	get_tree().root.get_node('/root/SplitScreen/GridContainer/SubViewportContainer/SubViewport/NavigationRegion3D').add_child(shot1)
	get_tree().root.get_node('/root/SplitScreen/GridContainer/SubViewportContainer/SubViewport/NavigationRegion3D').add_child(shot2)
	
	## Set sawed_off_bullets to appropriate position1
	shot1.transform = weapon_pivot.get_node('SawedOff/Model/Muzzle').global_transform.translated_local(Vector3(0.2, 0, 0))
	shot2.transform = weapon_pivot.get_node('SawedOff/Model/Muzzle').global_transform.translated_local(Vector3(-0.2, 0, 0))
	## FIRE!
	## Launch sawed_off_bullets through a central impulse
	shot1.apply_central_impulse(-weapon_pivot.get_node('SawedOff/Model/Muzzle').global_transform.basis.z * 80)
	shot2.apply_central_impulse(-weapon_pivot.get_node('SawedOff/Model/Muzzle').global_transform.basis.z * 80)
