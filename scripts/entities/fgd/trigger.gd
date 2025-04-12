@tool
class_name TriggerArea3D
extends Area3D


@export var func_godot_properties: Dictionary

@export var target: String = ""
@export var targetfunc: String = ""
@export var targetname: String = ""

enum TriggerStates {
	READY,
	USED
}
var trigger_state: TriggerStates = TriggerStates.READY
var timeout: float = 0.0
var last_activator: Node = null

signal trigger()

@export var toggle_enter: bool = false
@export var toggle_exit: bool = false

func _func_godot_apply_properties(props: Dictionary) -> void:
	if 'collision_mask' in props:
		for dimension in 3:
			if props['collision_mask'][dimension] > 0 and props['collision_mask'][dimension] < 33:
				print(props['collision_mask'][dimension])
				set_collision_mask_value(props['collision_mask'][dimension], true)
	
	if 'collision_layers' in props:
		for dimension in 3:
			if props['collision_layers'][dimension] > int(0) and props['collision_layers'][dimension] < int(33):
				set_collision_layer_value(props['collision_layers'][dimension], true)
	
	if 'toggle_enter' in props:
		toggle_enter = props['toggle_enter'] as bool
		if props['toggle_enter'] as bool == true:
			self.body_entered.connect(handle_body_entered)
			
	
	if 'toggle_exit' in props:
		toggle_exit = props['toggle_exit'] as bool
		if props['toggle_exit'] as bool == true:
			self.body_exited.connect(handle_body_entered)
	
	if 'target' in props:
		target = props["target"] as String
	if 'targetfunc' in props:
		targetfunc = props["targetfunc"] as String
	if 'targetname' in props:
		targetname = props["targetname"] as String

#func update_properties() -> void:
	#if 'collision_mask' in props:
		#for dimension in 3:
			#if props.collision_mask[dimension] > 0 and props.collision_mask[dimension] < 33:
				#print(props.collision_mask[dimension])
				#set_collision_mask_value(props.collision_mask[dimension], true)
	#
	#if 'collision_layers' in props:
		#for dimension in 3:
			#if props.collision_layers[dimension] > int(0) and props.collision_layers[dimension] < int(33):
				#set_collision_layer_value(props.collision_layers[dimension], true)
	#
	#if 'toggle_enter' in props:
		#toggle_enter = props.toggle_enter
	#
	#if 'toggle_exit' in props:
		#toggle_exit = props.toggle_exit


func _ready():
	#print(get_collision_layer())
	#print(get_collision_mask())
	pass

func handle_body_entered(body: Node):
	if body is StaticBody3D:
		return
	AlertTriggers.activate_targets(self, target)
	emit_signal('trigger')

func handle_body_exited(body: Node):
	if body is StaticBody3D:
		return
	AlertTriggers.activate_targets(self, target)
	emit_signal('trigger')
