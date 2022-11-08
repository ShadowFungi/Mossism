extends "res://scripts/enemies/BaseEnemy.gd"


signal target_reached
signal path_changed(path)

onready var nav_agent = $NavigationAgent
onready var ray := get_node('EyeMesh/RayCast0')
onready var ray2 := get_node("EyeMesh/RayCast2")
onready var ray3 := get_node("EyeMesh/RayCast3")
onready var ray4 := get_node("EyeMesh/RayCast4")
onready var ray5 := get_node("EyeMesh/RayCast5")

var velocity = Vector3.ZERO
var last_move_velocity = Vector3.ZERO
var gravity = -20
var current_anim = null
var move_dir = Vector3.ZERO
var did_arrive = false

func _ready() -> void:
	pass
#	set_target_pos(translation)


func set_target_pos(target:Vector3) -> void:
	did_arrive = false
	nav_agent.set_target_location(target)


func _physics_process(delta: float) -> void:
	if not visible:
		return
	
	var move_dir = global_translation.direction_to(nav_agent.get_next_location())
	velocity = move_dir * MAX_SPEED
	look_at(move_dir, Vector3.UP)
	nav_agent.set_velocity(velocity)
	if ray.is_inside_tree() and ray.is_colliding():
		set_target_pos(ray.get_collision_point())


func _arrived_at_location() -> bool:
	return nav_agent.is_navigation_finished()


func _get_direction_string(angle:float) -> String:
	var angle_deg = round(rad2deg(angle))
	if angle_deg > -90 and angle_deg < 90:
		return "Right"
	return "Left"


func _on_NavigationAgent_velocity_computed(safe_velocity: Vector3) -> void:
	if not _arrived_at_location():
		velocity = move_and_slide(safe_velocity)
	
	elif not did_arrive:
		did_arrive = true
		emit_signal("path_changed", [])
		emit_signal("target_reached")


func _on_NavigationAgent_path_changed() -> void:
	emit_signal("path_changed", nav_agent.get_nav_path())
