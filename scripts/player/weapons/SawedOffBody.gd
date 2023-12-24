extends CharacterBody3D


@onready var pos = position
#@onready var bas = character.basis
@export var ray: RayCast3D
@export var area: Area3D
var can_reset: bool = true
var area_collides: bool = false
var parent: Node3D


func _ready() -> void:
	pos = position

func _physics_process(_delta: float) -> void:
	#velocity = Vector3.ZERO
	#if position != pos:
		#velocity = Vector3(position.direction_to(pos).x, 0, position.direction_to(pos).z)
	position = position.move_toward(pos, 0.2)
	
	if !area_collides:
		can_reset = true
	
	#if ray.is_colliding():
		#if parent:
			#print(parent.global_position, "-", global_position)
			#position = parent.global_position.direction_to(global_position)
		#can_reset = false
	
	elif position.distance_to(pos) > 5 and can_reset:
		position = pos
	
	#if position.distance_to(character.origin) > 10:
	#	position = pos
		#print(position.distance_to(character.origin))
	move_and_slide()


func _on_area_3d_body_entered(body: Node3D) -> void:
	area_collides = true


func _on_area_3d_body_exited(body: Node3D) -> void:
	area_collides = false
