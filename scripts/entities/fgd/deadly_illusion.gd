@tool
class_name DeadlyIllusion3D
extends Area3D


@export var func_godot_properties: Dictionary

var layers: Dictionary
var layer_collection: int

var player: Node
var damagable: bool = false
var type: String = ''


func _func_godot_apply_properties(props: Dictionary) -> void:
	if 'damage_type' in props:
		if props.damage_type == 'fire':
			type = props.damage_type
		if props.damage_type == 'poison':
			type = props.damage_type
	
	#if 'render_layers' in props:
	#	await self.ready
	#	for dimension in 3:
	#		if props.render_layers[dimension] > int(0) and props.render_layers[dimension] < int(21):
	#			#print(self.find_child("*_mesh_instance", true, true), props.render_layers[dimension])
	#			find_child("*mesh_instance").set_layer_mask_value(props.render_layers[dimension], true)
	
	if 'collision_mask' in props:
		for dimension in 3:
			if props.collision_mask[dimension] > int(0) and props.collision_mask[dimension] < int(33):
				set_collision_mask_value(props.collision_mask[dimension], true)
	
	if 'collision_layers' in props:
		for dimension in 3:
			if props.collision_layers[dimension] > int(0) and props.collision_layers[dimension] < int(33):
				set_collision_layer_value(props.collision_layers[dimension], true)


func _ready() -> void:
	self.body_entered.connect(body_has_entered)
	self.body_exited.connect(body_has_exited)


func body_has_entered(body: Node):
	#if body.is_in_group('player') == true:
	#	player = body
	if body.has_method('damage'):
		#damagable = true
		body.damage(type)


func body_has_exited(body: Node):
	#if body.is_in_group('player') == true:
	#	player = null
	if body.has_method('damage'):
		#damagable = false
		body.damage('none')


#func _physics_process(_delta: float) -> void:
	#if damagable == true:
		#print(player)
		#if player != null:
			#if player.has_method('damage'):
				#player.damage(type)
