extends Node


onready var viewport1 = $ViewContainer/ViewportContainer/Viewport
onready var camera1 = $ViewContainer/ViewportContainer/Viewport/Player/pivot/PlayerCamera
onready var world
onready var player_scene = preload("res://Scenes/Entities/Player/PlayerViewport.tscn")
onready var player

var input_map : Array = []


func _ready():
	player = player_scene.instance()
	world = viewport1.get_world()
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed") 

func _on_joy_connection_changed(device_id, connected):
	if connected:
		print("connected " + Input.get_joy_name(device_id))
		print(Input.get_connected_joypads())
		add_player(player, world, device_id)
	elif connected == false:
		print(device_id)
		drop_player(device_id)
		print(Input.get_connected_joypads())

func add_player(player_instance, world_instance, id):
	print(Controller.ids)
	player_instance.set_name("ViewportContainer_" + String(id))
	print("passed set_name")
	
	var instance_name = player_instance.name
	print(player_instance.name)
	
	Controller.total_controllers.append(instance_name)
	get_tree().root.get_node("Node/ViewContainer").add_child(player_instance)
	get_tree().root.get_node("Node/ViewContainer/%s/Viewport" % String(instance_name)).set_world(world_instance)
	get_tree().root.get_node("Node/ViewContainer/%s/Viewport/Player" % String(instance_name)).id = id
	Controller.ids["players"][String(id)] = "Node/ViewContainer/%s/Viewport/Player" % String(instance_name)
	
	print(Controller.ids)
	print(player_instance.name)
	
	input_map.append({
		"player-{n}_forward".format({"n":id}): Vector3.FORWARD,
		"player-{n}_back".format({"n":id}): Vector3.BACK,
		"player-{n}_strafe_left".format({"n":id}): Vector3.LEFT,
		"player-{n}_strafe_right".format({"n":id}): Vector3.RIGHT,
		"player-{n}_look_up".format({"n":id}): Vector3.FORWARD,
		"player-{n}_look_down".format({"n":id}): Vector3.BACK,
		"player-{n}_look_left".format({"n":id}): Vector3.LEFT,
		"player-{n}_look_right".format({"n":id}): Vector3.RIGHT,
		"player-{n}_jump".format({"n":id}): Vector3.ZERO,
		"player-{n}_ui_cancel".format({"n":id}): Vector3.ZERO,
		"player-{n}_pause".format({"n":id}): Vector3.ZERO,
		"player-{n}_shoot".format({"n":id}): Vector3.ZERO,
		"player-{n}_interact".format({"n":id}): Vector3.ZERO,
	})
	
	var strafe_right_action : String
	var strafe_right_action_event : InputEventJoypadMotion
	
	strafe_right_action = "player-{n}_strafe_right".format({"n":id})
	InputMap.add_action(strafe_right_action)
	
	strafe_right_action_event = InputEventJoypadMotion.new()
	
	strafe_right_action_event.set_device(id)
	strafe_right_action_event.axis = JOY_AXIS_0
	strafe_right_action_event.set_axis_value(1.0)
	
	InputMap.action_add_event(strafe_right_action, strafe_right_action_event)
	
	var strafe_left_action : String
	var strafe_left_action_event : InputEventJoypadMotion
	
	strafe_left_action = "player-{n}_strafe_left".format({"n":id})
	InputMap.add_action(strafe_left_action)
	
	strafe_left_action_event = InputEventJoypadMotion.new()
	
	strafe_left_action_event.set_device(id)
	strafe_left_action_event.axis = JOY_AXIS_0
	strafe_left_action_event.set_axis_value(-1.0)
	
	InputMap.action_add_event(strafe_left_action, strafe_left_action_event)
	
	var forward_action : String
	var forward_action_event : InputEventJoypadMotion
	
	forward_action = "player-{n}_forward".format({"n":id})
	InputMap.add_action(forward_action)
	
	forward_action_event = InputEventJoypadMotion.new()
	
	forward_action_event.set_device(id)
	forward_action_event.axis = JOY_AXIS_1
	forward_action_event.set_axis_value(-1.0)
	
	InputMap.action_add_event(forward_action, forward_action_event)
	
	var back_action : String
	var back_action_event : InputEventJoypadMotion
	
	back_action = "player-{n}_back".format({"n":id})
	InputMap.add_action(back_action)
	
	back_action_event = InputEventJoypadMotion.new()
	
	back_action_event.set_device(id)
	back_action_event.axis = JOY_AXIS_1
	back_action_event.set_axis_value(1.0)
	
	InputMap.action_add_event(back_action, back_action_event)
	
	var look_up_action : String
	var look_up_action_event : InputEventJoypadMotion
	
	look_up_action = "player-{n}_look_up".format({"n":id})
	InputMap.add_action(look_up_action)
	
	look_up_action_event = InputEventJoypadMotion.new()
	
	look_up_action_event.set_device(id)
	look_up_action_event.axis = JOY_AXIS_3
	look_up_action_event.set_axis_value(-1.0)
	
	InputMap.action_add_event(look_up_action, look_up_action_event)
	
	var look_down_action : String
	var look_down_action_event : InputEventJoypadMotion
	
	look_down_action = "player-{n}_look_down".format({"n":id})
	InputMap.add_action(look_down_action)
	
	look_down_action_event = InputEventJoypadMotion.new()
	
	look_down_action_event.set_device(id)
	look_down_action_event.axis = JOY_AXIS_3
	look_down_action_event.set_axis_value(1.0)
	
	InputMap.action_add_event(look_down_action, look_down_action_event)
	
	var look_left_action : String
	var look_left_action_event : InputEventJoypadMotion
	
	look_left_action = "player-{n}_look_left".format({"n":id})
	InputMap.add_action(look_left_action)
	
	look_left_action_event = InputEventJoypadMotion.new()
	
	look_left_action_event.set_device(id)
	look_left_action_event.axis = JOY_AXIS_2
	look_left_action_event.set_axis_value(-1.0)
	
	InputMap.action_add_event(look_left_action, look_left_action_event)
	
	var look_right_action : String
	var look_right_action_event : InputEventJoypadMotion
	
	look_right_action = "player-{n}_look_right".format({"n":id})
	InputMap.add_action(look_right_action)
	
	look_right_action_event = InputEventJoypadMotion.new()
	
	look_right_action_event.set_device(id)
	look_right_action_event.axis = JOY_AXIS_2
	look_right_action_event.set_axis_value(1.0)
	
	InputMap.action_add_event(look_right_action, look_right_action_event)
	
	var jump_action : String
	var jump_action_event : InputEventJoypadButton
	
	jump_action = "player-{n}_jump".format({"n":id})
	InputMap.add_action(jump_action)
	
	jump_action_event = InputEventJoypadButton.new()
	
	jump_action_event.set_device(id)
	jump_action_event.set_button_index(JOY_BUTTON_8)
	
	InputMap.action_add_event(jump_action, jump_action_event)
	
	var interact_action : String
	var interact_action_event : InputEventJoypadButton
	
	interact_action = "player-{n}_interact".format({"n":id})
	InputMap.add_action(interact_action)
	
	interact_action_event = InputEventJoypadButton.new()
	
	interact_action_event.set_device(id)
	interact_action_event.set_button_index(JOY_BUTTON_0)
	
	InputMap.action_add_event(interact_action, interact_action_event)
	
	var ui_cancel_action : String
	var ui_cancel_action_event : InputEventJoypadButton
	
	ui_cancel_action = "player-{n}_ui_cancel".format({"n":id})
	InputMap.add_action(ui_cancel_action)
	
	ui_cancel_action_event = InputEventJoypadButton.new()
	
	ui_cancel_action_event.set_device(id)
	ui_cancel_action_event.set_button_index(JOY_BUTTON_1)
	
	InputMap.action_add_event(ui_cancel_action, ui_cancel_action_event)
	
	var pause_action : String
	var pause_action_event : InputEventJoypadButton
	
	pause_action = "player-{n}_pause".format({"n":id})
	InputMap.add_action(pause_action)
	
	pause_action_event = InputEventJoypadButton.new()
	
	pause_action_event.set_device(id)
	pause_action_event.set_button_index(JOY_BUTTON_11)
	
	InputMap.action_add_event(pause_action, pause_action_event)
	
	var shoot_action : String
	var shoot_action_event : InputEventJoypadButton
	
	shoot_action = "player-{n}_shoot".format({"n":id})
	InputMap.add_action(shoot_action)
	
	shoot_action_event = InputEventJoypadButton.new()
	
	shoot_action_event.set_device(id)
	shoot_action_event.set_button_index(JOY_BUTTON_7)
	
	InputMap.action_add_event(shoot_action, shoot_action_event)
	


func drop_player(id) -> void :
	print(id)
	if id != 0:
		if String(id) in String(Controller.ids["players"]):
			print(String(Controller.ids["players"][String(id)]))
			get_tree().root.get_node(Controller.ids["players"][String(id)]).get_parent().get_parent().queue_free()
			Controller.total_players -= 1
			return
		else:
			return



