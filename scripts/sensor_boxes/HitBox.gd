class_name HitBox
extends Area


export var damage := 10


func _init() -> void:
	collision_layer = 64
	collision_mask = 0
