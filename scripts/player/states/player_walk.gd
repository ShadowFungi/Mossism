class_name PlayerWalk
extends PlayerState

func physics_update(delta) -> void:
	pass

func _ready() -> void:
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)

func _exit_state() -> void:
	set_physics_process(false)

