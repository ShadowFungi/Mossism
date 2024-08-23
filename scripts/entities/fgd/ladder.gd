extends Area3D


@export var properties : Dictionary :
	get:
		return properties
	set(new_properties):
		if(properties != new_properties):
			properties = new_properties
			update_properties()

var layers : Dictionary
var layer_collection : int


func update_properties() -> void:
	if 'collision_mask' in properties:
		for dimension in 3:
			if properties.collision_mask[dimension] > int(0) and properties.collision_mask[dimension] < int(33):
				set_collision_mask_value(properties.collision_mask[dimension], true)
	
	if 'collision_layers' in properties:
		for dimension in 3:
			if properties.collision_layers[dimension] > int(0) and properties.collision_layers[dimension] < int(33):
				set_collision_layer_value(properties.collision_layers[dimension], true)
	
	#if 'render_layers' in properties:
	#	await self.ready
	#	for dimension in 3:
	#		if properties.render_layers[dimension] > int(0) and properties.render_layers[dimension] < int(21):
	#			#print(self.find_child("*_mesh_instance", true, true), properties.render_layers[dimension])
	#			find_child("*mesh_instance").set_layer_mask_value(properties.render_layers[dimension], true)


func _ready() -> void:
	self.body_entered.connect(body_has_entered)
	self.body_exited.connect(body_has_exited)


func body_has_entered(body: Node):
	if body.is_in_group("player") == true:
		body.state = body.States.CLIMBING
		#print('entered')


func body_has_exited(body: Node):
	if body.is_in_group("player") == true:
		body.state = body.States.GROUNDED
		#print('left')
