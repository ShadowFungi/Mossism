extends NavigationMeshInstance


var bake = 0
onready var baker = get_parent().get_node('BakeTimer')


func _on_death_trigger():
	get_tree().root.get_node("Node/ViewContainer/ViewportContainer/Viewport/Player/GameOver").show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true


func _on_entity_265_button_trigger() -> void:
	baker.set_wait_time(1)
	baker.start()

func _ready() -> void:
	bake_navigation_mesh(true)
