extends Node


var conf_file = ConfigFile.new()
var keycode = InputEventKey.new()

var mouse_sensitivity: float = 0.5
var joypad_sensitivity: float = 1.0

var controller_count: int = 0

var input_actions_default: Dictionary = {
	"analog_input_axis": {
	},
	"input_names": [
	],
	"keyboard_controls": [
	],
	"gamepad_controls": [
	],
	"mouse_controls": [
	],
}


@export var input_actions: Dictionary = input_actions_default.duplicate(true)

func _ready() -> void:
	load_example_map()


func load_example_map():
	await get_tree().create_timer(0.5, false).timeout
	load_map("res://addons/fungi_input_remapper/example_keymap.cfg")


func save_map(path: String = "user://config/sfir/current_keymap.cfg", controller_id: int = 0):
	conf_file.clear()
	conf_file.set_value("game_info", "game_name", ProjectSettings.get_setting("application/config/name"))
	var action_names: Array = []
	var analog_dict: Dictionary = {}
	var joymap_dict: Dictionary = {}
	var keymap_dict: Dictionary = {}
	var mousemap_dict: Dictionary = {}
	for action_name in input_actions["input_names"]:
		#conf_file.set_value("{id}".format(controller_id, "{id}"), "all_inputs", action_name)
		pass
		action_names.append(action_name)
		if _is_analog_control(action_name):
			pass
			analog_dict[action_name] = input_actions["analog_input_axis"][action_name]
		#if _is_analog_control(action_name):
			#conf_file.set_value("analog", action_name, input_actions["analog_input_axis"][action_name])
		#if _is_gamepad_control(action_name):
			#conf_file.set_value("joymap", action_name, input_actions["gamepad_controls"][input_actions["input_names"].find(action_name)])
		#elif _is_keyboard_control(action_name):
			#conf_file.set_value("keymap", action_name, input_actions["keyboard_controls"][input_actions["input_names"].find(action_name)])
		#else:
			#conf_file.set_value("joymap", action_name, input_actions["gamepad_controls"][input_actions["input_names"].find(action_name)])
			#conf_file.set_value("keymap", action_name, input_actions["keyboard_controls"][input_actions["input_names"].find(action_name)])
		if _is_gamepad_control(action_name):
			joymap_dict[action_name] = input_actions["gamepad_controls"][input_actions["input_names"].find(action_name)]
		elif _is_keyboard_control(action_name):
			keymap_dict[action_name] = input_actions["keyboard_controls"][input_actions["input_names"].find(action_name)]
		elif _is_mouse_control(action_name):
			mousemap_dict[action_name] = input_actions["mouse_controls"][input_actions["input_names"].find(action_name)]
		else:
			joymap_dict[action_name] = input_actions["gamepad_controls"][input_actions["input_names"].find(action_name)]
			keymap_dict[action_name] = input_actions["keyboard_controls"][input_actions["input_names"].find(action_name)]
	conf_file.set_value("{0}".format([controller_id]), "action_names", action_names)
	conf_file.set_value("{0}".format([controller_id]), "analog", analog_dict)
	conf_file.set_value("{0}".format([controller_id]), "joymap", joymap_dict)
	conf_file.set_value("{0}".format([controller_id]), "keymap", keymap_dict)
	conf_file.set_value("{0}".format([controller_id]), "keymap", keymap_dict)
	conf_file.set_value("{0}".format([controller_id]), "mousemap", mousemap_dict)
	
	
	conf_file.save(path)


