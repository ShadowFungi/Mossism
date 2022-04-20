extends Control


var scene : NodePath = "res://Scenes/Modes/SinglePlayer.tscn"

func _on_PlayButton_pressed():
	get_tree().change_scene(scene)



func _on_MultiplayerToggle_pressed():
	if scene == "res://Scenes/Modes/SplitScreen.tscn":
		scene = "res://Scenes/Modes/SinglePlayer.tscn"
	else:
		scene = "res://Scenes/Modes/SplitScreen.tscn"
