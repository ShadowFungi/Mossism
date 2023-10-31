extends CharacterBody3D

# Variables to be used in trenchbroom

# Speed; how fast the object will move
@export var speed: float = 5.0
# Angle; the direction that the object will move
@export var angle: float = 0.0
# Translation; how far the object will move
@export var translation: Vector3 = Vector3(1,0,0)

# Variables used for transform calculation
var base_transform: Transform3D
var offset_transform: Transform3D
var target_transform: Transform3D
var final_transform: Transform3D
var void_transform: Transform3D

func _ready() -> void:
	offset_transform.origin.x = translation.x
	offset_transform.origin.y = translation.y
	offset_transform.origin.z = translation.z
	void_transform.origin = Vector3(0, 0, 0)

# The process function
func _process(delta) -> void:
	if target_transform != void_transform:
		transform = transform.interpolate_with(target_transform, speed * delta)

# Function used to move object to new position
func play_motion() -> void:
	# Variable used to calculate the final position of the object
	var temp_transform = base_transform * offset_transform
	# Set target position
	target_transform.origin.x = snappedf(temp_transform.origin.x, 0.1)
	target_transform.origin.y = snappedf(temp_transform.origin.y, 0.1)
	target_transform.origin.z = snappedf(temp_transform.origin.z, 0.1)
	# Variable used to tell other scripts, that the navigation mesh needs to be baked
	Level.map_baked = false

# Function used to move object to original position
func reverse_motion() -> void:
	pass

# Function used when movement has finished
func motion_ended() -> void:
	# Check if any of the current coordinates match the target transform
	if snappedf(transform.origin.x, 0.1) == target_transform.origin.x \
		or snappedf(transform.origin.y, 0.1) == target_transform.origin.y \
		or snappedf(transform.origin.z, 0.1) == target_transform.origin.z:
		if Level.bake_ended != false:
			Level.bake()
