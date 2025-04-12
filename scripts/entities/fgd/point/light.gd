@tool
class_name FuncGodotLight
extends Light3D


@export var func_godot_properties: Dictionary

func _func_godot_apply_properties(props: Dictionary) -> void:
	if not Engine.is_editor_hint():
		return
	
	for child in get_children():
		remove_child(child)
		child.queue_free()
	
	if 'mangle' in props:	
		var yaw = props['mangle'].x
		var pitch = props['mangle'].y
		rotate(Vector3.UP, deg_to_rad(180 + yaw))
		rotate(transform.basis.x, deg_to_rad(180 + pitch))
	
		if 'angle' in props:
			set_param(Light3D.PARAM_SPOT_ANGLE, props['angle'])
	
	var light_brightness = 300
	if 'light' in props:
		light_brightness = props['light']
		set_param(Light3D.PARAM_ENERGY, light_brightness / 100.0)
		set_param(Light3D.PARAM_INDIRECT_ENERGY, light_brightness / 100.0)
	
	var light_range := 1.0
	if 'wait' in props:
		light_range = props['wait']
	
	var normalized_brightness = light_brightness / 300.0
	set_param(Light3D.PARAM_RANGE, 16.0 * light_range * (normalized_brightness * normalized_brightness))
	
	var light_attenuation = 0
	if 'delay' in props:
		light_attenuation = props['delay']
	
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
	
	set_param(Light3D.PARAM_ATTENUATION, attenuation)
	set_shadow(true)
	set_bake_mode(Light3D.BAKE_STATIC)
	
	var light_color = Color.WHITE
	if '_color' in props:
		light_color = props['_color']
	
	set_color(light_color)
