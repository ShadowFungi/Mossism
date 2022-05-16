extends RigidBody

signal exploded

var id = 0

func _ready():
	$Timer.start(5.0)

func _on_Shell_body_entered(body):
	emit_signal("exploded", transform.origin)
	queue_free()


func _on_Timer_timeout():
	queue_free()
