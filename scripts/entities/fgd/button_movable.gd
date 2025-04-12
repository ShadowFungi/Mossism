extends Area3D

signal trigger()
signal pressed()
signal released()

@export var func_godot_properties: Dictionary :
	get:
		return func_godot_properties # TODOConverter40 Non existent get function 
	set(new_properties):
		if(func_godot_properties != new_properties):
			func_godot_properties = new_properties
			update_properties()

var is_pressed = false
var base_translation = Vector3.ZERO
var axis := Vector3.DOWN
var button_speed := 8.0
var depth := 0.8
var release_delay := 0.0
var trigger_signal_delay :=  0.0
var press_signal_delay :=  0.0
var release_signal_delay :=  0.0

var overlaps := 0
var kill_bullets : bool = 0

## Variables used for movement
var base_transform: Transform3D
var offset_transform: Transform3D
var target_transform: Transform3D
var final_transform: Transform3D
var temp_transform: Transform3D

var movement_speed: float = 1.0

var reversible: bool = false
var reversible_property: bool = 0

var can_move_self: bool = 1

func update_properties() -> void:
	if 'axis' in func_godot_properties:
		axis = func_godot_properties.axis.normalized()
	
	if 'kill_bullets' in func_godot_properties:
		kill_bullets = func_godot_properties.kill_bullets
	
	if 'button_speed' in func_godot_properties:
		button_speed = func_godot_properties.button_speed
	
	if 'depth' in func_godot_properties:
		depth = float(func_godot_properties.depth)
	
	if 'release_delay' in func_godot_properties:
		release_delay = func_godot_properties.release_delay
	
	if 'trigger_signal_delay' in func_godot_properties:
		trigger_signal_delay = func_godot_properties.trigger_signal_delay
	
	if 'press_signal_delay' in func_godot_properties:
		press_signal_delay = func_godot_properties.press_signal_delay
	
	if 'release_signal_delay' in func_godot_properties:
		release_signal_delay = func_godot_properties.release_signal_delay
	
	if 'translation' in func_godot_properties:
		offset_transform.origin = func_godot_properties.translation
	
	if 'rotation' in func_godot_properties:
		offset_transform.basis = offset_transform.basis.rotated(Vector3.RIGHT, func_godot_properties.rotation.x)
		offset_transform.basis = offset_transform.basis.rotated(Vector3.UP, func_godot_properties.rotation.y)
		offset_transform.basis = offset_transform.basis.rotated(Vector3.FORWARD, func_godot_properties.rotation.z)
	
	if 'scale' in func_godot_properties:
		offset_transform.basis = offset_transform.basis.scaled(func_godot_properties.scale)
	
	if 'movement_speed' in func_godot_properties:
		movement_speed = func_godot_properties.movement_speed
	
	if 'reversible' in func_godot_properties:
		reversible_property = func_godot_properties.reversible
	
	if 'can_move_self' in func_godot_properties:
		can_move_self = func_godot_properties.can_move_self
	
	#if 'render_layers' in func_godot_properties:
	#	await self.ready
	#	for dimension in 3:
	#		if func_godot_properties.render_layers[dimension] > int(0) and func_godot_properties.render_layers[dimension] < int(21):
	#			#print(self.find_child("*_mesh_instance", true, true), func_godot_properties.render_layers[dimension])
	#			find_child("*mesh_instance").set_layer_mask_value(func_godot_properties.render_layers[dimension], true)
	
	if 'collision_mask' in func_godot_properties:
		set_collision_mask_value(1, false)
		for dimension in 3:
			if func_godot_properties.collision_mask[dimension] > int(0) and func_godot_properties.collision_mask[dimension] < int(33):
				set_collision_mask_value(func_godot_properties.collision_mask[dimension], true)
	
	if 'collision_layers' in func_godot_properties:
		set_collision_layer_value(1, false)
		for dimension in 3:
			if func_godot_properties.collision_layers[dimension] > int(0) and func_godot_properties.collision_layers[dimension] < int(33):
				set_collision_layer_value(func_godot_properties.collision_layers[dimension], true)

func _init() -> void:
	connect('body_shape_entered', body_shape_entered)
	connect('body_shape_exited', body_shape_exited)
	base_transform = transform
	target_transform = base_transform
	final_transform = base_transform * offset_transform

func _enter_tree() -> void:
	base_translation = position

func _process(delta: float) -> void:
	transform.origin = transform.origin.move_toward(target_transform.origin, movement_speed * delta)

func body_shape_entered(_body_id, body: Node, _body_shape_idx: int, _self_shape_idx: int) -> void:
	if body.is_in_group('bullet') and kill_bullets == true:
		body.queue_free()
	
	if body is StaticBody3D:
		return
	
	if overlaps == 0:
		press()
	
	overlaps += 1

func body_shape_exited(_body_id, body: Node, _body_shape_idx: int, _self_shape_idx: int) -> void:
	if body is StaticBody3D:
		return
	
	overlaps -= 1
	if overlaps == 0:
		if release_delay == 0:
			release()
		elif release_delay > 0:
			await get_tree().create_timer(release_delay).timeout
			release()

func press() -> void:
	if is_pressed:
		return
	
	is_pressed = true
	
	if can_move_self:
		use()
	
	emit_trigger()
	emit_pressed()

func use() -> void:
	if reversible == true:
		reverse_motion()
	else: play_motion()

func emit_trigger() -> void:
	await get_tree().create_timer(trigger_signal_delay).timeout
	trigger.emit()

func emit_pressed() -> void:
	await get_tree().create_timer(press_signal_delay).timeout
	pressed.emit()

func release() -> void:
	if not is_pressed:
		return
	
	is_pressed = false
	
	await get_tree().create_timer(release_delay).timeout
	released.emit()

func play_motion() -> void:
	temp_transform = base_transform * offset_transform
	target_transform.origin.x = snapped(temp_transform.origin.x, 0.1)
	target_transform.origin.y = snapped(temp_transform.origin.y, 0.1)
	target_transform.origin.z = snapped(temp_transform.origin.z, 0.1)
	#print(target_transform)
	if reversible_property == true:
		reversible = true

func reverse_motion() -> void:
	#print(temp_transform.origin, ' temp')
	#print(base_transform.origin, ' base')
	#print(offset_transform.origin, ' offset')
	target_transform.origin.x = snapped(base_transform.origin.x, 0.1)
	target_transform.origin.y = snapped(base_transform.origin.y, 0.1)
	target_transform.origin.z = snapped(base_transform.origin.z, 0.1)
	if reversible_property == true:
		reversible = false
