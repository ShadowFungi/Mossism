extends LimboState

@export_category('Crouch Options')
@export var crouch_size: float

@export_group('Dependencies')
@export var player: CharacterBody3D
@export var col_shape: CollisionShape3D

var shape: CapsuleShape3D
var og_size: float

func _ready() -> void:
	shape = col_shape.get_shape()


func _enter() -> void:
	og_size = shape.height
	shape.height = crouch_size
	print(shape.height)
	col_shape.position = (col_shape.position / 1.4)


func _update(_delta: float) -> void:
	if !Input.is_action_pressed('player-%s_crouch' % player.id):
		dispatch(&'crouch_ended')
	player.velocity.x = player.velocity.x * player.CROUCHING_MODIFIER
	player.velocity.z = player.velocity.z * player.CROUCHING_MODIFIER
	print(shape.height)


func _exit() -> void:
	col_shape.position = (col_shape.position * 1.4)
	shape.height = og_size
