extends Button


onready var scene = "res://Scenes/Menus/MainMenu.tscn"

func _pressed():
	get_tree().paused = false
	get_tree().change_scene(scene)
