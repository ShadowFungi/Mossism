extends LimboState


@onready var pain_hsm:= get_parent()


func _update(_delta: float) -> void:
	match pain_hsm.damage_type:
		'fire':
			print('caught fire')
			dispatch(&'caught_fire')
		'explosion':
			dispatch(&'exlpoded')
		'shot':
			dispatch(&'shot')
		'slash':
			dispatch(&'slashed')
		'ill':
			dispatch(&'illness')
		'stab':
			dispatch(&'stabbed')
