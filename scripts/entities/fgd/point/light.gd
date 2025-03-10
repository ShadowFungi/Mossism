@tool
class_name FuncGodotLight
extends Light3D


@export var properties: Dictionary:
	get:
		return properties  # TODO Converter40 Non existent get function
	set(new_properties):
		if properties != new_properties:
			properties = new_properties
			update_properties()


var light_node: Light3D = null


func update_properties():
	if not Engine.is_editor_hint():
		return
	
	for child in get_children():
		remove_child(child)
		child.queue_free()
	
	if 'mangle' in properties:
		light_node = SpotLight3D.new()
	
		var yaw = properties['mangle'].x
		var pitch = properties['mangle'].y
		light_node.rotate(Vector3.UP, deg_to_rad(180 + yaw))
		light_node.rotate(light_node.transform.basis.x, deg_to_rad(180 + pitch))
	
		if 'angle' in properties:
			light_node.set_param(Light3D.PARAM_SPOT_ANGLE, properties['angle'])
	else:
		light_node = OmniLight3D.new()
	
	var light_brightness = 300
	if 'light' in properties:
		light_brightness = properties['light']
		light_node.set_param(Light3D.PARAM_ENERGY, light_brightness / 100.0)
		light_node.set_param(Light3D.PARAM_INDIRECT_ENERGY, light_brightness / 100.0)
	
	var light_range := 1.0
	if 'wait' in properties:
		light_range = properties['wait']
	
	var normalized_brightness = light_brightness / 300.0
	light_node.set_param(Light3D.PARAM_RANGE, 16.0 * light_range * (normalized_brightness * normalized_brightness))
	
	var light_attenuation = 0
	if 'delay' in properties:
		light_attenuation = properties['delay']
	
	var attenuation = 0
	match light_attenuation:
		0:
			attenuation = 1.0
		1:
			attenuation = 0.5
		2:
			attenuation = 0.25
		3:
			attenuation = 0.15
		4:
			attenuation = 0
		5:
			attenuation = 0.9
		_:
			attenuation = 1
	
	light_node.set_param(Light3D.PARAM_ATTENUATION, attenuation)
	light_node.set_shadow(true)
	light_node.set_bake_mode(Light3D.BAKE_STATIC)
	
	var light_color = Color.WHITE
	if '_color' in properties:
		light_color = properties['_color']
	
	light_node.set_color(light_color)
	
	add_child(light_node)
	
	if is_inside_tree():
		var tree = get_tree()
		if tree:
			var edited_scene_root = tree.get_edited_scene_root()
			if edited_scene_root:
				light_node.set_owner(edited_scene_root)
