extends StaticBody3D

func _init() -> void:
	self.add_to_group("wall", true)
	#print(self.get_groups())
	#collision_layer = pow(2, 2-1)