func load_map(map: String = "user://config/sfir/current_keymap.cfg"):
	var message := "Outdated, or incompaitable config file"
	var err = conf_file.load(map)
	if err != OK:
		return err
	elif "game_info" in conf_file.get_sections():
		if conf_file.get_value("game_info", "game_name") == ProjectSettings.get_setting("application/config/name") or conf_file.get_value("game_info", "game_name") == "SFIR":
			pass
			for device in conf_file.get_sections():
				if device == "game_info":
					continue
				pass
				#print(conf_file.get_value(device, "action_names"))
				var conf_keys := conf_file.get_section_keys(device)
				#print(conf_keys)
				#prints("z")
				if "action_names" in conf_keys:
					#prints("x")
					var inputs: Array = conf_file.get_value(device, "action_names") 
					for action_name in inputs:
						var new_action_name: String
						var error = remove_boolean_prefix(action_name)
						if error != "FAILED":
							new_action_name = remove_boolean_prefix(action_name)
						else:
							new_action_name = action_name
						var joy_button := JOY_BUTTON_INVALID
						var joy_axis := JOY_AXIS_INVALID
						var key_button := KEY_NONE
						var mouse_button := MOUSE_BUTTON_NONE
						var analog_dir: int = 0
						var gamepad: bool = false
						var keyboard: bool = false
						var analog: bool = false
						var mouse: bool = false
						var analog_map: Dictionary
						var joymap: Dictionary
						var keymap: Dictionary
						var mousemap: Dictionary
						if "analog" in conf_keys:
							pass
							analog_map = conf_file.get_value(device, "analog")
							if action_name in conf_file.get_value(device, "analog"):
								pass
								if _is_analog_control(action_name) == true:
									pass
									#print(analog)
									analog = true
									analog_dir = analog_map[action_name]
						if "joymap" in conf_keys:
							pass
							joymap = conf_file.get_value(device, "joymap")
							#for joy_input in joymap:
								#pass
							if action_name in conf_file.get_value(device, "joymap"):
								pass
								if _is_analog_control(action_name) == true:
									pass
									#print(analog)
									analog = true
									analog_dir = analog_map[action_name]
									joy_axis = SFInputKeycodes.joy_axis[joymap[action_name]]
								elif _is_gamepad_control(action_name) == true:
									pass
									gamepad = true
									joy_button = SFInputKeycodes.joy_buttons[joymap[action_name]]
								else:
									joy_button = SFInputKeycodes.joy_buttons[joymap[action_name]]
						if "keymap" in conf_keys:
							pass
							keymap = conf_file.get_value(device, "keymap")
							if action_name in conf_file.get_value(device, "keymap"):
								pass
							#else:
								key_button = SFInputKeycodes.keys[keymap[action_name]]
						if "mousemap" in conf_keys:
							pass
							mousemap = conf_file.get_value(device, "mousemap")
							if action_name in conf_file.get_value(device, "mousemap"):
								pass
							#else:
								mouse_button = SFInputKeycodes.mouse_buttons_as_enums[mousemap[action_name]]
						add_input(new_action_name, "", key_button, joy_button, mouse_button, gamepad, keyboard, analog, mouse, analog_dir, joy_axis)
			#if "all_inputs" in conf_file.get_sections():
				#for action_name in conf_file.get_section_keys("all_inputs"):
					#var new_action_name: String
					#var error = remove_boolean_prefix(action_name)
					#if error != "FAILED":
						#new_action_name = remove_boolean_prefix(action_name)
					#else:
						#new_action_name = action_name
					#var joy_button = JOY_BUTTON_INVALID
					#var joy_axis = JOY_AXIS_INVALID
					#var key_button = KEY_NONE
					#var analog_dir = 0
					#var gamepad = false
					#var keyboard = false
					#var analog = false
					#if "joymap" in conf_file.get_sections():
						#if conf_file.has_section_key("joymap", action_name):
							#if _is_analog_control(action_name) == true:
								#analog = true
								#analog_dir = conf_file.get_value("analog", action_name)
								#joy_axis = SFInputKeycodes.joy_axis[conf_file.get_value("joymap", action_name)]
							#elif _is_gamepad_control(action_name) == true:
								#gamepad = true
								#joy_button = SFInputKeycodes.joy_buttons[conf_file.get_value("joymap", action_name)]
							#else:
								#joy_button = SFInputKeycodes.joy_buttons[conf_file.get_value("joymap", action_name)]
					#if "keymap" in conf_file.get_sections():
						#if conf_file.has_section_key("keymap", action_name):
							#if _is_analog_control(action_name) == true:
								#analog = true
								#analog_dir = conf_file.get_value("analog", action_name)
								#key_button = SFInputKeycodes.keys[conf_file.get_value("keymap", action_name)]
							#elif _is_keyboard_control(action_name) == true:
								#keyboard = true
								#key_button = SFInputKeycodes.keys[conf_file.get_value("keymap", action_name)]
							#else:
								#key_button = SFInputKeycodes.keys[conf_file.get_value("keymap", action_name)]
					#if "analog" in conf_file.get_sections():
						#if conf_file.has_section_key("analog", action_name):
							#analog = true
							#analog_dir = conf_file.get_value("analog", action_name)
					#add_input(new_action_name, "", key_button, joy_button, gamepad, keyboard, analog, analog_dir, joy_axis)
			#else:
				#push_error(message)
				#return message
		else:
			push_error(message)
			return message
	else:
		push_error(message)
		return message


