extends Node

var total_players : int = 1
var player_instances : Array
var player_id : Array
var ids : Dictionary = {
	"player1" : 1
}
var num : int
var player_nodes : Array = [
	"/root/SplitScreen/GridContainer/SubViewportContainer/SubViewport/Player"
]

# Setup input bindings for player 1
func _ready() -> void:
	InputRemapper.set_default_map()
	
	# Input used to move player 1 forward
	var move_forward_action : String = "player-{n}_forward".format({"n":1})
	var move_forward_action_event : InputEventKey
	move_forward_action_event = InputEventKey.new()
	move_forward_action_event.keycode = InputRemapper.forward
	InputMap.add_action(move_forward_action)
	InputMap.action_add_event(move_forward_action, move_forward_action_event)
	
	# Input used to move player 1 backwards
	var move_back_action : String = "player-{n}_back".format({"n":1})
	var move_back_action_event : InputEventKey
	move_back_action_event = InputEventKey.new()
	move_back_action_event.keycode = InputRemapper.back
	InputMap.add_action(move_back_action)
	InputMap.action_add_event(move_back_action, move_back_action_event)
	
	# Input used to move player 1 left
	var strafe_left_action : String = "player-{n}_strafe_left".format({"n":1})
	var strafe_left_action_event : InputEventKey
	strafe_left_action_event = InputEventKey.new()
	strafe_left_action_event.keycode = InputRemapper.strafe_left
	InputMap.add_action(strafe_left_action)
	InputMap.action_add_event(strafe_left_action, strafe_left_action_event)
	
	# Input used to move player 1 right
	var strafe_right_action : String = "player-{n}_strafe_right".format({"n":1})
	var strafe_right_action_event : InputEventKey
	strafe_right_action_event = InputEventKey.new()
	strafe_right_action_event.keycode = InputRemapper.strafe_right
	InputMap.add_action(strafe_right_action)
	InputMap.action_add_event(strafe_right_action, strafe_right_action_event)
	
	# Input used to make player 1 jump
	var jump_action : String = "player-{n}_jump".format({"n":1})
	var jump_action_event : InputEventKey
	jump_action_event = InputEventKey.new()
	jump_action_event.keycode = InputRemapper.jump
	InputMap.add_action(jump_action)
	InputMap.action_add_event(jump_action, jump_action_event)
	
	# Input used in the pause menu to cancel an action for player 1
	var ui_cancel_action : String = "player-{n}_ui_cancel".format({"n":1})
	var ui_cancel_action_event : InputEventKey
	ui_cancel_action_event = InputEventKey.new()
	ui_cancel_action_event.keycode = InputRemapper.ui_cancel
	InputMap.add_action(ui_cancel_action)
	InputMap.action_add_event(ui_cancel_action, ui_cancel_action_event)
	
	# Input used to bring up the pause menu for player 1
	var pause_action : String = "player-{n}_pause".format({"n":1})
	var pause_action_event : InputEventKey
	pause_action_event = InputEventKey.new()
	if OS.has_feature('web'):
		pause_action_event.keycode = InputRemapper.pause_web
	else:
		pause_action_event.keycode = InputRemapper.pause_native
	InputMap.add_action(pause_action)
	InputMap.action_add_event(pause_action, pause_action_event)
	
	# Input used to make player 1 use the selected tool/weapon
	var tool_mouse_action : String = "player-{n}_tool_mouse".format({"n":1})
	var tool_mouse_action_event : InputEventMouseButton
	tool_mouse_action_event = InputEventMouseButton.new()
	tool_mouse_action_event.button_index = InputRemapper.tool_mouse
	InputMap.add_action(tool_mouse_action)
	InputMap.action_add_event(tool_mouse_action, tool_mouse_action_event)
	var tool_key_action : String = "player-{n}_tool_key".format({"n":1})
	var tool_key_action_event : InputEventKey
	tool_key_action_event = InputEventKey.new()
	tool_key_action_event.keycode = InputRemapper.tool_key
	InputMap.add_action(tool_key_action)
	InputMap.action_add_event(tool_key_action, tool_key_action_event)
	
	var sprint_action : String = "player-{n}_sprint".format({"n":1})
	var sprint_action_event : InputEventKey
	sprint_action_event = InputEventKey.new()
	sprint_action_event.keycode = InputRemapper.sprint
	InputMap.add_action(sprint_action)
	InputMap.action_add_event(sprint_action, sprint_action_event)
	
	var crouch_action : String = "player-{n}_crouch".format({"n":1})
	var crouch_action_event : InputEventKey
	crouch_action_event = InputEventKey.new()
	crouch_action_event.keycode = InputRemapper.crouch
	InputMap.add_action(crouch_action)
	InputMap.action_add_event(crouch_action, crouch_action_event)
	
	# Input used to make player 1 interact with external objects, items, or entities.
	var interact_action : String = "player-{n}_interact".format({"n":1})
	var interact_action_event : InputEventKey
	interact_action_event = InputEventKey.new()
	interact_action_event.keycode = InputRemapper.interact
	InputMap.add_action(interact_action)
	InputMap.action_add_event(interact_action, interact_action_event)
	
	# Input used to make player 1 aim down sight
	var aim_action : String = "player-{n}_aim".format({"n":1})
	var aim_action_event : InputEventMouseButton
	aim_action_event = InputEventMouseButton.new()
	aim_action_event.button_index = MOUSE_BUTTON_RIGHT
	InputMap.add_action(aim_action)
	InputMap.action_add_event(aim_action, aim_action_event)


