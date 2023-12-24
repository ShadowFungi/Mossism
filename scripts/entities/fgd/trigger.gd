extends Area3D


@export var properties : Dictionary :
	get:
		return properties
	set(new_properties):
		if(properties != new_properties):
			properties = new_properties
			update_properties()

signal trigger()

var toggle_enter: bool = false
var toggle_exit: bool = false

func update_properties() -> void:
	if 'collision_mask' in properties:
		for dimension in 3:
			if properties.collision_mask[dimension] > 0 and properties.collision_mask[dimension] < 33:
				print(properties.collision_mask[dimension])
				set_collision_mask_value(properties.collision_mask[dimension], true)
	
	if 'collision_layers' in properties:
		for dimension in 3:
			if properties.collision_layers[dimension] > int(0) and properties.collision_layers[dimension] < int(33):
				set_collision_layer_value(properties.collision_layers[dimension], true)
	
	if 'toggle_enter' in properties:
		toggle_enter = properties.toggle_enter
	
	if 'toggle_exit' in properties:
		toggle_exit = properties.toggle_exit


func _ready():
	#print(get_collision_layer())
	#print(get_collision_mask())
	self.body_entered.connect(handle_body_entered)
	self.body_exited.connect(handle_body_exited)

func handle_body_entered(body: Node):
	if toggle_enter:
		if body is StaticBody3D:
			return
		
		emit_signal('trigger')

func handle_body_exited(body: Node):
	if toggle_exit:
		if body is StaticBody3D:
			return
		
		emit_signal('trigger')
