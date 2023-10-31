extends Node


var map_baked: bool = true
var map_bake_ended: bool = true

@onready var nav_instance : NavigationRegion3D


func _ready():
	var navmesh = Callable(self, "_bake_complete")
	if nav_instance:
		nav_instance.connect("bake_finished", navmesh)


func bake(nav_region : NavigationRegion3D = nav_instance) -> void:
	nav_instance = get_tree().root.get_node("/root/Node3D/GridContainer/SubViewportContainer/SubViewport/NavigationRegion3D")
	nav_region.bake_navigation_mesh(true)
	#print("platform move successful")
	map_baked = true
	map_bake_ended = false


func _bake_complete() -> bool:
	map_bake_ended = true
	return map_bake_ended
