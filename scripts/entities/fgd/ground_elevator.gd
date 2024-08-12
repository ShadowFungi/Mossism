extends CharacterBody3D


@export var properties : Dictionary :
	get:
		return properties
	set(new_properties):
		if(properties != new_properties):
			properties = new_properties
			update_properties()

var base_translation = Vector3.ZERO

var base_transform: Transform3D
var offset_transform: Transform3D
var target_transform: Transform3D
var final_transform: Transform3D
var temp_transform: Transform3D

var speed := 1.0

var reversible : bool = false
var reversible_property : bool = 0
var did_motion_start: bool = false


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
	
	if 'reversible' in properties:
		reversible_property = properties.reversible


func _process(delta: float) -> void:
	if transform.origin != target_transform.origin:
		transform.origin = transform.origin.move_toward(target_transform.origin, speed * delta)
	if transform.origin.is_equal_approx(target_transform.origin) and did_motion_start:
		motion_ended()


func _init() -> void:
	base_transform = transform
	target_transform = base_transform
	final_transform = base_transform * offset_transform


func _enter_tree() -> void:
	base_translation = position


func _ready() -> void:
	var mesh: ArrayMesh = get_child(0).mesh
	var player_detect = Area3D.new()
	player_detect.set_collision_mask_value(32, true)
	player_detect.set_collision_mask_value(1, false)
	player_detect.set_collision_layer_value(1, false)
	var _sig: StringName = "area_entered"
	add_child(player_detect)
	self.add_to_group("ground", true)
	var detect_col := self.get_child(1).duplicate()
	player_detect.add_child(detect_col)
	player_detect.position.y -= mesh.get_aabb().size.y
	player_detect.connect("body_entered", entered)


func use() -> void:
	if reversible == true:
		reverse_motion()
	else:
		play_motion()


func play_motion() -> void:
	temp_transform = base_transform * offset_transform
	if base_transform.origin.y < temp_transform.origin.y:
		#print("1.2")
		target_transform.origin.x = snapped(temp_transform.origin.x, 0.1)
		target_transform.origin.y = snapped(temp_transform.origin.y, 0.1)
		target_transform.origin.z = snapped(temp_transform.origin.z, 0.1)
		did_motion_start = true
		if reversible_property == true:
			reversible = true
	if base_transform.origin.y > temp_transform.origin.y:
		#print("2.1")
		if test_move(Transform3D(temp_transform.basis, Vector3(temp_transform.origin.x, temp_transform.origin.y - 0.2, temp_transform.origin.z)), Vector3(0, offset_transform.origin.y, 0)) == false:
			target_transform.origin.x = temp_transform.origin.x
			target_transform.origin.y = temp_transform.origin.y
			target_transform.origin.z = temp_transform.origin.z
			did_motion_start = true
			if reversible_property == true:
				reversible = true
	#print(target_transform)


func reverse_motion() -> void:
	print(temp_transform.origin, ' temp')
	#print(base_transform.origin, ' base')
	#print(offset_transform.origin, ' offset')
	#print(test_move(temp_transform, -Vector3(0, offset_transform.origin.y, 0), null, 0))
	if temp_transform.origin.y > base_transform.origin.y:
		print("2.3")
		if test_move(Transform3D(base_transform.basis, Vector3(base_transform.origin.x, base_transform.origin.y - 0.2, base_transform.origin.z)), Vector3(0, offset_transform.origin.y, 0)) == false:
			print('move')
			target_transform.origin.x = snapped(base_transform.origin.x, 0.1)
			target_transform.origin.y = snapped(base_transform.origin.y, 0.1)
			target_transform.origin.z = snapped(base_transform.origin.z, 0.1)
			did_motion_start = true
			if reversible_property == true:
				reversible = false
	elif temp_transform.origin.y < base_transform.origin.y:
		print("3.2")
		target_transform.origin.x = snapped(base_transform.origin.x, 0.1)
		target_transform.origin.y = snapped(base_transform.origin.y, 0.1)
		target_transform.origin.z = snapped(base_transform.origin.z, 0.1)
		did_motion_start = true
		if reversible_property == true:
			reversible = false


func motion_ended() -> void:
	did_motion_start = false
	#Level.bake(nav_reg)


func entered(_body) -> void:
	print("entered")
	use()
