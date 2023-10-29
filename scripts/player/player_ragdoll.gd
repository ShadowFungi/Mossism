extends Skeleton3D


func _ready() -> void:
	physical_bones_start_simulation()

func _on_ragdoll_timer_timeout() -> void:
	physical_bones_stop_simulation()
