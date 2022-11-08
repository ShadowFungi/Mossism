extends KinematicBody

export(Dictionary) var properties setget set_properties

var base_transform: Transform
var offset_transform: Transform
var target_transform: Transform
var final_transform: Transform

var map_baked = true
onready var navmeshi = get_tree().root.find_node("NavigationMeshInstance", true, false)
var bake_ended = true

var speed := 1.0

func set_properties(new_properties: Dictionary) -> void:
	if properties != new_properties:
		properties = new_properties
		update_properties()

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
	if map_baked == false:
		motion_ended()

func _init() -> void:
	base_transform = transform
	target_transform = base_transform
	final_transform = base_transform * offset_transform

func _ready() -> void:
	navmeshi.connect("bake_finished", self, "_baked")

func use() -> void:
	play_motion()

func play_motion() -> void:
	var temp_transform = base_transform * offset_transform
	target_transform.origin.x = stepify(temp_transform.origin.x, 0.1)
	target_transform.origin.y = stepify(temp_transform.origin.y, 0.1)
	target_transform.origin.z = stepify(temp_transform.origin.z, 0.1)
	print(target_transform)
	map_baked = false

func reverse_motion() -> void:
	target_transform.origin.x = stepify(base_transform.origin.x, 0.1)
	target_transform.origin.y = stepify(base_transform.origin.y, 0.1)
	target_transform.origin.z = stepify(base_transform.origin.z, 0.1)
	map_baked = false

func motion_ended() -> void:
	if stepify(transform.origin.z, 0.1) == target_transform.origin.z or stepify(transform.origin.y, 0.1) == target_transform.origin.y or stepify(transform.origin.x, 0.1) == target_transform.origin.x:
		if bake_ended != false:
			print("success")
			self.add_to_group("ground", true)
			navmeshi.bake_navigation_mesh(true)
			map_baked = true
			bake_ended = false

func _baked():
	bake_ended = true