func get_action_input_string(action: String, gamepad: bool = false, keyboard: bool = false, mouse: bool = false, analog: bool = false) -> Array:
	if !_only_one_true([gamepad, keyboard, analog, mouse]):
		return ["FAILED"]
	#if analog:
	#	return ["analog should be replaced with keyboard, and gamepad, run separately"]
		#var new_action = input_actions["keyboard_controls"][input_actions["input_names"].find(action)]
		#if new_action == -1:
			#return "FAILED"
		#else:
			#return SFInputKeycodes.key_names_as_string[new_action]
			
	match true:
		keyboard:
			var new_action = input_actions["keyboard_controls"][input_actions["input_names"].find(action)]
			if new_action == -1:
				return ["FAILED"]
			else:
				return [SFInputKeycodes.key_names_as_string[new_action]]
		gamepad:
			var new_action = input_actions["gamepad_controls"][input_actions["input_names"].find(action)]
			if new_action == -1:
				return ["FAILED"]
			else:
				return [SFInputKeycodes.joy_buttons_as_text[new_action]]
		analog:
			var new_action_joy = input_actions["gamepad_controls"][input_actions["input_names"].find(action)]
			var new_action = input_actions["keyboard_controls"][input_actions["input_names"].find(action)]
			if new_action_joy == -1 or new_action == -1:
				return ["FAILED"]
			else:
				return [
					SFInputKeycodes.key_names_as_string[new_action],
					SFInputKeycodes.joy_buttons_as_text[new_action_joy],
				]
		_:
			#print(action)
			#print(input_actions["gamepad_controls"])
			var new_action_joy = input_actions["gamepad_controls"][input_actions["input_names"].find(action)]
			var new_action = input_actions["keyboard_controls"][input_actions["input_names"].find(action)]
			#prints(new_action, new_action_joy)
			if new_action_joy == -1 or new_action == -1:
				return ["FAILED"]
			else:
				return [
					SFInputKeycodes.key_names_as_string[new_action],
					SFInputKeycodes.joy_buttons_as_text[new_action_joy],
				]
	return ["no value matched"]


func remove_boolean_prefix(action_name: String):
	var reg: RegEx = RegEx.new()
	reg.compile("(?<hyph>(?<=(--)))(?<name>(?=(\\k<hyph>[^-]))\\w+)")
	var res = reg.search(action_name)
	if res:
		return res.get_strings()[res.get_names()["name"]]
	else:
		push_warning("SOMETHING WENT WRONG IN THE FUNCTION \"remove_boolean_prefix()\"\nThis can probably be ignored")
		return "FAILED"


func get_full_action_name(action_name: String, action_name_prefix: String, gamepad_only: bool = false, keyboard_only: bool = false, analog: bool = false):
	var full_action_name: String
	if analog == true or gamepad_only == true or keyboard_only == true:
		if analog == true:
			full_action_name = "analog--" + action_name_prefix + action_name
		if gamepad_only == true:
			full_action_name = "gamepad--" + action_name_prefix + action_name
		if keyboard_only == true:
			full_action_name = "keyboard--" + action_name_prefix + action_name
	else:
		full_action_name = action_name_prefix + action_name
	return full_action_name


func _is_gamepad_control(action_name: String) -> bool:
	var reg: RegEx = RegEx.new()
	reg.compile("(gamepad--)\\w+")
	var res = reg.search(action_name)
	if res:
		return true
	else:
		return false


func _is_keyboard_control(action_name: String) -> bool:
	var reg: RegEx = RegEx.new()
	reg.compile("(keyboard--)\\w+")
	var res = reg.search(action_name)
	if res:
		return true
	else:
		return false


func _is_mouse_control(action_name: String) -> bool:
	var reg: RegEx = RegEx.new()
	reg.compile("(mouse--)\\w+")
	var res = reg.search(action_name)
	if res:
		return true
	else:
		return false


func _is_analog_control(action_name: String) -> bool:
	var reg: RegEx = RegEx.new()
	var err = reg.compile("(analog--)\\w+")
	if err != OK:
		return false
	var res = reg.search(action_name)
	if res == null:
		return false
	if res:
		return true
	else:
		return false


func import_map_web(map: String):
	var split_map = map.split("\n", false)


func _only_one_true(bool_array: Array) -> bool:
	if bool_array.count(true) > 1:
	#if first_bool == true and second_bool == true or first_bool == true and third_bool == true or third_bool == true and second_bool == true:
		push_error("ONLY ONE OF THE FOLLOWING ARGUMENTS SHOULD BE SET TO \"true\":\n \"gamepad_only\", \"keyboard_only\", \"analog\"\n THE OTHERS SHOULD BE SET TO \"false\"!\nI'LL BE BACK... IF YOU DON'T FIX IT!")
		return false
	else:
		return true


