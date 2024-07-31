extends CharacterBody3D

@export var properties : Dictionary :
	get:
		return properties
	set(new_properties):
		if(properties != new_properties):
			properties = new_properties
			update_properties()

var base_transform: Transform3D
var offset_transform: Transform3D
var target_transform: Transform3D
var final_transform: Transform3D

var did_motion_start: bool = false

@onready var sound = preload('res://nodes/entities/sfxr_slide.tscn').instantiate()

var speed := 1.0


func update_properties() -> void:
	if 'translation' in properties:
		offset_transform.origin = properties.translation
	
	if 'rotation' in properties:
		offset_transform.basis = offset_transform.basis.rotated(Vector3.RIGHT, properties.rotation.x)
		offset_transform.basis = offset_transform.basis.rotated(Vector3.UP, properties.rotation.y)
		offset_transform.basis = offset_transform.basis.rotated(Vector3.FORWARD, properties.rotation.z)
	
	if 'scale' in properties:
		offset_transform.basis = offset_transform.basis.scaled(properties.scale)
	
	if 'speed' in properties:
		speed = properties.speed


func _process(delta: float) -> void:
	if transform.origin != target_transform.origin:
		transform.origin = transform.origin.move_toward(target_transform.origin, speed * delta)
	if transform.origin.round() == target_transform.origin.round() and did_motion_start:
		motion_ended()

func _init() -> void:
	base_transform = transform
	target_transform = base_transform
	final_transform = base_transform * offset_transform

func _ready() -> void:
	self.add_to_group("ground", true)
	var bake_call = Callable(self, "_baked")
	add_child(sound)

func use() -> void:
	play_motion()
	sound.play()

func play_motion() -> void:
	var temp_transform = base_transform * offset_transform
	target_transform.origin.x = snapped(temp_transform.origin.x, 0.1)
	target_transform.origin.y = snapped(temp_transform.origin.y, 0.1)
	target_transform.origin.z = snapped(temp_transform.origin.z, 0.1)
	did_motion_start = true
	print(did_motion_start)

func reverse_motion() -> void:
	target_transform.origin.x = snapped(base_transform.origin.x, 0.1)
	target_transform.origin.y = snapped(base_transform.origin.y, 0.1)
	target_transform.origin.z = snapped(base_transform.origin.z, 0.1)
	did_motion_start = true

func motion_ended() -> void:
	Level.bake_map = true
	did_motion_start = false
	#Level.bake(nav_reg)

func _baked():
	pass
