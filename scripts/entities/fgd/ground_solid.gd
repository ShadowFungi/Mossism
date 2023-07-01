extends StaticBody3D

func _init() -> void:
	self.add_to_group("ground", true)
	collision_layer = pow(2, 1-1)
	#print(self.get_groups())
