class_name HurtBox
extends Area


func _init() -> void:
	collision_layer = 0
	collision_mask = 64


func _ready() -> void:
	connect('area_entered', self, "_on_area_entered")


func _on_area_entered(hitbox: HitBox) -> void:
	if hitbox == null:
		return
	
	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage)
