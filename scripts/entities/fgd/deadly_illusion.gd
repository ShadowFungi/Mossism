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

var player : Node
var damagable : bool = false
var type : String = ""


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
	if "damage_type" in properties:
		if properties.damage_type == "lava":
			type = properties.damage_type
		if properties.damage_type == "poison":
			type = properties.damage_type


func _ready() -> void:
	for layer in layers:
		#print(layers[layer])
		layer_collection += pow(2, layers[layer]-1)
	set_collision_mask(layer_collection)
	self.body_entered.connect(body_has_entered)
	self.body_exited.connect(body_has_exited)


func body_has_entered(body: Node):
	if body.is_in_group("player") == true:
		player = body
		damagable = true


func body_has_exited(body: Node):
	if body.is_in_group("player") == true:
		player = null
		damagable = false


func _physics_process(_delta: float) -> void:
	if damagable == true:
		print(player)
		player.damage(type)
