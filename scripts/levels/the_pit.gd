extends Node3D


func _ready() -> void:
	get_tree().set_pause(false)
	SpawnPlayer.spawn_player(SpawnPlayer.get_spawns())
