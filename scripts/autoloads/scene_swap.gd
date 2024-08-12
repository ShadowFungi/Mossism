extends Node


@onready var packed_scene_queue : Dictionary
@onready var scene_file_queue : Dictionary
@onready var previous_scene : Node
@onready var packer = PackedScene.new()


func add_scene_to_queue(scene, scene_name: String, packed_queue: Dictionary = packed_scene_queue, file_queue: Dictionary = scene_file_queue):
	if scene is String and file_queue.has(scene_name) == false:
		file_queue[scene_name] = scene
		ResourceLoader.load_threaded_request(file_queue[scene_name])
		print('scene added to file queue')
		return
	if scene is PackedScene and packed_queue.has(scene_name) == false:
		packed_queue[scene_name] = scene
		print('scene added to PackedScene queue')
		return
	else:
		print('scene already in both queues')
		return

func add_queued_scene_to_tree(scene_name: String, root_node: Node, packed_queue: Dictionary = packed_scene_queue, file_queue: Dictionary = scene_file_queue):
	if file_queue.has(scene_name):
		var scene = ResourceLoader.load_threaded_get(file_queue[scene_name])
		root_node.add_child(scene)
	elif packed_queue.has(scene_name):
		root_node.add_child(packed_queue[scene_name])
	else:
		print('scene not in either queue')
		return

func replace_node_with_queued_scene(scene_name: String, free_children: bool, replace_node: Node, store_replaced_node: bool = false, packed_queue: Dictionary = packed_scene_queue, file_queue: Dictionary = scene_file_queue):
	if store_replaced_node == true:
		var _result = packer.pack(replace_node)
	if file_queue.has(scene_name):
		if free_children == true:
			for child in replace_node.get_children():
				child.queue_free()
		var scene = ResourceLoader.load_threaded_get(file_queue[scene_name]).instantiate()
		replace_node.replace_by(scene)
	elif packed_queue.has(scene_name):
		if free_children == true:
			for child in replace_node.get_children():
				child.queue_free()
		var instance = packed_queue[scene_name].instantiate()
		replace_node.replace_by(instance)
	else:
		print('scene not in either queue')
		return

func restore_previous_scene(replace_node: Node, _store_replaced_node: bool):
	for child in replace_node.get_children():
		child.queue_free()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	previous_scene = packer.instantiate()
	replace_node.replace_by(previous_scene)
