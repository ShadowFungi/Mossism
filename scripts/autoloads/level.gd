extends Timer


var map_baked: bool = false
var bake_map: bool = false
var map_bake_ended: bool = true
var prepared: bool = false

var nav_mesh: NavigationMesh = preload('res://assets/nav_mesh/SplitScreen.tres')
var nav_mesh_data: NavigationMeshSourceGeometryData3D = NavigationMeshSourceGeometryData3D.new()
var first_time: bool = true

var map: RID
var primary_instance: NavigationRegion3D = null

func setup_nav_server():
	pass
	#map = NavigationServer3D.map_create()
	#NavigationServer3D.map_set_cell_height(map, 1)
	#NavigationServer3D.map_force_update(map)
	#NavigationServer3D.set_active(true)
	#NavigationServer3D.set_debug_enabled(true)
	#NavigationServer3D.map_set_up(map, Vector3.UP)
	#NavigationServer3D.map_set_active(map, true)
	#NavigationServer3D.bake_from_source_geometry_data(nav_mesh, nav_mesh_data)

func prepare(nav_instance: NavigationRegion3D):
	var bake_call = Callable(self, "_bake_complete")
	if primary_instance == null:
		primary_instance = nav_instance
		primary_instance.connect("bake_finished", bake_call)


#func bake(nav_region: NavigationRegion3D) -> void:
	#if first_time == true:
		#prepare(nav_region)
		#first_time = false
	#if map_baked == false and map_bake_ended == true:
		#map_baked = false
		#nav_region.bake_navigation_mesh(true)
		#map_bake_ended = false
		#await nav_region.bake_finished
		#map_baked = true

func _physics_process(_delta: float) -> void:
	if bake_map == true and map_bake_ended == true:
		while bake_map == true:
			rebake_map()
			await primary_instance.bake_finished
			break
		map_bake_ended = true

func _bake_complete() -> void:
	map_bake_ended = true

func rebake_map():
	print("bake_started")
	primary_instance.bake_navigation_mesh(true)
	NavigationServer3D.bake_from_source_geometry_data_async(nav_mesh, nav_mesh_data)
	bake_map = false
