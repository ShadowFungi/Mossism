extends Node

var total_players : int = 0
var player_instances : Array
var ids : Dictionary = {
	"player":{}
}
var num : int

# Setup input bindings for player 0
func _ready() -> void:
	# Input used to move player 0 forward
	var move_forward_action : String = "player-{n}_forward".format({"n":0})
	var move_forward_action_event : InputEventKey
	move_forward_action_event = InputEventKey.new()
	move_forward_action_event.keycode = KEY_W
	InputMap.add_action(move_forward_action)
	InputMap.action_add_event(move_forward_action, move_forward_action_event)
	# Input used to move player 0 backwards
	var move_back_action : String = "player-{n}_back".format({"n":0})
	var move_back_action_event : InputEventKey
	move_back_action_event = InputEventKey.new()
	move_back_action_event.keycode = KEY_S
	InputMap.add_action(move_back_action)
	InputMap.action_add_event(move_back_action, move_back_action_event)
	# Input used to move player 0 left
	var strafe_left_action : String = "player-{n}_strafe_left".format({"n":0})
	var strafe_left_action_event : InputEventKey
	strafe_left_action_event = InputEventKey.new()
	strafe_left_action_event.keycode = KEY_A
	InputMap.add_action(strafe_left_action)
	InputMap.action_add_event(strafe_left_action, strafe_left_action_event)
	# Input used to move player 0 right
	var strafe_right_action : String = "player-{n}_strafe_right".format({"n":0})
	var strafe_right_action_event : InputEventKey
	strafe_right_action_event = InputEventKey.new()
	strafe_right_action_event.keycode = KEY_D
	InputMap.add_action(strafe_right_action)
	InputMap.action_add_event(strafe_right_action, strafe_right_action_event)
	# Input used to make player 0 jump
	var jump_action : String = "player-{n}_jump".format({"n":0})
	var jump_action_event : InputEventKey
	jump_action_event = InputEventKey.new()
	jump_action_event.keycode = KEY_SPACE
	InputMap.add_action(jump_action)
	InputMap.action_add_event(jump_action, jump_action_event)
	# Input used in the pause menu to cancel an action for player 0
	var ui_cancel_action : String = "player-{n}_ui_cancel".format({"n":0})
	var ui_cancel_action_event : InputEventKey
	ui_cancel_action_event = InputEventKey.new()
	ui_cancel_action_event.keycode = KEY_Q
	InputMap.add_action(ui_cancel_action)
	InputMap.action_add_event(ui_cancel_action, ui_cancel_action_event)
	# Input used to bring up the pause menu for player 0
	var pause_action : String = "player-{n}_pause".format({"n":0})
	var pause_action_event : InputEventKey
	pause_action_event = InputEventKey.new()
	pause_action_event.keycode = KEY_ESCAPE
	InputMap.add_action(pause_action)
	InputMap.action_add_event(pause_action, pause_action_event)
	# Input used to make player 0 use the selected tool/weapon
	var tool_action : String = "player-{n}_tool".format({"n":0})
	var tool_action_event : InputEventMouseButton
	tool_action_event = InputEventMouseButton.new()
	tool_action_event.button_index = MOUSE_BUTTON_LEFT
	InputMap.add_action(tool_action)
	InputMap.action_add_event(tool_action, tool_action_event)
	# Input used to make player 0 interact with external objects, items, or entities.
	var interact_action : String = "player-{n}_interact".format({"n":0})
	var interact_action_event : InputEventKey
	interact_action_event = InputEventKey.new()
	interact_action_event.keycode = KEY_E
	InputMap.add_action(interact_action)
	InputMap.action_add_event(interact_action, interact_action_event)
	# Input used to make player 0 aim down sight
	var aim_action : String = "player-{n}_aim".format({"n":0})
	var aim_action_event : InputEventMouseButton
	aim_action_event = InputEventMouseButton.new()
	aim_action_event.button_index = MOUSE_BUTTON_RIGHT
	InputMap.add_action(aim_action)
	InputMap.action_add_event(aim_action, aim_action_event)

