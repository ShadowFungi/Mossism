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
var temp_transform: Transform3D

var speed := 1.0

var reversible : bool = false
var reversible_property : bool = 0


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
	
	if 'collision_mask' in properties:
		set_collision_mask_value(1, false)
		for dimension in 3:
			if properties.collision_mask[dimension] > int(0) and properties.collision_mask[dimension] < int(33):
				set_collision_mask_value(properties.collision_mask[dimension], true)
	
	if 'collision_layers' in properties:
		set_collision_layer_value(1, false)
		for dimension in 3:
			if properties.collision_layers[dimension] > int(0) and properties.collision_layers[dimension] < int(33):
				set_collision_layer_value(properties.collision_layers[dimension], true)
	
	if 'render_layers' in properties:
		await self.ready
		if find_child("*mesh_instance"):
			find_child("*mesh_instance").set_layer_mask_value(1, false)
			for dimension in 3:
				if properties.render_layers[dimension] > int(0) and properties.render_layers[dimension] < int(21):
						#print(self.find_child("*_mesh_instance", true, true), properties.render_layers[dimension])
						find_child("*mesh_instance").set_layer_mask_value(properties.render_layers[dimension], true)


func _process(delta: float) -> void:
	transform = transform.interpolate_with(target_transform, speed * delta)
	if Level.map_baked == false and Level.map_bake_ended == true:
		motion_ended()


func _init() -> void:
	base_transform = transform
	target_transform = base_transform
	final_transform = base_transform * offset_transform


func _ready() -> void:
	self.add_to_group("ground", true)


func use() -> void:
	#print(reversible)
	if reversible == true:
		reverse_motion()
	else:
		play_motion()


func play_motion() -> void:
	temp_transform = base_transform * offset_transform
	if target_transform.origin.y < temp_transform.origin.y:
		print("1.2")
		target_transform.origin.x = snapped(temp_transform.origin.x, 0.1)
		target_transform.origin.y = snapped(temp_transform.origin.y, 0.1)
		target_transform.origin.z = snapped(temp_transform.origin.z, 0.1)
	if target_transform.origin.y > temp_transform.origin.y:
		print("2.1")
		if test_move(transform, offset_transform.origin) == false:
			target_transform.origin.x = snapped(temp_transform.origin.x, 0.1)
			target_transform.origin.y = snapped(temp_transform.origin.y, 0.1)
			target_transform.origin.z = snapped(temp_transform.origin.z, 0.1)
	#print(target_transform)
	Level.map_baked = false
	if reversible_property == true:
		reversible = true


func reverse_motion() -> void:
	print(temp_transform.origin, ' temp')
	print(base_transform.origin, ' base')
	print(offset_transform.origin, ' offset')
	print(test_move(temp_transform, -Vector3(0, offset_transform.origin.y, 0), null, 0))
	if temp_transform.origin.y > base_transform.origin.y:
		print("2.3")
		if test_move(Transform3D(temp_transform.basis, Vector3(temp_transform.origin.x, temp_transform.origin.y - 0.2, temp_transform.origin.z)), -Vector3(0, offset_transform.origin.y, 0)) == false:
			target_transform.origin.x = snapped(base_transform.origin.x, 0.1)
			target_transform.origin.y = snapped(base_transform.origin.y, 0.1)
			target_transform.origin.z = snapped(base_transform.origin.z, 0.1)
			Level.map_baked = false
			if reversible_property == true:
				reversible = false
	elif temp_transform.origin.y < base_transform.origin.y:
		print("3.2")
		target_transform.origin.x = snapped(base_transform.origin.x, 0.1)
		target_transform.origin.y = snapped(base_transform.origin.y, 0.1)
		target_transform.origin.z = snapped(base_transform.origin.z, 0.1)
		Level.map_baked = false
		if reversible_property == true:
			reversible = false


func motion_ended() -> void:
	if snapped(transform.origin.z, 0.1) == target_transform.origin.z or snapped(transform.origin.y, 0.1) == target_transform.origin.y or snapped(transform.origin.x, 0.1) == target_transform.origin.x:
		if Level.map_bake_ended != false:
			Level.bake()