func add_input(action_name: String, action_name_prefix: String, keycode := KEY_NONE, joy_button := JOY_BUTTON_INVALID, mouse_button := MOUSE_BUTTON_NONE, gamepad_only: bool = false, keyboard_only: bool = false, analog: bool = false, mouse_only: bool = false, analog_direction: float = 0.0, joy_axis := JOY_AXIS_INVALID, gamepad_index: int = -1) -> int:
	if !_only_one_true([gamepad_only, keyboard_only, analog, mouse_only]):
		return -1
	var full_action_name: String = get_full_action_name(action_name, action_name_prefix, gamepad_only, keyboard_only, analog)
	if InputMap.has_action(full_action_name):
		push_warning("THERE'S ALREADY AN ACTION WITH THE NAME: " + full_action_name + "\nI'LL BE BACK... IF YOU DON'T FIX IT!")
		return -1
	else:
		InputMap.add_action(full_action_name)
	var new_key_action_event: InputEventKey = InputEventKey.new()
	var new_joy_action_event: InputEventJoypadButton = InputEventJoypadButton.new()
	var new_mouse_action_event: InputEventMouseButton = InputEventMouseButton.new()
	if analog == true or gamepad_only == true or keyboard_only == true or mouse_only == true:
		var new_joy_motion_action_event: InputEventJoypadMotion = InputEventJoypadMotion.new()
		if analog == true:
			input_actions["analog_input_axis"][full_action_name] = analog_direction
			new_key_action_event.keycode = keycode
			new_mouse_action_event = new_mouse_action_event.duplicate()
			new_joy_motion_action_event.axis = joy_axis
			new_joy_motion_action_event.axis_value = input_actions["analog_input_axis"].get(full_action_name, 0)
			new_joy_motion_action_event.device = gamepad_index
			new_mouse_action_event.button_index = mouse_button
			InputMap.action_set_deadzone(full_action_name, 0.12)
			InputMap.action_add_event(full_action_name, new_joy_motion_action_event)
			InputMap.action_add_event(full_action_name, new_key_action_event)
			InputMap.action_add_event(full_action_name, new_mouse_action_event)
			input_actions["keyboard_controls"].append(keycode)
			input_actions["gamepad_controls"].append(joy_axis)
			input_actions["mouse_controls"].append(mouse_button)
		if gamepad_only == true:
			new_joy_action_event.button_index = joy_button
			new_joy_action_event.device = gamepad_index
			InputMap.action_add_event(full_action_name, new_joy_action_event)
			input_actions["keyboard_controls"].append(keycode)
			input_actions["gamepad_controls"].append(joy_button)
		if keyboard_only == true:
			new_key_action_event = new_key_action_event.duplicate()
			new_key_action_event.keycode = keycode
			InputMap.action_add_event(full_action_name, new_key_action_event)
			input_actions["keyboard_controls"].append(keycode)
			input_actions["gamepad_controls"].append(joy_button)
		if mouse_only == true:
			new_mouse_action_event = new_mouse_action_event.duplicate()
			new_mouse_action_event.button_index = mouse_button
			InputMap.action_add_event(full_action_name, new_mouse_action_event)
			input_actions["mouse_controls"].append(mouse_button)
		input_actions["input_names"].append(full_action_name)
		#print(full_action_name, ": ", InputMap.action_get_events(full_action_name), "\n")
		return input_actions["input_names"].find(full_action_name)
	else:
		input_actions["input_names"].append(full_action_name)
		input_actions["keyboard_controls"].append(keycode)
		input_actions["gamepad_controls"].append(joy_button)
		input_actions["mouse_controls"].append(mouse_button)
		new_key_action_event = new_key_action_event.duplicate()
		new_joy_action_event = new_joy_action_event.duplicate()
		new_mouse_action_event = new_mouse_action_event.duplicate()
		new_key_action_event.keycode = keycode
		new_joy_action_event.button_index = joy_button
		new_joy_action_event.device = gamepad_index
		new_mouse_action_event.button_index = mouse_button
		InputMap.action_add_event(full_action_name, new_key_action_event)
		InputMap.action_add_event(full_action_name, new_joy_action_event)
		InputMap.action_add_event(full_action_name, new_mouse_action_event)
		prints(full_action_name, InputMap.action_get_events(full_action_name))
		return input_actions["input_names"].find(full_action_name)


