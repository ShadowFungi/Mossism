extends LimboState

@export_category('Crouch Options')
@export var crouch_size: float

@export_group('Dependencies')
@export var player: CharacterBody3D
@export var col_shape: CollisionShape3D

var shape: CapsuleShape3D
var og_size: float


func _enter() -> void:
	pass

func _update(_delta: float) -> void:
	if Input.is_action_pressed('player-%s_crouch' % player.id):
		dispatch(&'crouch_started')



func _exit() -> void:
	pass
