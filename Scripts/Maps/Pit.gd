extends Spatial



func _on_death_trigger():
	get_tree().root.get_node("Node/ViewContainer/ViewportContainer/Viewport/Player/GameOver").show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true


func _on_entity_265_button_trigger():
	get_node("Navigation/NavigationMeshInstance")
