extends Control


@onready var effects_slider : Slider = get_node('EffectsContainer/VSlider')
@onready var master_slider : Slider = get_node('MasterContainer/VSlider')


func _ready() -> void:
	master_slider.value = AudioServer.get_bus_volume_db(0)
	master_slider.value = AudioServer.get_bus_volume_db(1)

func _on_master_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, master_slider.value)
	print(AudioServer.get_bus_volume_db(0))


func _on_effects_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, effects_slider.value)
	print(AudioServer.get_bus_volume_db(1))
