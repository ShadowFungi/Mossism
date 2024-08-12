extends Control


@onready var continue_button = get_node('HBoxContainer/VBoxContainer/ContinueButton')
@onready var main_menu_button = get_node('HBoxContainer/VBoxContainer/MainMenuButton')
@onready var quit_button = get_node('HBoxContainer/VBoxContainer/QuitButton')

@onready var menu = load('res://nodes/menus/StartMenu.tscn')

func _ready() -> void:
	SceneSwap.add_scene_to_queue(menu, 'MainMenu')
	quit_button.pressed.connect(get_tree().quit)
	continue_button.pressed.connect(continue_from_save)
	main_menu_button.pressed.connect(main_menu)


func continue_from_save() -> void:
	get_tree().set_pause(false)
	get_tree().reload_current_scene()


func died() -> void:
	self.show()
	get_tree().set_pause(true)


func main_menu() -> void:
	get_tree().set_pause(false)
	self.hide()
	SceneSwap.replace_node_with_queued_scene('MainMenu', true, get_node('/root/SplitScreen'), true)
