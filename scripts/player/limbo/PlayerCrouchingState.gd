extends LimboState

@export_category('Crouch Options')
@export var crouch_size: float

@export_group('Dependencies')
@export var player: CharacterBody3D
@export var col_shape: CollisionShape3D
@export var anim_player: AnimationPlayer
@export var head_target: Node3D
@export var meta_rig: Node3D
@export var crouch_cast: ShapeCast3D
@export var col_shape_1: CollisionShape3D
@export var col_shape_2: CollisionShape3D

var shape: CapsuleShape3D
var og_size: float

func _ready() -> void:
	shape = col_shape.get_shape()


func _enter() -> void:
	head_target.global_position.y = head_target.global_position.y - 1.28
	col_shape_1.global_position.y -= 1.28
	col_shape_2.global_position.y -= 1.28
	meta_rig.global_position.y = meta_rig.global_position.y - 0.835
	og_size = shape.height
	shape.height = crouch_size
	#print(shape.height)
	col_shape.position = (col_shape.position / 1.3)


func _update(_delta: float) -> void:
	if !Input.is_action_pressed('crouch') and crouch_cast.is_colliding() == false:
		dispatch(&'crouch_ended')
	if player.velocity.y != 0 and player.running == true:
		player.velocity.x = player.velocity.x * player.CANNONBALL_MODIFIER
		player.velocity.z = player.velocity.z * player.CANNONBALL_MODIFIER
	else:
		player.velocity.x = player.velocity.x * player.CROUCHING_MODIFIER
		player.velocity.z = player.velocity.z * player.CROUCHING_MODIFIER


func _exit() -> void:
	col_shape_1.global_position.y += 1.28
	col_shape_2.global_position.y += 1.28
	head_target.global_position.y = head_target.global_position.y + 1.28
	meta_rig.global_position.y = meta_rig.global_position.y + 0.835
	col_shape.position = (col_shape.position * 1.3)
	shape.height = og_size
