extends Node

var conf = ConfigFile.new()

@export var forward : Key
@export var back : Key
@export var strafe_left : Key
@export var strafe_right : Key
@export var jump : Key
@export var ui_cancel : Key
@export var pause_native : Key
@export var pause_web : Key
@export var tool_key : Key
@export var interact : Key
@export var aim_key : Key

@export var tool_mouse : MouseButton
@export var aim_mouse : MouseButton


func set_default_map():
	forward = KEY_W
	back = KEY_S
	strafe_left = KEY_A
	strafe_right = KEY_D
	jump = KEY_SPACE
	ui_cancel = KEY_X
	pause_native = KEY_ESCAPE
	pause_web = KEY_TAB
	interact = KEY_F
	tool_key = KEY_Q
	aim_key = KEY_E
	
	tool_mouse = MOUSE_BUTTON_LEFT
	aim_mouse = MOUSE_BUTTON_RIGHT

func save_map(path: String):
	conf.set_value("controls", "forward", forward)
	conf.set_value("controls", "back", back)
	conf.set_value("controls", "strafe_left", strafe_left)
	conf.set_value("controls", "strafe_right", strafe_right)
	conf.set_value("controls", "jump", jump)
	conf.set_value("controls", "ui_cancel", ui_cancel)
	conf.set_value("controls", "pause_native", pause_native)
	conf.set_value("controls", "pause_web", pause_web)
	conf.set_value("controls", "interact", interact)
	conf.set_value("controls", "tool_key", tool_key)
	conf.set_value("controls", "aim_key", aim_key)
	
	conf.set_value("controls", "tool_mouse", tool_mouse)
	conf.set_value("controls", "aim_mouse", aim_mouse)
	
	conf.save(path)

func load_map(map):
	var err = conf.load(map)
	if err != OK:
		set_default_map()
	else:
		for control in conf.get_sections():
			forward = conf.get_value(control, "forward")
			back = conf.get_value(control, "back")
			strafe_left = conf.get_value(control, "strafe_left")
			strafe_right = conf.get_value(control, "strafe_right")
			jump = conf.get_value(control, "jump")
			ui_cancel = conf.get_value(control, "ui_cancel")
			pause_native = conf.get_value(control, "pause_native")
			pause_web = conf.get_value(control, "pause_web")
			interact = conf.get_value(control, "interact")
			tool_key =  conf.get_value(control, "tool_key")
			aim_key =  conf.get_value(control, "aim_key")
			
			tool_mouse =  conf.get_value(control, "tool_mouse")
			aim_mouse = conf.get_value(control, "aim_mouse")
	Keyboard.load_new_map()

func import_map(map: String):
	conf.load(map)
	load_map(map)
