extends CharacterBody3D



@export var properties : Dictionary :
	get:
		return properties
	set(new_properties):
		if(properties != new_properties):
			properties = new_properties
			update_properties()


@export var path: PackedVector3Array
@export var speed: int = 30

@export_subgroup('Dependencies')
@export var ray: RayCast3D
@export var pain_hsm: LimboHSM
@export var crouch_cast: ShapeCast3D
@export var rotate_cast: ShapeCast3D
@export var collision_shape: CollisionShape3D

var player: CharacterBody3D = null
var player_found: bool = false
var path_target: int = 0
var previous_target_pos: Vector3

@onready var nav_agent = $NavigationAgent3D
@onready var original_pos: Vector3 = global_position
@onready var translation_points: PackedVector3Array
@onready var current_point: int = 0
@onready var total_points: int = 0
@onready var size: float
@onready var col_height: float


func _init() -> void:
	self.add_to_group("player_spawn")


func update_properties() -> void:
	if 'angle' in properties:
		self.rotate(Vector3.UP, deg_to_rad(properties.angle))
	if 'translation_1' in properties:
		translation_points.append(properties.translation_1)
	if 'translation_2' in properties:
		translation_points.append(properties.translation_2)
	if 'translation_3' in properties:
		translation_points.append(properties.translation_3)
	if 'translation_4' in properties:
		translation_points.append(properties.translation_4)
	if 'translation_5' in properties:
		translation_points.append(properties.translation_5)


func _ready() -> void:
	max_slides = 2
	size = collision_shape.shape.height
	original_pos = global_position
	col_height = collision_shape.position.y
	#print(original_pos)
	#print(translation_points)
	var previous_point: Vector3 = global_position
	for i in 4:
		if translation_points.size() >= 1:
			if translation_points[i] == Vector3.ZERO:
				break
			total_points += 1
			var translation = previous_point + translation_points[i]
			previous_point = translation
			translation_points.set(i, translation)
			#print(translation_points)
			#print(total_points)
			#print(translation)


func _physics_process(delta: float) -> void:
	var next_pos: Vector3 = nav_agent.get_next_path_position()
	#var new_vel: Vector3 = (Vector3(next_pos - global_position).normalized() * speed)
	var new_vel: Vector3 = (Vector3(next_pos - global_position).normalized() * speed) * delta
	
	#if player_found:
		#
		#update_target_location(player.global_position)
	if !player_found and total_points >= 1:
		update_target_location(Vector3(translation_points[current_point].x, global_position.y, translation_points[current_point].z))
	elif !player_found and path.size() >= 1 :
		update_target_location(path[path_target])
	elif player != null:
		ray.look_at(player.global_position)
	
	if ray.is_colliding() and ray.get_collider().is_in_group('player'):
			update_target_location(ray.get_collider().global_position * Vector3(1.15, 0, 1.15))
	elif ray.is_colliding() and ray.get_collider().is_in_group('player') == false and previous_target_pos != Vector3.ZERO:
		update_target_location(previous_target_pos)
	#new_vel.y -= ProjectSettings.get_setting('physics/3d/default_gravity')
	
	if crouch_cast.is_colliding() == true:
		#for collider in rotate_cast.get_collision_count():
			#if crouch_cast.get_collider(collider).is_in_group('bullet') == false:
				collision_shape.shape.height = size / 2.75
				collision_shape.position.y = col_height / 2.75
	if crouch_cast.is_colliding() == false:
		if crouch_cast.get_collision_count() <= 0:
			collision_shape.shape.height = size
			collision_shape.position.y = col_height
	
	if rotate_cast.is_colliding() == true:
		#if rotate_cast.get_collider(0).is_in_group('bullet') == true:
		print('bullet')
		look_at_point(rotate_cast.get_collision_normal(0))
		await get_tree().create_timer(0.25, 0, false).timeout
		#for collider in rotate_cast.get_collision_count():
			#if collider <= rotate_cast.get_collision_count() -1 :
				#if rotate_cast.get_collider(collider).is_in_group('bullet') == true:
					#print('bullet')
					#look_at_point(rotate_cast.get_collision_normal(collider))
					#look_at(rotate_cast.get_collision_normal(collider))
		pass
	
	velocity = new_vel
	nav_agent.set_velocity(new_vel)
	move_and_collide(velocity)



func update_target_location(target_location: Vector3):
	nav_agent.set_target_position(target_location)
	look_at_point(target_location)
	#look_at(Vector3(target_location.x, global_position.y, target_location.z))


func look_at_point(look_to: Vector3):
	var new_transform = transform.interpolate_with(
		transform.looking_at(
			Vector3(
				look_to.x,
				global_position.y,
				look_to.z
			)
		),
		0.5
	)
	if transform != new_transform:
		transform = new_transform


func _on_area_entered(body: Node3D) -> void:
	if body.is_in_group('player'):
		player = body
		player_found = true


func _on_area_exited(body: Node3D) -> void:
	if body.is_in_group('player'):
		player = null
		player_found = false
		update_target_location(previous_target_pos)


func _on_target_reached() -> void:
	#print("reached")
	#prints(current_point, total_points)
	if current_point < total_points and player_found == false:
		current_point += 1
	if current_point >= total_points and player_found == false:
		#update_target_location(Vector3(original_pos.x, global_position.y, original_pos.z))
		current_point = 0
	if path_target < path.size() and player_found == false:
		path_target += 1
	if path_target >= path.size() -1 and player_found == false:
		path_target = 0


func _on_velocity_computed(safe_velocity: Vector3) -> void:
	previous_target_pos = global_position
	#velocity = velocity.move_toward(safe_velocity, 0.5)
	#move_and_slide()


func damage(type: String) -> void:
	pain_hsm.damage_type = type
	#print(type)
