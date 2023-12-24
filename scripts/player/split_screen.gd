extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect joy_connection_changed signal to _on_joy_connection_changed function.
	Input.joy_connection_changed.connect(_on_joy_connection_changed.bind())


# Called whenever a input device is added or removed.
func _on_joy_connection_changed(device_id, connected):
	# Checks if a input device has been connected.
	if connected:
		# Print newly connected input device name.
		#print("connected " + Input.get_joy_name(device_id))
		add_player(null, null, device_id)
	# Checks if a input has been removed.
	elif connected == false:
		print(device_id)

# Called to add a new player instance.
func add_player(player_instance, world_instance, id):
	Keyboard.total_players += 1
	#print(id)
	# Sets the name of the new player instance
	player_instance.set_name("SubViewport_" + String(id))
	#print("set_name attempted")
	
	# Set instance_name variable to name of player_instance
	var instance_name = player_instance.get_name()
	#print(instance_name)
	
	# Add basic information to autoload
	Keyboard.player_instances.append(instance_name)
	get_tree().root.get_node("SplitScreen/SubViewportContainer").add_child(player_instance)
	get_tree().root.get_node("SplitScreen/SubViewportContainer/%s/Viewport" % String(instance_name))
	get_tree().root.get_node("SplitScreen/SubViewportContainer/%s/Viewport/Character" % String(instance_name)).id = id
	Keyboard.player_nodes.append(get_tree().root.get_node("SplitScreen/SubViewportContainer/%s/Viewport/Character" % String(instance_name)))
	
	Keyboard.player_id[Keyboard.total_players]
	# Run function to add key/controller bindings, if the id is not present.
	if Keyboard.ids["player%s" % Keyboard.total_players][String(id)] != null:
		Keyboard.ids["player%s" % Keyboard.total_players][String(id)] = "Node/ViewContainer/%s/Viewport/Character" % String(instance_name)
		bind_inputs(id)

func bind_inputs(id):
	Keyboard.input_map.append({
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
	
