extends Node


func rumble(duration: float = 0.5, start_intensity: float = 0.25, end_intensity: float = 0.75, controller_id: int = 0):
	if Input.get_connected_joypads().has(controller_id):
		Input.start_joy_vibration(controller_id, start_intensity, end_intensity, duration)
