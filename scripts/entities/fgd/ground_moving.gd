@tool
class_name GroundMoving3D
extends StaticBody3D


@export var func_godot_properties: Dictionary

@export var target: String = ""
@export var targetfunc: String = ""
@export var targetname: String = ""

@export var path: PackedVector3Array

signal motion_finished()

var base_transform: Transform3D
var offset_transform: Transform3D
var target_transform: Transform3D
var final_transform: Transform3D

var speed := 1.0

var reversible : bool = false
@export var can_reverse_motion : bool = false

var collision

@export var render_layers: Array[int]


func _func_godot_apply_properties(props: Dictionary) -> void:
	for prop in props.keys():
		if 'translation' in prop:
			path.append(AlertTrigger.id_vec_to_godot_vec(props[prop]))
	if 'rotation' in props:
		offset_transform.basis = offset_transform.basis.rotated(Vector3.RIGHT, props['rotation'].x)
		offset_transform.basis = offset_transform.basis.rotated(Vector3.UP, props['rotation'].y)
		offset_transform.basis = offset_transform.basis.rotated(Vector3.FORWARD, props['rotation'].z)
	if 'scale' in props:
		offset_transform.basis = offset_transform.basis.scaled(props['scale'])
	if 'speed' in props:
		speed = props['speed'] as float
	if 'can_reverse_motion' in props:
		can_reverse_motion = props['can_reverse_motion'] as bool
	
	if 'target' in props:
		target = props["target"] as String
	if 'targetfunc' in props:
		targetfunc = props["targetfunc"] as String
	if 'targetname' in props:
		targetname = props["targetname"]

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint() == true: return
	#print('not engine')
	#if transform.origin.is_equal_approx(target_transform.origin) == true:
	#	motion_ended()
	if transform.origin.is_equal_approx(target_transform.origin) == false:
		#move_and_collide(target_transform.origin)
		#move_and_collide()
		transform.origin = transform.origin.move_toward(target_transform.origin, speed * delta)
		#var movement = move_and_collide((((offset_transform.origin) * speed)) * delta)
		#if movement:
		#	collision = movement.get_collider(0)
			#collision.set_physics_process(false)
	if Level.map_baked == false and Level.map_bake_ended == true:
		motion_ended()

func _init() -> void:
	self.add_to_group("wall", true)
	#sync_to_physics = false
	base_transform = transform
	target_transform = base_transform
	final_transform = base_transform * offset_transform

func _ready() -> void:
	if Engine.is_editor_hint(): return
	AlertTriggers.set_targetname(self, targetname)
	var _bake_call = Callable(self, "_baked")

func use() -> void:
	if reversible == true:
		reverse_motion()
	else:
		play_motion()

func play_motion() -> void:
	var temp_transform = base_transform.translated(path[0])
	target_transform.origin.x = snapped(temp_transform.origin.x, 0.1)
	target_transform.origin.y = snapped(temp_transform.origin.y, 0.1)
	target_transform.origin.z = snapped(temp_transform.origin.z, 0.1)
	Level.map_baked = false
	if can_reverse_motion == true:
		reversible = AlertTrigger.toggle_bool(reversible)

func reverse_motion() -> void:
	target_transform.origin.x = snapped(base_transform.origin.x, 0.1)
	target_transform.origin.y = snapped(base_transform.origin.y, 0.1)
	target_transform.origin.z = snapped(base_transform.origin.z, 0.1)
	Level.map_baked = false
	if can_reverse_motion == true:
		reversible = AlertTrigger.toggle_bool(reversible)

func motion_ended() -> void:
	AlertTriggers.activate_targets(self, target)
	emit_signal('motion_finished')

func _baked():
	Level.map_bake_ended = true
