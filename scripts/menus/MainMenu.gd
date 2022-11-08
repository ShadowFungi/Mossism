extends Control


var scene = preload("res://scenes/modes/SinglePlayer.tscn")

func _on_PlayButton_pressed():
	get_tree().change_scene_to(scene)



func _on_MultiplayerToggle_pressed():
	if scene == preload("res://scenes/modes/SplitScreen.tscn"):
		scene = preload("res://scenes/modes/SinglePlayer.tscn")
	else:
		scene = preload("res://scenes/modes/SplitScreen.tscn")


func _on_OptionsButton_pressed():
	get_tree().change_scene("res://scenes/menus/OptionsMenu.tscn")
