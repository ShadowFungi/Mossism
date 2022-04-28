extends Spatial



func _on_entity_99_trigger_trigger():
	get_tree().root.get_node("Control/GameOver").show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
