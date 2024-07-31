extends LimboState


@export var player: CharacterBody3D
@export var ground_ray: RayCast3D


#func _setup() -> void:
#	add_event_handler(&'jump_end', _jump)

func _enter() -> void:
	pass

func _update(delta: float) -> void:
	player.velocity.y -= 5 * delta
	if ground_ray.is_colliding() == true:
		dispatch(&'grounded')
