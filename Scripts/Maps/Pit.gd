extends Spatial



func _on_death_trigger():
	get_tree().root.get_node("Node/GameOver").show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
