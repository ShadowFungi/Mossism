extends Node3D


@export var func_godot_properties : Dictionary :
	get:
		return func_godot_properties
	set(new_properties):
		if(func_godot_properties != new_properties):
			func_godot_properties = new_properties
			update_properties()

signal trigger()

var toggle_enter: bool = false
var toggle_exit: bool = false
var wait_time: float


func update_properties() -> void:
	if 'wait_time' in func_godot_properties:
		wait_time = func_godot_properties.wait_time


func use() -> void:
	await get_tree().create_timer(wait_time, false).timeout
	Level.rebake_map()
