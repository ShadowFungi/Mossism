extends CharacterBody3D

# Set basic constent values for movement
const GRAVITY = -20
const MAX_SPEED = 20
const DEFAULT_SPEED = 14
const JUMP_SPEED = 18
const ACCEL = 4.5
const DEACCEL= 16
const MAX_SLOPE_ANGLE = 70
# Set basic constent values for health
const MAX_HEALTH = 50
const DEFAULT_HEALTH = 10
const MIN_HEALTH = 1

# Set variables for movement
var dir : Vector3 = Vector3()
var cur_speed = 14

# Set variables for health
var cur_health : int
var max_available_health : int = 10
var health = 10

# External node setup
var pause_menu
var world1

#@onready var bullet = preload("res://scenes/entities/player/Bullet.tscn")

@export var id : int = 0

# Variables used for camera movement 
@onready var camera = self.get_node("Pivot/Camera3D")
@onready var rotation_helper = self.get_node("Pivot")
var mouse_pos = 0
var mouse_sensitivity = 0.05
var controller_sensitivity = 0.07

# Variables used for actions
var timer

# Things that happen when the node is loaded
func _ready():
	#world1 = get_tree().root.get_node("Node/ViewContainer/ViewportContainer/Viewport/ThePit")
	#pause_menu = get_node("PauseMenu")
	#timer = pause_menu.get_node("Timer")
	
	Controller.total_players += 1
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	print('player-%s' % id)

func _physics_process(delta):
	dir.y = 0
	dir = dir.normalized()
	if cur_speed != DEFAULT_SPEED:
		velocity.y += GRAVITY * (delta * (1.2 * (cur_speed / 14.5 )))
	else:
		velocity.y += GRAVITY * (delta * 1.2)
		
	var hvel = velocity
	hvel.y = 0
	
	var target = dir
	target *= cur_speed
	
	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL
	
	hvel = hvel.linear_interpolate(target, accel * delta)
	velocity.x = hvel.x
	velocity.z = hvel.z
	move_and_slide()

# Things for controlling the game
func _unhandled_input(event: InputEvent) -> void: 
	# Camera position variable
	var cam_transform = camera.get_global_transform()
	# Movement input
	var input_movement_vector = Vector2()
	
	# Check if player ID is greater than or equal to zero
	# If that is true then use keyboard or controller to move the player with the appropriate ID
	if id >= 0:
		# Check if the forward input is pressed
		if Input.is_action_just_pressed('player-%s_forward' % id):
			# Add 1 to the movement vector in the y axis
			input_movement_vector.y += 1
		# Check if the back input is pressed
		if Input.is_action_just_pressed('player-%s_back' % id):
			# Subtract 1 from the movement vector in the y axis
			input_movement_vector.y -= 1
		# Check if the strafe right input is pressed
		if Input.is_action_just_pressed('player-%s_strafe_right' % id):
			# Add 1 to the movement vector in the x axis
			input_movement_vector.x += 1
		# Check if the strafe left input is pressed
		if Input.is_action_just_pressed('player-%s_strafe_left' % id):
			# Subtract 1 from the movement vector in the x axis
			input_movement_vector.x -= 1
		
			# Check if there is a joypad connected for the player
			if Input.is_joy_known(id):
				# If there is a joypad connected
				if Input.is_action_pressed('player-%s_look_up'):
					rotation_helper
