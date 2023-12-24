class_name PlayerState
extends State

@export_category('Player State Options')
@export_group('Enterable States')
@export var walk_state : State
@export var sprint_state : State
@export var crouch_state : State
@export var idle_state : State

@export_group('Variables')

@export var move_speed: float = 15

var can_step_down: bool = true

func look_follow(state, current_transform, target_position):
	var up_dir = Vector3(0, 1, 0)
	var cur_dir = (current_transform.basis * Vector3(0, 1, 0))
	var target_dir = (target_position - current_transform.origin).normalized()
	var rotation_angle = acos(cur_dir.x) - acos(target_dir.x)
	
	state.angular_velocity = up_dir * (rotation_angle / state.step)

func step(delta: float):
	if parent_machine.step_detect.is_colliding() == true:
		var collider = parent_machine.step_detect.get_collider(0)
		for child in collider.get_children():
			if child is MeshInstance3D:
				var mesh = child.get_mesh()
				var aabb = mesh.get_aabb()
				var col_point = parent_machine.step_detect.get_collision_point(0)
				var col_normal = parent_machine.step_detect.get_collision_normal(0)
				if aabb.size.y <= 2.5 and parent.is_on_floor():
					var motion = Vector3(
						0,
						(aabb.size.y + (
							parent_machine.step_detect.global_position.y 
							- 
							child.global_position.y
						) / 2),
						0
					).normalized()
					print(parent.test_move(parent.transform, motion))
					parent.translate(motion)
					var step_dist = 10
					if parent.global_position.z > col_point.z:
						parent.velocity.z -= step_dist
					if  parent.global_position.z < col_point.z:
						parent.velocity.z += step_dist
					if parent.global_position.x > col_point.x:
						parent.velocity.x -= step_dist
					if parent.global_position.x < col_point.x:
						parent.velocity.x += step_dist

func step_down():
	var ray = parent_machine.ledge_detect
	if !parent.is_on_floor() and ray.is_colliding() and can_step_down == true:
		if ray.get_collider():
			for child in ray.get_collider().get_children():
				if child is MeshInstance3D:
					if child.get_aabb().size.y <= 1.5:
						parent.velocity.y -= 6

