extends Button

@export var scene : String
@export var fade_speed : float = 1.0
@export var fade_pattern : String = "fade"
@export var fade_smoothness = 0.1
@export var fade_out_invert : bool = true
@export var fade_in_invert : bool = false
@export var color : Color = Color(0, 0, 0)
@export var timeout : float = 0.0
@export var clickable : bool = false
@export var add_to_back : bool = true

@onready var fade_out_opts = SceneManager.create_options(fade_speed, fade_pattern, fade_smoothness, fade_out_invert)
@onready var fade_in_opts = SceneManager.create_options(fade_speed, fade_pattern, fade_smoothness, fade_in_invert)
@onready var general_opts = SceneManager.create_general_options(color, timeout, clickable, add_to_back)


func _ready() -> void:
	var fade_in_scene_opts = SceneManager.create_options(1, "fade")
	SceneManager.show_first_scene(fade_in_scene_opts, general_opts)
	SceneManager.validate_scene(scene)
	SceneManager.validate_pattern(fade_pattern)

func _pressed():
	SceneManager.change_scene(scene, fade_out_opts, fade_in_opts, general_opts)
