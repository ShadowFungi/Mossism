extends Control


var scene = preload("res://Scenes/Modes/SinglePlayer.tscn")

func _on_PlayButton_pressed():
	get_tree().change_scene_to(scene)



func _on_MultiplayerToggle_pressed():
	if scene == preload("res://Scenes/Modes/SplitScreen.tscn"):
		scene = preload("res://Scenes/Modes/SinglePlayer.tscn")
	else:
		scene = preload("res://Scenes/Modes/SplitScreen.tscn")
