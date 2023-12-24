extends Control



@export var pause_machine: FiniteStateMachine
@export var look_state: State

@onready var resume_button = get_node("HBoxContainer/VBoxContainer/ResumeButton")
@onready var quit_button = self.get_node("HBoxContainer/VBoxContainer/QuitButton")
@onready var options_button = get_node("HBoxContainer/VBoxContainer/OptionsButton")
@onready var menu_button = get_node("HBoxContainer/VBoxContainer/MenuButton")

@onready var timed = get_node("Timer")

func _ready():
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
	pause_machine.change_state(look_state)
	self.hide()
	await timed.timeout
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func options():
	$OptionsMenu.show()
	$HBoxContainer.hide()


func menu():
	SceneSwap.restore_previous_scene(get_node('/root/SplitScreen'), false)
	get_tree().set_pause(false)
	self.hide()


func call_quit():
	get_tree().quit()
