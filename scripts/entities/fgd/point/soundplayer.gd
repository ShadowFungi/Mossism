@tool
class_name SoundPlayerGD
extends AudioStreamPlayer3D


@export var func_godot_properties: Dictionary

@export var target: String = ""
@export var targetfunc: String = ""
@export var targetname: String = ""

@export var sound_effect: String = ""

func _func_godot_apply_properties(props: Dictionary) -> void:
	if 'target' in props:
		target = props["target"] as String
	if 'targetfunc' in props:
		targetfunc = props["targetfunc"] as String
	if 'targetname' in props:
		targetname = props["targetname"] as String
	if 'sound' in props:
		sound_effect = props['sound']

func _init() -> void:
	pass
	self.connect('finished', sound_finished)

func sound_finished() -> void:
	AlertTriggers.activate_targets(self, target)

func use() -> void:
	pass
	play()
