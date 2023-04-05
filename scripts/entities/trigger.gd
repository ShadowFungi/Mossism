extends Area3D


signal trigger()

func _ready():
	self.body_entered.connect(handle_body_entered)

func handle_body_entered(body: Node):
	if body is StaticBody3D:
		return
	
	emit_signal("trigger")
