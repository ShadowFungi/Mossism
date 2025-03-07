@tool
extends EditorPlugin

const REMAPPER_AUTOLOAD = "SFInputRemapper"
const KEYCODES_AUTOLOAD = "SFInputKeycodes"
const HAPTICS_AUTOLOAD = "SFInputHaptics"

func _enter_tree() -> void:
	add_autoload_singleton(KEYCODES_AUTOLOAD, "res://addons/fungi_input_remapper/Keycodes.gd")
	add_autoload_singleton(REMAPPER_AUTOLOAD, "res://addons/fungi_input_remapper/InputRemapper.gd")
	add_autoload_singleton(HAPTICS_AUTOLOAD, "res://addons/fungi_input_remapper/Haptics.gd")

func _exit_tree() -> void:
	remove_autoload_singleton(REMAPPER_AUTOLOAD)
	remove_autoload_singleton(KEYCODES_AUTOLOAD)
	remove_autoload_singleton(HAPTICS_AUTOLOAD)
