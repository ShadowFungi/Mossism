extends LimboState


@export_group('Dependencies')
@export var player: CharacterBody3D
@export var col_shape: CollisionShape3D
@export var anim_player: AnimationPlayer
@export var head_target: Node3D
@export var meta_rig: Node3D

var shape: CapsuleShape3D
var og_size: float


func _ready() -> void:
	shape = col_shape.get_shape() 
	og_size = shape.height


func _enter() -> void:
	#anim_player.play(&'Idle')
	pass

func _update(_delta: float) -> void:
	if Input.is_action_pressed('player-%s_crouch' % player.id):
		dispatch(&'crouch_started')


func _exit() -> void:
	pass
