extends Area3D


@export var damage_type: String = 'stab'
var host_player_id: int


func _ready():
	randomize()
	#$Timer.start(randf_range(6.5, 7.5))


func body_entered(body: Node3D):
	print(body)
	if body.is_in_group(&'player'):
			_emit_damage(body)


func _on_timer_timeout():
	$AudioStreamPlayer3D.play()
	$GPUParticles3D.emitting = true


func _on_sound_finished() -> void:
	hide()


func _emit_damage(body: Node3D) -> void:
	if body.has_method('damage'):
		body.damage(damage_type)
		#hide()
