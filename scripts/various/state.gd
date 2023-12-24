class_name State
extends Node


signal state_finished

var parent: CharacterBody3D

@export_category('Base State')
@export var parent_machine: FiniteStateMachine
@export_group('Animation')
@export var animation_name: String

@onready var gravity: int = ProjectSettings.get_setting('physics/3d/default_gravity')


func enter_state() -> void:
	if 'animator' in parent:
		if parent.animator != null:
			parent.animator.play(animation_name)

func exit_state() -> void:
	pass

func handle_input(_event: InputEvent) -> State:
	return null

func frame_update(delta: float) -> State:
	return null

func physics_update(delta: float) -> State:
	return null

func find_state_machine(state_machine_name: StringName):
	if parent_machine:
		if 'machines' in parent_machine:
			var machine_id
			for i in parent_machine.machines:
				if i.name == state_machine_name:
					machine_id = i.get_path()
					#print(machine_id)
					return machine_id
	return null
