extends Control

@export var play_button_scene : String
@export var options_button_scene : String
@export var fade_speed : float = 0.2
@export var fade_pattern : String = "fade"
@export var fade_smoothness = 0.1
@export var fade_out_invert : bool = true
@export var fade_in_invert : bool = false
@export var color : Color = Color(0, 0, 0)
@export var timeout : float = 0.0
@export var clickable : bool = true
@export var add_to_back : bool = true

@onready var fade_out_opts = SceneManager.create_options(fade_speed, fade_pattern, fade_smoothness, fade_out_invert)
@onready var fade_in_opts = SceneManager.create_options(fade_speed, fade_pattern, fade_smoothness, fade_in_invert)
@onready var general_opts = SceneManager.create_general_options(color, timeout, clickable, add_to_back)

# Set button variables
@onready var quit_button = get_node("HBoxContainer/VBoxContainer/MarginContainer3/QuitButton")
@onready var play_button = get_node("HBoxContainer/VBoxContainer/MarginContainer/PlayButton")
@onready var options_button = get_node("HBoxContainer/VBoxContainer/MarginContainer2/OptionsButton")


func _ready() -> void:
	get_node('/root/SceneManager').set_process_mode(Node.PROCESS_MODE_ALWAYS)
	get_tree().set_pause(false)
	var fade_in_scene_opts = SceneManager.create_options(1, "fade")
	SceneManager.show_first_scene(fade_in_scene_opts, general_opts)
	SceneManager.validate_scene(play_button_scene)
	SceneManager.validate_scene(options_button_scene)
	SceneManager.validate_pattern(fade_pattern)
	
	# Connect buttons to appropriate functions
	quit_button.pressed.connect(get_tree().quit)
	play_button.pressed.connect(play_pressed)
	options_button.pressed.connect(options_pressed)


func play_pressed():
	SceneManager.change_scene(play_button_scene, fade_out_opts, fade_in_opts, general_opts)


func options_pressed() -> void:
	$OptionsMenu.show()
	$HBoxContainer.hide()
