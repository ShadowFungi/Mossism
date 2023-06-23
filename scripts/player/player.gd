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
var was_on_floor

## Might use, needs more testing.
#func _ready() -> void:
#	camera.get_node("SawedOff/SawedOffBody").body_entered.connect(body_entered)
#	camera.get_node("SawedOff/SawedOffBody").body_exited.connect(body_exited)
#
#func body_entered(body):
#	print("SawedOff clipped")
#	if !body.collision_layer == pow(2, 21-1):
#		camera.get_node('SawedOff').transform = camera.get_node('SawedOff').transform.translated(Vector3(0, 0, 0.4))
#
#func body_exited(body):
#	print("SawedOff freed")
#	if !body.collision_layer == pow(2, 21-1):
#		camera.get_node('SawedOff').transform = camera.get_node('SawedOff').transform.translated(Vector3(0, 0, -0.4))

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#	elif event.is_action_pressed('player-%s_pause' % id):
#		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event.is_action_pressed('player-%s_pause' % id):
		get_node("PauseMenu").pause()
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			self.rotate_y(-event.relative.x * mouse_sensitivity)
			pivot.rotate_x(-event.relative.y * mouse_sensitivity)
			pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-80), deg_to_rad(75))

func _physics_process(delta):
	## Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	## Handle Jump.
	if Input.is_action_just_pressed('player-%s_jump' % id) and (is_on_floor() or !timer.is_stopped()):
		velocity.y = JUMP_SPEED * (delta + 1)

	## Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector(
		'player-%s_strafe_left' % id,
		'player-%s_strafe_right' % id,
		'player-%s_forward' % id,
		'player-%s_back' % id
		)
	
	## Variable will be changed if the player is on the floor so they can jump
	## Also used for coyote time
	if is_on_floor():
		was_on_floor = true 
	else:
		was_on_floor = false
	
	var direction = (self.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	## Check if a direction is available for movement
	if direction:
		## Apply velocity for horizontal movement
		velocity.x = direction.x * cur_speed
		velocity.z = direction.z * cur_speed
	else:
		## Neutralize movement otherwise
		velocity.x = move_toward(velocity.x, 0, cur_speed)
		velocity.z = move_toward(velocity.z, 0, cur_speed)
	
	## Check if the player is trying to use a tool
	if Input.is_action_just_pressed('player-%s_tool' % id) && Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		## If so starts appropriate function
		fire()
		velocity += pivot.global_transform.basis.z * 2
	
	## Apply movement
	move_and_slide()
	
	## Start timer for coyote time
	if was_on_floor and !is_on_floor():
		timer.start()
	


func fire():
	## Prepare bullet instances
	var shot1 = bullet.instantiate()
	var shot2 = bullet.instantiate()
	
	## Add bullet instances to the world
	get_tree().root.get_node("/root/Node3D/NavigationRegion3D/QodotMap").add_child(shot1)
	get_tree().root.get_node("/root/Node3D/NavigationRegion3D/QodotMap").add_child(shot2)
	
	## Set bullets to appropriate position
	shot1.transform = camera.get_node("SawedOffBody/SawedOff/Muzzle").global_transform.translated(Vector3(0.2, 0, 0))
	shot2.transform = camera.get_node("SawedOffBody/SawedOff/Muzzle").global_transform.translated(Vector3(-0.2, 0, 0))
	
	## FIRE!
	## Launch bullets through a central impulse
	shot1.apply_central_impulse(-camera.get_node("SawedOffBody/SawedOff/Muzzle").global_transform.basis.z * 80)
	shot2.apply_central_impulse(-camera.get_node("SawedOffBody/SawedOff/Muzzle").global_transform.basis.z * 80)
