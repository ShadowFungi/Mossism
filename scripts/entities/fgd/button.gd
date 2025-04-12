@tool
class_name Button3D
extends Area3D

signal trigger()
signal pressed()
signal released()

@export var func_godot_properties: Dictionary

@export var target: String = ""
@export var targetfunc: String = ""
@export var targetname: String = ""

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

func _func_godot_apply_properties(props: Dictionary) -> void:
	if 'target' in props:
		target = props["target"] as String
	if 'targetfunc' in props:
		targetfunc = props["targetfunc"] as String
	if 'targetname' in props:
		targetname = props["targetname"] as String
	
	if 'axis' in props:
		axis = props['axis'].normalized()
	
	if 'kill_bullets' in props:
		kill_bullets = props['kill_bullets']
	
	if 'speed' in props:
		speed = props['speed']
	
	if 'depth' in props:
		depth = float(props['depth'])
	
	if 'release_delay' in props:
		release_delay = props['release_delay']
	
	if 'trigger_signal_delay' in props:
		trigger_signal_delay = props['trigger_signal_delay']
	
	if 'press_signal_delay' in props:
		press_signal_delay = props['press_signal_delay']
	
	if 'release_signal_delay' in props:
		release_signal_delay = props['release_signal_delay']
	
	#if 'render_layers' in props:
	#	await self.ready
	#	for dimension in 3:
	#		if props.render_layers[dimension] > int(0) and props.render_layers[dimension] < int(21):
	#			#print(self.find_child("*_mesh_instance", true, true), props.render_layers[dimension])
	#			find_child("*mesh_instance").set_layer_mask_value(props.render_layers[dimension], true)
	
	if 'collision_mask' in props:
		for dimension in 3:
			if props['collision_mask'][dimension] > int(0) and props['collision_mask'][dimension] < int(33):
				set_collision_mask_value(props['collision_mask'][dimension], true)
	
	if 'collision_layers' in props:
		for dimension in 3:
			if props['collision_layers'][dimension] > int(0) and props['collision_layers'][dimension] < int(33):
				set_collision_layer_value(props['collision_layers'][dimension], true)

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
	AlertTriggers.activate_targets(self, target)


func emit_pressed() -> void:
	await get_tree().create_timer(press_signal_delay).timeout
	AlertTriggers.activate_targets(self, target)


func release() -> void:
	if not is_pressed:
		return
	
	is_pressed = false
	
	await get_tree().create_timer(release_delay).timeout
	released.emit()
