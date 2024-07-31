extends CharacterBody3D

@export var path: PackedVector3Array
@export var speed: int = 10
@export var vision_angle := 145
@export var angle_between_rays := 5.0
@export var max_view := 500.0
@export var ray: RayCast3D


var vision_angle_rad := deg_to_rad(vision_angle)
var angle_between_rays_rad := deg_to_rad(angle_between_rays)
var cast_coordinates := precalc_ray_coords()

var player: CharacterBody3D
var player_found: bool = false
var path_target: int = 0
var previous_target_pos: Vector3

@onready var nav_agent = $NavigationAgent3D
@onready var original_pos: Vector3 = global_position


func _ready() -> void:
	original_pos = global_position

func _physics_process(delta: float) -> void:
	var next_pos: Vector3 = nav_agent.get_next_path_position()
	var new_vel: Vector3 = Vector3(next_pos - global_position).normalized() * speed
	
	#if player_found:
		#
		#update_target_location(player.global_position)
	if !player_found:
		update_target_location(path[path_target])
	
	elif player_found:
		ray.look_at(player.global_position)
	
	if ray.is_colliding() and ray.get_collider() is Player:
			update_target_location(ray.get_collider().global_position)
	#new_vel.y -= ProjectSettings.get_setting('physics/3d/default_gravity')
	
	nav_agent.set_velocity(new_vel)

func update_target_location(target_location: Vector3):
	nav_agent.set_target_position(target_location)
	transform = transform.interpolate_with(
		transform.looking_at(
			Vector3(
				target_location.x,
				global_position.y,
				target_location.z
			)
		),
		0.025
	)

func precalc_ray_coords() -> Array:
	var cast_vectors := []
	var cast_count := float(vision_angle_rad / angle_between_rays_rad) + 1
	
	for index in cast_count:
		var cast_vector := (
			max_view * Vector3.UP.rotated(
				Vector3(1, 1, 1).normalized(), angle_between_rays_rad * (
					index - cast_count / 2.0
				)
			)
		)
		cast_vectors.append(cast_vector)
	
	return cast_vectors

func shoot_ray():
	for i in cast_coordinates.size():
		ray.target_position = cast_coordinates[i]
		ray.force_raycast_update()

func _on_area_entered(body: Node3D) -> void:
	if body.is_in_group('player'):
		previous_target_pos = global_position
		player = body
		player_found = true

func _on_area_exited(body: Node3D) -> void:
	if body.is_in_group('player'):
		player = null
		player_found = false
		update_target_location(previous_target_pos)

func _on_target_reached() -> void:
	print("reached")
	if path_target >= path.size() -1:
		path_target = 0
	elif path_target < path.size():
		path_target += 1

func _on_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = velocity.move_toward(safe_velocity, 0.25)
	move_and_slide()
