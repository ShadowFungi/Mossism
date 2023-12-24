class_name PlayerLook
extends State


@export_category('Eneterable States')
@export var pause_state: State

@export_category('Mouse Options')
@export var mouse_sensitivity: float

func handle_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('player-%s_pause' % parent.id):
		return pause_state
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED && parent.id == 1:
		if event is InputEventMouseMotion:
			parent.rotate_y(-event.relative.x * mouse_sensitivity)
			parent.pivot.rotate_x(event.relative.y * mouse_sensitivity)
			parent.pivot.rotation.x = clamp(parent.pivot.rotation.x, deg_to_rad(-80), deg_to_rad(75))
	return null