func modify_input(action_name: String, action_name_prefix: String, keycode := KEY_NONE, joy_button := JOY_BUTTON_INVALID, gamepad_only: bool = false, keyboard_only: bool = false, mouse_only: bool = false, analog: bool = false, analog_direction: float = 0.0, joy_axis := JOY_AXIS_INVALID, gamepad_index: int = -1) -> int:
	if !_only_one_true([gamepad_only, keyboard_only, analog, mouse_only]):
		return -1
	var full_action_name: String = get_full_action_name(action_name, action_name_prefix, gamepad_only, keyboard_only, analog)
	if input_actions["input_names"].has(full_action_name) == false:
		push_warning("INPUT CANNOT BE MODIFIED AS IT DOES NOT EXIST!\n I'LL BE BACK... IF YOU DON'T FIX IT!")
		return -1
	var new_key_action_event: InputEventKey = InputEventKey.new()
	var new_joy_action_event: InputEventJoypadButton = InputEventJoypadButton.new()
	if analog == true or gamepad_only == true or keyboard_only == true:
		if analog == true:
			var new_joy_motion_action_event: InputEventJoypadMotion = InputEventJoypadMotion.new()
			input_actions["analog_input_axis"][full_action_name] = analog_direction
			new_key_action_event.keycode = keycode
			new_joy_motion_action_event.axis = joy_axis
			new_joy_motion_action_event.axis_value = input_actions["analog_input_axis"].get(full_action_name, 0)
			new_joy_motion_action_event.device = gamepad_index
		if gamepad_only == true:
			new_joy_action_event.button_index = joy_button
			new_joy_action_event.device = gamepad_index
		if keyboard_only == true:
			new_key_action_event.keycode = keycode
		input_actions["input_names"].append(full_action_name)
		input_actions["keyboard_controls"].append(keycode)
		input_actions["gamepad_controls"].append(joy_button)
		if InputMap.has_action(full_action_name):
			InputMap.action_erase_events(full_action_name)
		else:
			push_warning("THERE'S NOT AN ACTION WITH THE NAME: " + full_action_name + "\nI'LL BE BACK... IF YOU DON'T FIX IT!")
			return -1
		InputMap.action_add_event(full_action_name, new_key_action_event)
		InputMap.action_add_event(full_action_name, new_joy_action_event)
		return input_actions["input_names"].find(full_action_name)
	else:
		new_key_action_event.keycode = keycode
		new_joy_action_event.button_index = joy_button
		new_joy_action_event.device = -1
		if InputMap.has_action(full_action_name):
			return -1
		else:
			InputMap.add_action(full_action_name)
		InputMap.action_add_event(full_action_name, new_key_action_event)
		InputMap.action_add_event(full_action_name, new_joy_action_event)
		return input_actions["input_names"].find(full_action_name)


func remove_input(action_name: String, action_name_prefix: String = "", gamepad_only: bool = false, keyboard_only: bool = false, mouse_only: bool = false, analog: bool = false) -> int:
	if !_only_one_true([gamepad_only, keyboard_only, analog, mouse_only]):
		push_error("ONLY ONE OF THE FOLLOWING ARGUMENTS SHOULD BE SET TO \"true\": \"gamepad_only\", \"keyboard_only\", \"analog\" THE OTHERS SHOULD BE SET TO \"false\"!\nI'LL BE BACK... IF YOU DON'T FIX IT!")
		return -1
	if action_name == "":
		push_error("DON'T LEAVE THE ACTION_NAME EMPTY!\nI'LL BE BACK... IF YOU DON'T FIX IT!")
		return -1
	var full_action_name: String = get_full_action_name(action_name, action_name_prefix, gamepad_only, keyboard_only, analog)
	if input_actions["input_names"].has(full_action_name) == false:
		push_warning("ACTION_NAME NOT FOUND IN ACTIONS DICTIONARY!\nADD IT WITH THE ADD_ACTION FUNCTION\nI'LL BE BACK... IF YOU DON'T FIX IT!")
		return -1
	var ret: int = input_actions["input_names"].find(full_action_name)
	input_actions["input_names"].erase(full_action_name)
	if analog == true:
		input_actions["analog_input_axis"].erase(full_action_name)
		return ret
	if gamepad_only == true:
		input_actions["gamepad_controls"].remove_at(ret)
		return ret
	if keyboard_only == true:
		input_actions["keyboard_controls"].remove_at(ret)
		return ret
	if mouse_only == true:
		input_actions["mouse_controls"].remove_at(ret)
	return ret


func wipe_all_actions():
	input_actions["analog_input_axis"].clear()
	input_actions["input_names"].clear()
	input_actions["keyboard_controls"].clear()
	input_actions["gamepad_controls"].clear()
	input_actions["mouse_controls"].clear()
