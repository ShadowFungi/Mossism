extends RigidBody3D

signal exploded

func _ready():
	$Timer.start(5.0)


func body_entered(_body):
	emit_signal("exploded", transform.origin)
	queue_free()


func _on_timer_timeout():
	queue_free()