func load_new_map():
	# Input used to move player 1 forward
	var move_forward_action : String = "player-{n}_forward".format({"n":1})
	var move_forward_action_event : InputEventKey
	move_forward_action_event = InputEventKey.new()
	move_forward_action_event.keycode = InputRemapper.forward
	InputMap.action_erase_events(move_forward_action)
	InputMap.action_add_event(move_forward_action, move_forward_action_event)
	# Input used to move player 1 backwards
	var move_back_action : String = "player-{n}_back".format({"n":1})
	var move_back_action_event : InputEventKey
	move_back_action_event = InputEventKey.new()
	move_back_action_event.keycode = InputRemapper.back
	InputMap.action_erase_events(move_back_action)
	InputMap.action_add_event(move_back_action, move_back_action_event)
	# Input used to move player 1 left
	var strafe_left_action : String = "player-{n}_strafe_left".format({"n":1})
	var strafe_left_action_event : InputEventKey
	strafe_left_action_event = InputEventKey.new()
	strafe_left_action_event.keycode = InputRemapper.strafe_left
	InputMap.action_erase_events(strafe_left_action)
	InputMap.action_add_event(strafe_left_action, strafe_left_action_event)
	# Input used to move player 1 right
	var strafe_right_action : String = "player-{n}_strafe_right".format({"n":1})
	var strafe_right_action_event : InputEventKey
	strafe_right_action_event = InputEventKey.new()
	strafe_right_action_event.keycode = InputRemapper.strafe_right
	InputMap.action_erase_events(strafe_right_action)
	InputMap.action_add_event(strafe_right_action, strafe_right_action_event)
	# Input used to make player 1 jump
	var jump_action : String = "player-{n}_jump".format({"n":1})
	var jump_action_event : InputEventKey
	jump_action_event = InputEventKey.new()
	jump_action_event.keycode = InputRemapper.jump
	InputMap.action_erase_events(jump_action)
	InputMap.action_add_event(jump_action, jump_action_event)
	# Input used in the pause menu to cancel an action for player 1
	var ui_cancel_action : String = "player-{n}_ui_cancel".format({"n":1})
	var ui_cancel_action_event : InputEventKey
	ui_cancel_action_event = InputEventKey.new()
	ui_cancel_action_event.keycode = InputRemapper.ui_cancel
	InputMap.action_erase_events(ui_cancel_action)
	InputMap.action_add_event(ui_cancel_action, ui_cancel_action_event)
	# Input used to bring up the pause menu for player 1
	var pause_action : String = "player-{n}_pause".format({"n":1})
	var pause_action_event : InputEventKey
	pause_action_event = InputEventKey.new()
	if OS.get_name() == "HTML5":
		pause_action_event.keycode = InputRemapper.pause_web
	else:
		pause_action_event.keycode = InputRemapper.pause_native
	InputMap.action_erase_events(pause_action)
	InputMap.action_add_event(pause_action, pause_action_event)
	# Input used to make player 1 use the selected tool/weapon
	var tool_mouse_action : String = "player-{n}_tool_mouse".format({"n":1})
	var tool_mouse_action_event : InputEventMouseButton
	tool_mouse_action_event = InputEventMouseButton.new()
	tool_mouse_action_event.button_index = InputRemapper.tool_mouse
	InputMap.action_erase_events(tool_mouse_action)
	InputMap.action_add_event(tool_mouse_action, tool_mouse_action_event)
	var tool_key_action : String = "player-{n}_tool_key".format({"n":1})
	var tool_key_action_event : InputEventKey
	tool_key_action_event = InputEventKey.new()
	tool_key_action_event.keycode = InputRemapper.tool_key
	InputMap.action_erase_events(tool_key_action)
	InputMap.action_add_event(tool_key_action, tool_key_action_event)
	# Input used to make player 1 interact with external objects, items, or entities.
	var interact_action : String = "player-{n}_interact".format({"n":1})
	var interact_action_event : InputEventKey
	interact_action_event = InputEventKey.new()
	interact_action_event.keycode = InputRemapper.interact
	InputMap.action_erase_events(interact_action)
	InputMap.action_add_event(interact_action, interact_action_event)
	# Input used to make player 1 aim down sight
	var aim_action : String = "player-{n}_aim".format({"n":1})
	var aim_action_event : InputEventMouseButton
	aim_action_event = InputEventMouseButton.new()
	aim_action_event.button_index = InputRemapper.aim_mouse
	InputMap.action_erase_events(aim_action)
	InputMap.action_add_event(aim_action, aim_action_event)
