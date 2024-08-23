extends CharacterBody3D


@export_subgroup('Dependencies')
@export var player: CharacterBody3D

@onready var pos = position
#@onready var bas = character.basis
@export_subgroup('Ignore These')
@export var ray: RayCast3D
@export var area: Area3D
@export var muzzle_1: Node3D
@export var muzzle_2: Node3D
@export_file('*.tscn', '*.scn') var bullet_path: String
var can_reset: bool = true
var area_collides: bool = false
var parent: Node3D
var bullet
var can_fire: bool = true

func _ready() -> void:
	bullet = load(bullet_path).instantiate()
	bullet.host_player_id = player.id
	pos = position

func _physics_process(_delta: float) -> void:
	#velocity = Vector3.ZERO
	#if position != pos:
		#velocity = Vector3(position.direction_to(pos).x, 0, position.direction_to(pos).z)
	position = position.move_toward(pos, 0.5)
	
	if !area_collides:
		can_reset = true
	
	#if ray.is_colliding():
		#if parent:
			#print(parent.global_position, "-", global_position)
			#position = parent.global_position.direction_to(global_position)
		#can_reset = false
	
	elif position.distance_to(pos) > 3 and can_reset:
		position = pos
	
	#if position.distance_to(character.origin) > 10:
	#	position = pos
		#print(position.distance_to(character.origin))
	move_and_slide()


func fire():
	if can_fire == false:
		return
	can_fire = false
	## Prepare sawed_off_bullet instances
	var shot1 = bullet.duplicate()
	var shot2 = bullet.duplicate()
	
	## Add sawed_off_bullet instances to the world
	get_tree().root.get_node("/root/SplitScreen/GridContainer/SubViewportContainer/SubViewport/NavigationRegion3D").add_child(shot1)
	get_tree().root.get_node("/root/SplitScreen/GridContainer/SubViewportContainer/SubViewport/NavigationRegion3D").add_child(shot2)
	
	## Set sawed_off_bullets to appropriate position
	shot1.global_transform = muzzle_1.global_transform
	shot2.global_transform = muzzle_2.global_transform
	
	muzzle_1.get_child(0).play()
	muzzle_2.get_child(0).play()
	
	## FIRE!
	## Launch sawed_off_bullets through a central impulse
	shot1.apply_central_impulse(-muzzle_1.global_transform.basis.z * 77.5)
	shot2.apply_central_impulse(-muzzle_2.global_transform.basis.z * 77.5)
	await get_tree().create_timer(0.25, false).timeout
	can_fire = true



func _on_area_3d_body_entered(_body: Node3D) -> void:
	area_collides = true


func _on_area_3d_body_exited(_body: Node3D) -> void:
	area_collides = false
