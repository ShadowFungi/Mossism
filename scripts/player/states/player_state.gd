class_name PlayerState
extends State

var player : PlayerRigid

func _ready() -> void:
	await owner.ready
	
	player = owner as PlayerRigid
	
	assert(player != null)
