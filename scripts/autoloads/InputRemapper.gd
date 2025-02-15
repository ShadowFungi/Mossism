#extends Node
#
#var conf = ConfigFile.new()
#var keycode = InputEventKey.new()
#
#@export var forward : Key = KEY_W
#@export var back : Key = KEY_S
#@export var strafe_left : Key = KEY_A
#@export var strafe_right : Key = KEY_D
#@export var sprint_native : Key = KEY_TAB
#@export var sprint_web : Key = KEY_SHIFT
#@export var crouch_native : Key = KEY_CTRL
#@export var crouch_web : Key = KEY_ALT
#@export var jump : Key = KEY_SPACE
#@export var ui_cancel : Key = KEY_X
#@export var pause_native : Key = KEY_ESCAPE
#@export var pause_web : Key = KEY_TAB
#@export var tool_key : Key = KEY_Q
#@export var interact : Key = KEY_F
#@export var aim_key : Key = KEY_E
#@export var ledge_grab_key : Key = KEY_G
#
#@export var tool_mouse : MouseButton
#@export var aim_mouse : MouseButton
#
#
#func set_default_map():
	#forward = KEY_W
	#back = KEY_S
	#strafe_left = KEY_A
	#strafe_right = KEY_D
	#sprint_native = KEY_TAB
	#sprint_web = KEY_SHIFT
	#crouch_native = KEY_CTRL
	#crouch_web = KEY_ALT
	#jump = KEY_SPACE
	#ui_cancel = KEY_X
	#pause_native = KEY_ESCAPE
	#pause_web = KEY_TAB
	#interact = KEY_F
	#tool_key = KEY_Q
	#aim_key = KEY_E
	#ledge_grab_key = KEY_G
	#
	#tool_mouse = MOUSE_BUTTON_LEFT
	#aim_mouse = MOUSE_BUTTON_RIGHT
#
#func save_map(path: String):
	#conf.set_value("controls", "forward", forward)
	#conf.set_value("controls", "back", back)
	#conf.set_value("controls", "strafe_left", strafe_left)
	#conf.set_value("controls", "strafe_right", strafe_right)
	#conf.set_value("controls", "crouch_native", crouch_native)
	#conf.set_value("controls", "sprint_web", sprint_web)
	#conf.set_value("controls", "crouch_native", crouch_native)
	#conf.set_value("controls", "crouch_web", crouch_web)
	#conf.set_value("controls", "jump", jump)
	#conf.set_value("controls", "ui_cancel", ui_cancel)
	#conf.set_value("controls", "pause_native", pause_native)
	#conf.set_value("controls", "pause_web", pause_web)
	#conf.set_value("controls", "interact", interact)
	#conf.set_value("controls", "tool_key", tool_key)
	#conf.set_value("controls", "aim_key", aim_key)
	#conf.set_value("controls", "ledge_grab_key", ledge_grab_key)
	#
	#conf.set_value("controls", "tool_mouse", tool_mouse)
	#conf.set_value("controls", "aim_mouse", aim_mouse)
	#
	#conf.save(path)
#
#func load_map(map):
	#var err = conf.load(map)
	#if err != OK:
		#set_default_map()
	#else:
		#for control in conf.get_sections():
			#forward = conf.get_value(control, "forward")
			#back = conf.get_value(control, "back")
			#strafe_left = conf.get_value(control, "strafe_left")
			#strafe_right = conf.get_value(control, "strafe_right")
			#sprint_native = conf.get_value(control, "sprint_native")
			#sprint_web = conf.get_value(control, "sprint_web")
			#crouch_native = conf.get_value(control, "crouch_native")
			#crouch_web = conf.get_value(control, "crouch_web")
			#jump = conf.get_value(control, "jump")
			#ui_cancel = conf.get_value(control, "ui_cancel")
			#pause_native = conf.get_value(control, "pause_native")
			#pause_web = conf.get_value(control, "pause_web")
			#interact = conf.get_value(control, "interact")
			#tool_key =  conf.get_value(control, "tool_key")
			#aim_key =  conf.get_value(control, "aim_key")
			#ledge_grab_key =  conf.get_value(control, "ledge_grab_key")
			#
			#tool_mouse =  conf.get_value(control, "tool_mouse")
			#aim_mouse = conf.get_value(control, "aim_mouse")
	#Keyboard.load_new_map()
#
#func import_map(map: String):
	#conf.load(map)
	#load_map(map)
#
#
#func import_map_web(map: String):
	#var split_map = map.split("\n", false)
	##print(String(split_map[0]).to_int())
	##print(Keycodes.keys[String(split_map[1]).to_int()])
	#forward = Keycodes.keys[String(split_map[2]).to_int()]
	#back = Keycodes.keys[String(split_map[3]).to_int()]
	#strafe_left = Keycodes.keys[String(split_map[4]).to_int()]
	#strafe_right = Keycodes.keys[String(split_map[5]).to_int()]
	#sprint_native = Keycodes.keys[String(split_map[5]).to_int()]
	#sprint_web = Keycodes.keys[String(split_map[5]).to_int()]
	#crouch_native = Keycodes.keys[String(split_map[5]).to_int()]
	#crouch_web = Keycodes.keys[String(split_map[5]).to_int()]
	#jump = Keycodes.keys[String(split_map[6]).to_int()]
	#pause_native = Keycodes.keys[String(split_map[7]).to_int()]
	#pause_web =Keycodes.keys[String(split_map[8]).to_int()]
	#interact = Keycodes.keys[String(split_map[9]).to_int()]
	#tool_key = Keycodes.keys[String(split_map[10]).to_int()]
	#aim_key = Keycodes.keys[String(split_map[11]).to_int()]
	#ledge_grab_key = Keycodes.keys[String(split_map[11]).to_int()]
	#
	#tool_mouse = Keycodes.keys[String(split_map[12]).to_int()]
	#aim_mouse = Keycodes.keys[String(split_map[13]).to_int()]
	#Keyboard.load_new_map()
