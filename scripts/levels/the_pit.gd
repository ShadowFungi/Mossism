extends Node


var player_scene: PackedScene = preload("res://nodes/player/player.tscn")


func _ready() -> void:
	get_tree().set_pause(false)
	SpawnPlayer.spawn_player(player_scene)
	#%NavRegion3D/ThePit.translate(Vector3(0, 1, 0))
	#SpawnPlayer.spawn_player(SpawnPlayer.get_spawns())
	#%NavRegion3D/ThePit.translate(Vector3(-0, -0, -0))
	#Level.call_deferred('setup_nav_server')
	Level.prepare($GridContainer/SubViewportContainer/SubViewport/NavigationRegion3D)
	Level.rebake_map()
