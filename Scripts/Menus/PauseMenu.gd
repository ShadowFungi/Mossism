extends Control


func _process(delta):
	if Input.is_action_just_pressed("keyboard_cancel"):
		if self.visible == true:
			self.hide()
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			get_tree().paused = false

