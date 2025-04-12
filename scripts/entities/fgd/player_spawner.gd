@tool
class_name PlayerSpawn3D
extends Node3D


@export var func_godot_properties : Dictionary


func _init() -> void:
	self.add_to_group("player_spawn")

func _ready() -> void:
	if Engine.is_editor_hint(): return
	#if SFInputRemapper.controller_count < get_tree().get_nodes_in_group('player').size():
	#	SpawnPlayer.spawn_player(player_scene)

func _func_godot_apply_properties(props: Dictionary) -> void:
	if 'angle' in func_godot_properties:
		self.rotate(Vector3.UP, deg_to_rad(func_godot_properties.angle))
	if 'priority' in func_godot_properties:
		if func_godot_properties.priority >= 1:
			self.add_to_group('priority_player_spawner')
