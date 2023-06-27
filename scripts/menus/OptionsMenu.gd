extends Control


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
	SceneManager.validate_pattern(fade_pattern)

func _on_import_key_map_button_pressed() -> void:
	$ImportKeyMap.show()


func _on_load_key_map_button_pressed() -> void:
	#InputRemapper.load_map()
	pass


func _on_save_key_map_button_pressed() -> void:
	InputRemapper.set_default_map()
	$SaveKeyMap.show()


func _on_save_key_map_file_selected(path: String) -> void:
	InputRemapper.save_map(path)


func _on_import_key_map_file_selected(path: String) -> void:
	InputRemapper.import_map(path)


func _on_back_button_pressed() -> void:
	get_parent().get_child(1).show()
	self.hide()
