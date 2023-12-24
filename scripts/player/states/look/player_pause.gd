class_name PlayerPaused
extends State


@export_category('Eneterable States')
@export var look_state: State

@export_category('Dependencies')
@export var pause_menu: Control

func enter_state():
	pause_menu.pause()
