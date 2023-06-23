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

signal trigger()


func update_properties() -> void:
	if "layer_one" in properties:
		layers["one"] = properties.layer_one
	if "layer_two" in properties:
		layers["two"] = properties.layer_two
	if "layer_three" in properties:
		layers["three"] = properties.layer_three
	if "layer_four" in properties:
		layers["four"] = properties.layer_four
	if "layer_five" in properties:
		layers["five"] = properties.layer_five
	if "layer_six" in properties:
		layers["six"] = properties.layer_six
	if "layer_seven" in properties:
		layers["seven"] = properties.layer_seven
	if "layer_eight" in properties:
		layers["eight"] = properties.layer_eight


func _ready():
	for layer in layers:
		#print(layers[layer])
		layer_collection += pow(2, layers[layer]-1)
	set_collision_mask(layer_collection)
	print(get_collision_layer())
	print(get_collision_mask())
	self.body_entered.connect(handle_body_entered)

func handle_body_entered(body: Node):
	if body is StaticBody3D:
		return
	
	emit_signal("trigger")
