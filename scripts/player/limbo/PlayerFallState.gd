extends LimboState


@export var player: CharacterBody3D
@export var ground_ray: RayCast3D


#func _setup() -> void:
#	add_event_handler(&'jump_end', _jump)

func _enter() -> void:
	pass


func _update(delta: float) -> void:
	player.velocity.y -= (player.gravity * 2) * delta
	if player.is_on_floor() == true:
		dispatch(&'grounded')


func _exit() -> void:
	player.can_step_up = true
