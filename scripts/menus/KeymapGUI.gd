extends ScrollContainer


@onready var button_forward = $VBoxContainer2/Forward/PanelContainer/HBoxContainer/Button
@onready var button_backward = $VBoxContainer2/Backward/PanelContainer/HBoxContainer/Button
@onready var button_left = $VBoxContainer2/Left/PanelContainer/HBoxContainer/Button
@onready var button_right = $VBoxContainer2/Right/PanelContainer/HBoxContainer/Button
@onready var button_shoot_key = $VBoxContainer2/ShootKey/PanelContainer/HBoxContainer/Button
@onready var button_jump = $VBoxContainer2/Jump/PanelContainer/HBoxContainer/Button


@onready var buttons_dict : Dictionary = {
	1 : 'button_forward',
	2 : 'button_backward',
	3 : 'button_left',
	4 : 'button_right',
	5 : 'button_shoot_key',
	6 : 'button_jump',
}

@onready var input_dict : Dictionary = {
	1 : 'player-0_forward',
	2 : 'player-0_back',
	3 : 'player-0_strafe_left',
	4 : 'player-0_strafe_right',
	5 : 'player-0_tool_key',
	6 : 'player-0_jump',
}
@onready var buttons : Array = [
	button_forward,
	button_backward,
	button_left,
	button_right,
	button_shoot_key,
	button_jump,
]

var ca : Callable
var button_no : int = 1

var action : String
var wanted_text : int
var remap_wanted = false

var button_text : Array = [
	InputRemapper.forward,
	InputRemapper.back,
	InputRemapper.strafe_left,
	InputRemapper.strafe_right,
	InputRemapper.tool_key,
	InputRemapper.jump,
]


func _ready() -> void:
	set_process_unhandled_key_input(false)
	for button in buttons:
		#print(button)
		ca = Callable(self, "func_%s" % buttons_dict[button_no])
		button.set_text(Keycodes.key_letters[button_text[button_no - 1]])
		button_no += 1
		button.pressed.connect(ca)


func func_button_forward():
	set_process_unhandled_key_input(true)
	action = input_dict[1]
	wanted_text = 0
	remap_wanted = true


func func_button_backward():
	set_process_unhandled_key_input(true)
	action = input_dict[2]
	wanted_text = 1
	remap_wanted = true


func func_button_left():
	set_process_unhandled_key_input(true)
	action = input_dict[3]
	wanted_text = 2
	remap_wanted = true


func func_button_right():
	set_process_unhandled_key_input(true)
	action = input_dict[4]
	wanted_text = 3
	remap_wanted = true


func func_button_shoot_key():
	set_process_unhandled_key_input(true)
	action = input_dict[5]
	wanted_text = 4
	remap_wanted = true


func func_button_jump():
	set_process_unhandled_key_input(true)
	action = input_dict[6]
	wanted_text = 5
	remap_wanted = true


func _unhandled_input(event: InputEvent) -> void:
	if remap_wanted:
		await remap_key(event)


func remap_key(event):
	if event.keycode != KEY_ESCAPE:
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, event)
		buttons[wanted_text].set_text(event.as_text())
		set_process_unhandled_key_input(false)
		remap_wanted = false
		return
	elif event.keycode == KEY_ESCAPE:
		return
