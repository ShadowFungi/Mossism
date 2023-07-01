extends Area3D


@export var properties : Dictionary :
	get:
		return properties
	set(new_properties):
		if(properties != new_properties):
			properties = new_properties
			update_properties()
			

func _init() -> void:
	self.add_to_group("player_spawn")


func update_properties() -> void:
	if 'angle' in properties:
		self.rotate(Vector3.UP, deg_to_rad(properties.angle))
	if 'priority' in properties:
		if properties.priority >= 1:
			self.add_to_group('priority_player_spawner')
