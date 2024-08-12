extends RigidBody3D

@export var explodes: bool = false
var host_player_id: int


func _ready():
	randomize()
	$Timer.start(randf_range(6.5, 7.5))


func body_entered(body: PhysicsBody3D):
	if body.is_in_group(&'player'):
		if body.id != host_player_id:
			_emit_damage(body)
	if body.is_in_group(&'enemy'):
		_emit_damage(body)


func _on_timer_timeout():
	$AudioStreamPlayer3D.play()
	$GPUParticles3D.emitting = true


func _on_sound_finished() -> void:
	queue_free()


func _emit_damage(body: PhysicsBody3D) -> void:
	if body.has_method('damage'):
		if explodes == true:
			body.damage('explosion')
		else:
			body.damage('shot')
		queue_free()
