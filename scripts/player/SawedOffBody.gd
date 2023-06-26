extends CharacterBody3D

@onready var character : Transform3D = self.get_parent().get_parent().get_parent().global_transform
@onready var walled : bool = false
@onready var pos = position
@onready var bas = character.basis

func _ready() -> void:
	pos = position

func _physics_process(_delta: float) -> void:
	velocity = Vector3.ZERO
	position = position.move_toward(pos, 0.2)
	if position.distance_to(character.origin) > 7:
		position = pos
		#print(position.distance_to(character.origin))
	move_and_slide()
