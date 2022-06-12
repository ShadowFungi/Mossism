extends Node


onready var viewport1 = $ViewContainer/ViewportContainer/Viewport
onready var camera1 = $ViewContainer/ViewportContainer/Viewport/Player/pivot/PlayerCamera
onready var world
onready var player_scene = preload("res://Scenes/Entities/Player/PlayerViewport.tscn")
onready var player


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

func drop_player(id) -> void :
	print(id)
	if id != 0:
		if String(id) in String(Controller.ids["players"]):
			print(String(Controller.ids["players"][String(id)]))
			get_tree().root.get_node(Controller.ids["players"][String(id)]).get_parent().get_parent().queue_free()
			return
		else:
			return



