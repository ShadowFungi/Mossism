extends Control

#@onready var id = get_parent().id
@onready var resume_button = get_node("HBoxContainer/VBoxContainer/ResumeButton")
@onready var quit_button = get_node("HBoxContainer/VBoxContainer/QuitButton")
@onready var timed = get_node("Timer")

func _ready():
#	print(id)
	self.hide()
	resume_button.pressed.connect(unpause)
	quit_button.pressed.connect(get_tree().quit)

#func _unhandled_input(event):
#	if Input.is_action_just_pressed('player-%s_pause' % id):
#		pass

func pause():
	get_tree().set_pause(true)
	self.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func unpause():
	self.hide()
	get_tree().set_pause(false)
	timed.set_wait_time(0.00025)
	timed.set_one_shot(true)
	timed.start()
	await timed.timeout
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
