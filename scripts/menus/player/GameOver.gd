extends Control


@onready var continue_button = get_node('HBoxContainer/VBoxContainer/ContinueButton')
@onready var main_menu_button = get_node('HBoxContainer/VBoxContainer/MainMenuButton')
@onready var quit_button = get_node('HBoxContainer/VBoxContainer/QuitButton')

## Scene_manager options
@export var fade_speed : float = 1.0
@export var fade_pattern : String = "fade"
@export var fade_smoothness = 0.1
@export var fade_out_invert : bool = true
@export var fade_in_invert : bool = false
@export var color : Color = Color(0, 0, 0)
@export var timeout : float = 0.0
@export var clickable : bool = true
@export var add_to_back : bool = false


func _ready() -> void:
	quit_button.pressed.connect(get_tree().quit)
	continue_button.pressed.connect(continue_from_save)
	main_menu_button.pressed.connect(main_menu)


func continue_from_save() -> void:
	get_tree().set_pause(false)
	get_tree().reload_current_scene()


func main_menu() -> void:
	self.hide()
	get_tree().set_pause(false)
