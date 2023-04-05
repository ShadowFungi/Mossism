extends CharacterBody3D


# Set basic constent values for movement
const MAX_SPEED = 20
const DEFAULT_SPEED = 14
const JUMP_SPEED = 17
const ACCEL = 4.5
const DEACCEL= 16

# Set basic constent values for health
const MAX_HEALTH = 50
const DEFAULT_HEALTH = 10
const MIN_HEALTH = 1

# Set variables for movement
var dir : Vector3 = Vector3()
var cur_speed = 14
var gravity = 22.5

# Set variables for health
var cur_health : int
var max_available_health : int = 10
var health = 10

# External node setup
var pause_menu
var world1 = self.get_world_3d()

@onready var bullet = preload("res://nodes/player/bullet.tscn")

@export var id : int = 0

# Variables used for camera movement 
@onready var pivot := self.get_node("Pivot")
@onready var camera := self.get_node("Pivot/Camera3D")
var mouse_pos = 0
var mouse_sensitivity = 0.01
var controller_sensitivity = 0.07

# Variables used for actions
@onready var timer = self.get_node("CoyoteTimer")

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			self.rotate_y(-event.relative.x * mouse_sensitivity)
			pivot.rotate_x(-event.relative.y * mouse_sensitivity)
			pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-80), deg_to_rad(75))

func _physics_process(delta):
	var was_on_floor
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or !timer.is_stopped()):
		velocity.y = JUMP_SPEED

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector(
		'player-%s_strafe_left' % id,
		'player-%s_strafe_right' % id,
		'player-%s_forward' % id,
		'player-%s_back' % id
		)
	
	if is_on_floor():
		was_on_floor = true 
	else:
		was_on_floor = false
	
	var direction = (self.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * cur_speed
		velocity.z = direction.z * cur_speed
	else:
		velocity.x = move_toward(velocity.x, 0, cur_speed)
		velocity.z = move_toward(velocity.z, 0, cur_speed)
	
	if Input.is_action_just_pressed('player-%s_tool' % id):
		fire()
		print(velocity + pivot.global_transform.basis.z * 2)
		velocity += pivot.global_transform.basis.z * 2
	
	move_and_slide()
	
	if was_on_floor and !is_on_floor():
		timer.start()


func fire():
	var shot1 = bullet.instantiate()
	get_tree().root.get_node("/root/Node3D/QodotMap").add_child(shot1)
	shot1.transform = camera.get_node("SawedOff/Muzzle").global_transform.translated(Vector3(0.2, 0, 0))
	shot1.apply_central_impulse(-pivot.get_node("Camera3D/SawedOff/Muzzle").global_transform.basis.z * 50)
	var shot2 = bullet.instantiate()
	get_tree().root.get_node("/root/Node3D/QodotMap").add_child(shot2)
	shot2.transform = camera.get_node("SawedOff/Muzzle").global_transform.translated(Vector3(0.2, 0, 0))
	shot2.apply_central_impulse(-pivot.get_node("Camera3D/SawedOff/Muzzle").global_transform.basis.z * 50)
