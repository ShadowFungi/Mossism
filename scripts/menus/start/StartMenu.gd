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

# Set button variables
@onready var quit_button = get_node("HBoxContainer/VBoxContainer/MarginContainer3/QuitButton")
@onready var play_button = get_node("HBoxContainer/VBoxContainer/MarginContainer/PlayButton")
@onready var options_button = get_node("HBoxContainer/VBoxContainer/MarginContainer2/OptionsButton")

@onready var gameplay = preload('res://scenes/modes/SplitScreen.tscn')

func _ready() -> void:
	#SceneSwap.add_scene_to_queue('res://scenes/modes/SplitScreen.tscn', 'SplitScreen')
	SceneSwap.add_scene_to_queue(gameplay, 'SplitScreen')
	get_tree().set_pause(false)
	
	# Connect buttons to appropriate functions
	quit_button.pressed.connect(get_tree().quit)
	play_button.pressed.connect(play_pressed)
	options_button.pressed.connect(options_pressed)


func play_pressed():
	SceneSwap.replace_node_with_queued_scene('SplitScreen', true, get_node('/root/StartMenu'), true)
	pass


func options_pressed() -> void:
	$OptionsMenu.show()
	$HBoxContainer.hide()
