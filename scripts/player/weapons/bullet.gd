extends RigidBody3D


signal exploded


func _ready():
	randomize()
	$Timer.start(randf_range(6.5, 7.0))

func body_entered(_body):
	emit_signal("exploded", transform.origin)
	queue_free()

func _on_timer_timeout():
	$AudioStreamPlayer3D.play()
	$GPUParticles3D.emitting = true

func _on_sound_finished() -> void:
	queue_free()
