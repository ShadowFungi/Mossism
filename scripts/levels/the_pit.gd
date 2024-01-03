extends Node3D


func _ready() -> void:
	get_tree().set_pause(false)
	#%NavRegion3D/ThePit.translate(Vector3(0, 1, 0))
	SpawnPlayer.spawn_player(SpawnPlayer.get_spawns())
	#%NavRegion3D/ThePit.translate(Vector3(-0, -0, -0))
	Level.call_deferred('setup_nav_server')
