@tool
class_name AlertTrigger
extends Node

const INVERSE_SCALE: float = 0.03125

enum {
	WORLD_LAYER = (1 << 0),
	ACTOR_LAYER = (1 << 1),
	TRIGGER_LAYER = (1 << 2)
}

func _ready() -> void:
	print('alert')

func activate_targets(activator: Node, target: String) -> void:
	var targets: Array[Node] = get_tree().get_nodes_in_group(target)
	for target_node in targets:
		var function: String
		if 'targetfunc' in activator:
			function = activator.targetfunc
		if function.is_empty():
			function = "use"
		if target_node.has_method(function):
			#print('activated')
			target_node.call(function)

func set_targetname(node: Node, targetname: String) -> void:
	prints(node.name, targetname)
	if node != null and targetname.is_empty() == false:
		node.add_to_group(targetname)

static func id_vec_to_godot_vec(vec: Variant)->Vector3:
	var org: Vector3 = Vector3.ZERO
	if vec is Vector3:
		org = vec
	elif vec is String:
		var arr: PackedFloat64Array = (vec as String).split_floats(" ")
		for i in max(arr.size(), 3):
			org[i] = arr[i]
	return Vector3(org.x, org.y, org.z)

static func toggle_bool(boolean: bool) -> bool:
	if boolean == true:
		return false
	else:
		return true
