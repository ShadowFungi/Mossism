extends Node3D


func _ready() -> void:
	get_tree().set_pause(false)
	$GridContainer/SubViewportContainer/SubViewport/NavigationRegion3D/ThePit.translate(Vector3(0, 1, 0))
	SpawnPlayer.spawn_player(SpawnPlayer.get_spawns())
	$GridContainer/SubViewportContainer/SubViewport/NavigationRegion3D/ThePit.translate(Vector3(-0, -0, -0))
