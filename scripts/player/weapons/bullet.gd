extends RigidBody3D

@export var explodes: bool = false
var host_player_id: int


func _ready():
	randomize()
	$Timer.start(randf_range(6.5, 7.5))


#func body_entered(body: PhysicsBody3D):
#	if body.is_in_group(&'player'):
#		if body.id != host_player_id:
#			_emit_damage(body)
#	if body.is_in_group(&'enemy'):
#		_emit_damage(body)


func _on_timer_timeout():
	$AudioStreamPlayer3D.play()
	$GPUParticles3D.emitting = true


func _on_sound_finished() -> void:
	queue_free()


func _emit_damage(body: PhysicsBody3D) -> void:
	if body.has_method('damage') and body.is_inside_tree():
		if explodes == true:
			body.damage('explosion')
		else:
			body.damage('shot')
		self.hide()
		await get_tree().create_timer(0.15, false).timeout
		body.damage('none')
		await get_tree().create_timer(0.25, false).timeout
		queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group(&'player'):
		if body.id != host_player_id:
			_emit_damage(body)
	#if body.is_in_group(&'enemy'):
	else:
		_emit_damage(body)
