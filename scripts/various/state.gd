class_name State
extends Node

signal state_finished

var state_machine = null

func _enter_state() -> void:
	pass

func _exit_state() -> void:
	pass

func handle_input(_event: InputEvent) -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	pass
