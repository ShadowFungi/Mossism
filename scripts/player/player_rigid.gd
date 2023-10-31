class_name PlayerRigid
extends RigidBody3D

## Set basic constent values for movement
const MAX_SPEED = 20
const DEFAULT_SPEED = 14
const JUMP_SPEED = 22
const ACCEL = 4.5
const DEACCEL= 16

## Set basic constent values for health
const MAX_HEALTH = 20000
const DEFAULT_HEALTH = 500
const MIN_HEALTH = 1

## Constants used for step traversal
const MAX_SNAP_HEIGHT = 2.25
const MIN_SNAP_DISTANCE = 1.25

## Set variables for movement
var dir : Vector3 = Vector3()
var gravity = 40
var gravity_multiplier = 10
var direction

## Set variables for health
var cur_health : float = DEFAULT_HEALTH
var cur_max_health : float = DEFAULT_HEALTH
var max_available_health : int = 10
var health = 10

## Set variables for step traversal
var can_snap_down : bool = true
var can_step_up : bool = true

## External node setup
## Get StairDetection nodes for detecting stairs
@onready var hud = get_node('HUD')
var timer_start_from : String
## Get PauseMenu node
@onready var pause_menu = self.get_node('PauseMenu')
@onready var gameover = self.get_node('GameOver')

## Export the player ID so it can be changed when needed
@export var id : int = 0

## Variables used for camera movement
@onready var pivot := self.get_node('MetaRig/Pivot')
@onready var camera := self.get_node('MetaRig/Pivot/Camera3D')
@onready var metarig := self.get_node('MetaRig')
@onready var shape : Shape3D = self.get_node('CollisionShape3D').shape
var mouse_pos : Vector2
var mouse_sensitivity = 1.5
var controller_sensitivity = 0.07

## Variables used for character movement
@onready var player_machine : FiniteStateMachine = get_node('PlayerStateMachine')
@onready var jump_machine : FiniteStateMachine = get_node('JumpStateMachine')
@onready var ground_cast : ShapeCast3D = get_node('GroundedCast')

## Variables used for actions
@onready var timer = self.get_node('CoyoteTimer')
var is_on_ground : bool

## Define upgrade variables
var fire_res : bool = false
var collision_layers : Array


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event.is_action_pressed('player-%s_pause' % id):
		get_node('PauseMenu').pause()
		set_process_input(true)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED && id == 0:
		if event is InputEventMouseMotion:
			mouse_pos = (event.relative * mouse_sensitivity)
			#metarig.rotate_y(deg_to_rad(-mouse_pos.x))
			pivot.rotate_x(deg_to_rad(mouse_pos.y))
			pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-80), deg_to_rad(75))
			get_node('LookPivot').rotate_y(deg_to_rad(mouse_pos.x))

func _physics_process(_delta):
	if cur_health <= 0:
		dead()
	
	## Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector(
		'player-%s_strafe_left' % id,
		'player-%s_strafe_right' % id,
		'player-%s_forward' % id,
		'player-%s_back' % id
	)
	direction = (self.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		#print(direction)
		player_machine.change_state('PlayerWalk')
	
	if ground_cast.is_colliding() == true:
		is_on_ground = true
	else:
		is_on_ground =false
	
	if Input.is_action_just_pressed('player-%s_tool_mouse' % id) && Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED or Input.is_action_just_pressed('player-%s_tool_key' % id):
		## If so starts appropriate function
		get_node('WeaponStateMachine').fire()

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if Input.is_action_just_pressed('player-%s_jump' % id) && Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if is_on_ground == true:
			jump_machine.change_state('PlayerJump')
			jump_machine.state.jump(self, JUMP_SPEED, state)
	player_machine._integrate_forces(self, state, direction)

func damage(type: String) -> void:
	var fire_timer = Timer.new()
	print(type)
	if type == 'lava':
		if fire_res != true:
			cur_health -= 2
			hud.update_health(cur_health, cur_max_health)
			print(cur_health)
		elif fire_res == true:
			fire_timer.set_wait_time(7.5)
			fire_timer.one_shot = true
			fire_timer.start()
			await fire_timer.timeout
			fire_res = false
	else: return


func dead() -> void:
	gameover.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().set_pause(true)
