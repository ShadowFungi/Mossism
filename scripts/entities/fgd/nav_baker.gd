extends Node3D


@export var properties : Dictionary :
	get:
		return properties
	set(new_properties):
		if(properties != new_properties):
			properties = new_properties
			update_properties()

signal trigger()

var toggle_enter: bool = false
var toggle_exit: bool = false
var wait_time: float


func update_properties() -> void:
	if 'wait_time' in properties:
		wait_time = properties.wait_time


func use() -> void:
	await get_tree().create_timer(wait_time, false).timeout
	Level.rebake_map()
