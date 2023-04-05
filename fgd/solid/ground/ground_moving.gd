extends CharacterBody3D

@export var properties : Dictionary :
	get:
		return properties
	set(new_properties):
		if(properties != new_properties):
			properties = new_properties
			update_properties()

var base_transform: Transform3D
var offset_transform: Transform3D
var target_transform: Transform3D
var final_transform: Transform3D

@onready var navmeshi = get_tree().root.get_node("/root/Node3D/NavigationRegion3D")

var speed := 1.0


func update_properties() -> void:
	if 'translation' in properties:
		offset_transform.origin = properties.translation

	if 'rotation' in properties:
		offset_transform.basis = offset_transform.basis.rotated(Vector3.RIGHT, properties.rotation.x)
		offset_transform.basis = offset_transform.basis.rotated(Vector3.UP, properties.rotation.y)
		offset_transform.basis = offset_transform.basis.rotated(Vector3.FORWARD, properties.rotation.z)

	if 'scale' in properties:
		offset_transform.basis = offset_transform.basis.scaled(properties.scale)

	if 'speed' in properties:
		speed = properties.speed


func _process(delta: float) -> void:
	transform = transform.interpolate_with(target_transform, speed * delta)
	if Level.map_baked == false and Level.map_bake_ended == true:
		motion_ended()


func _init() -> void:
	base_transform = transform
	target_transform = base_transform
	final_transform = base_transform * offset_transform


func _ready() -> void:
	var navmesh = Callable(self, "_baked")
	navmeshi.connect("bake_finished", navmesh)

func use() -> void:
	play_motion()


func play_motion() -> void:
	var temp_transform = base_transform * offset_transform
	target_transform.origin.x = snapped(temp_transform.origin.x, 0.1)
	target_transform.origin.y = snapped(temp_transform.origin.y, 0.1)
	target_transform.origin.z = snapped(temp_transform.origin.z, 0.1)
	print(target_transform)
	Level.map_baked = false


func reverse_motion() -> void:
	target_transform.origin.x = snapped(base_transform.origin.x, 0.1)
	target_transform.origin.y = snapped(base_transform.origin.y, 0.1)
	target_transform.origin.z = snapped(base_transform.origin.z, 0.1)
	Level.map_baked = false


func motion_ended() -> void:
	if snapped(transform.origin.z, 0.1) == target_transform.origin.z or snapped(transform.origin.y, 0.1) == target_transform.origin.y or snapped(transform.origin.x, 0.1) == target_transform.origin.x:
		if Level.map_bake_ended != false:
			print("success")
			self.add_to_group("ground", true)
			navmeshi.bake_navigation_mesh(true)
			Level.map_baked = true
			Level.map_bake_ended = false


func _baked():
	Level.map_bake_ended = true
