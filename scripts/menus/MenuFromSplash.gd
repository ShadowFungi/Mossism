extends Timer

onready var scene = preload("res://scenes/menus/MainMenu.tscn")

func _ready():
	wait_time = 2
	one_shot = true
	start()

func _on_Timer_timeout():
	get_tree().change_scene_to(scene)
