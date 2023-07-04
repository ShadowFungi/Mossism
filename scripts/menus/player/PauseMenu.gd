extends Control

#@onready var id = get_parent().id
@onready var resume_button = get_node("HBoxContainer/VBoxContainer/ResumeButton")
@onready var quit_button = self.get_node("HBoxContainer/VBoxContainer/QuitButton")
@onready var options_button = get_node("HBoxContainer/VBoxContainer/OptionsButton")
@onready var menu_button = get_node("HBoxContainer/VBoxContainer/MenuButton")

@onready var timed = get_node("Timer")

## Scene_manager options
@export var fade_speed : float = 1.0
@export var fade_pattern : String = "fade"
@export var fade_smoothness = 0.1
@export var fade_out_invert : bool = true
@export var fade_in_invert : bool = false
@export var color : Color = Color(0, 0, 0)
@export var timeout : float = 0.0
@export var clickable : bool = true
@export var add_to_back : bool = true

@onready var fade_out_opts = SceneManager.create_options(fade_speed, fade_pattern, fade_smoothness, fade_out_invert)
@onready var fade_in_opts = SceneManager.create_options(fade_speed, fade_pattern, fade_smoothness, fade_in_invert)
@onready var general_opts = SceneManager.create_general_options(color, timeout, clickable, add_to_back)



func _ready():
	SceneManager.validate_pattern(fade_pattern)
	#print(id)
	self.hide()
	resume_button.pressed.connect(unpause)
	quit_button.pressed.connect(call_quit)
	options_button.pressed.connect(options)
	menu_button.pressed.connect(menu)


#func _unhandled_input(event: InputEvent) -> void:
#	if event.is_action_pressed('player-%s_pause' % get_parent().id):
#		if get_tree().paused == true:
#			resume_button.set_pressed(true)


func pause():
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().set_pause(true)
	self.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func unpause():
	get_tree().set_pause(false)
	timed.set_wait_time(0.00025)
	timed.set_one_shot(true)
	timed.start()
	self.hide()
	await timed.timeout
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func options():
	$OptionsMenu.show()
	$HBoxContainer.hide()


func menu():
	get_tree().set_pause(false)
	self.hide()
	SceneManager.change_scene("StartMenu", fade_out_opts, fade_in_opts, general_opts)


func call_quit():
	get_tree().quit()
