extends Control


@onready var health_label = get_node('PanelContainer/HBoxContainer/MarginContainer2/Label2')


func update_health(new_health: float, max_health: float) -> void:
	health_label.set_text('HEALTH : %d' % new_health + "/%d" % max_health)
