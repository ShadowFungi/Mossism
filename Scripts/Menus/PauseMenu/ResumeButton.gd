extends Button


var mode = 0

var id

var can_unpause = false
onready var timer = get_parent().get_node("Timer")

func _ready():
	id = get_tree().root.get_node("Node/VPortsContainer/ViewportContainer0/Viewport/Player").id

func _pressed():
	get_parent().hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false

func _process(delta):
	if Input.is_action_just_pressed("keyboard_cancel") and can_unpause == true:
		if get_parent().visible == true:
			get_parent().hide()
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			can_unpause = false
			get_tree().paused = false


func _on_Timer_timeout():
	can_unpause = true
	timer.stop()
