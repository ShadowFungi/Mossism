extends Area3D

signal trigger()
signal pressed()
signal released()

@export var properties: Dictionary :
	get:
		return properties # TODOConverter40 Non existent get function 
	set(new_properties):
		if(properties != new_properties):
			properties = new_properties
			update_properties()

var is_pressed = false
var base_translation = Vector3.ZERO
var axis := Vector3.DOWN
var speed := 8.0
var depth := 0.8
var release_delay := 0.0
var trigger_signal_delay :=  0.0
var press_signal_delay :=  0.0
var release_signal_delay :=  0.0

var overlaps := 0
var kill_bullets : bool = 0

func update_properties() -> void:
	if 'axis' in properties:
		axis = properties.axis.normalized()
	
	if 'kill_bullets' in properties:
		kill_bullets = properties.kill_bullets
	
	if 'speed' in properties:
		speed = properties.speed
	
	if 'depth' in properties:
		depth = float(properties.depth)
	
	if 'release_delay' in properties:
		release_delay = properties.release_delay
	
	if 'trigger_signal_delay' in properties:
		trigger_signal_delay = properties.trigger_signal_delay
	
	if 'press_signal_delay' in properties:
		press_signal_delay = properties.press_signal_delay
	
	if 'release_signal_delay' in properties:
		release_signal_delay = properties.release_signal_delay
	
	if 'collision_mask' in properties:
		for dimension in 3:
			if properties.collision_mask[dimension] > int(0) and properties.collision_mask[dimension] < int(33):
				set_collision_mask_value(properties.collision_mask[dimension], true)
	
	if 'collision_layers' in properties:
		for dimension in 3:
			if properties.collision_layers[dimension] > int(0) and properties.collision_layers[dimension] < int(33):
				set_collision_layer_value(properties.collision_layers[dimension], true)
	
	if 'render_layers' in properties:
		await self.ready
		for dimension in 3:
			if properties.render_layers[dimension] > int(0) and properties.render_layers[dimension] < int(21):
				#print(self.find_child("*_mesh_instance", true, true), properties.render_layers[dimension])
				find_child("*mesh_instance").set_layer_mask_value(properties.render_layers[dimension], true)

func _init() -> void:
	connect('body_shape_entered', body_shape_entered)
	connect('body_shape_exited', body_shape_exited)

func _enter_tree() -> void:
	base_translation = position

func _process(delta: float) -> void:
	var target_position = base_translation + (axis * (depth if is_pressed else 0.0))
	position = position.lerp(target_position, speed * delta)

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

	emit_trigger()
	emit_pressed()

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
