class_name PlayerRigid
extends RigidBody3D

## Set basic constent values for movement
const MAX_SPEED = 20
const DEFAULT_SPEED = 14
const JUMP_SPEED = 26
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
@onready var shape : CapsuleShape3D = self.get_node('CollisionShape3D').shape
var mouse_pos : Vector2
var mouse_sensitivity = 1.5
var controller_sensitivity = 0.07

## Variables used for character movement
@onready var player_machine : FiniteStateMachine = get_node('PlayerStateMachine')
@onready var jump_machine : FiniteStateMachine = get_node('JumpStateMachine')

## Variables used for actions
@onready var timer = self.get_node('CoyoteTimer')
var was_on_floor : bool
var is_on_ground : bool

## Define upgrade variables
var fire_res : bool = false
var collision_layers : Array


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	set_collision_layer(pow(2, (21 + id) - 1))
	match id:
		0:
			set_collision_mask(pow(2, (22) - 1) + pow(2, (23) - 1) + pow(2, (24) - 1) + pow(2, 1-1) + pow(2, 2-1) + pow(2, 3-1))
		1:
			set_collision_mask(pow(2, (21) - 1) + pow(2, (23) - 1) + pow(2, (24) - 1) + pow(2, 1-1) + pow(2, 2-1) + pow(2, 3-1))
		2:
			set_collision_mask(pow(2, (21) - 1) + pow(2, (22) - 1) + pow(2, (24) - 1) + pow(2, 1-1) + pow(2, 2-1) + pow(2, 3-1))
		3:
			set_collision_mask(pow(2, (21) - 1) + pow(2, (22) - 1) + pow(2, (23) - 1) + pow(2, 1-1) + pow(2, 2-1) + pow(2, 3-1))

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

func _physics_process(delta):
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
		print(direction)
		player_machine.change_state('PlayerWalk')
	
	var rays : Array = Array()
	var bottom = 0.1
	var start = (shape.height / 2 + shape.radius) - 0.05
	var shape_dist = shape.radius - 0.1
	var squared_dist = shape_dist / sqrt(2.0)
	var dir_state = get_world_3d().direct_space_state
	rays.clear()
	is_on_ground = false
	for i in 9:
		var locat = self.position
		locat.y -= start
		match i:
			0:
				locat.z -= shape_dist
			1:
				locat.z += shape_dist
			2:
				locat.x += shape_dist
			3:
				locat.x -= shape_dist
			4:
				locat.z -= squared_dist
				locat.x += squared_dist
			5:
				locat.z += squared_dist
				locat.x += squared_dist
			6:
				locat.z += squared_dist
				locat.x -= squared_dist
			7:
				locat.z -= squared_dist
				locat.x -= squared_dist
		var locat2 = locat
		locat2.y -= bottom
		rays.append([locat, locat2])
	for array in rays:
		print('rayed')
		var dir_query_params = PhysicsRayQueryParameters3D.create(array[0],array[1], 0x0005)
		var col = dir_state.intersect_ray(dir_query_params)
		if col:
			print('suc')
			is_on_ground = true
	if Input.is_action_just_pressed('player-%s_tool_mouse' % id) && Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED or Input.is_action_just_pressed('player-%s_tool_key' % id):
		## If so starts appropriate function
		get_node('WeaponStateMachine').fire()

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	player_machine._integrate_forces(self, state, direction)
	if Input.is_action_just_pressed('player-%s_jump' % id) && Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		jump_machine.change_state('PlayerJump')
		jump_machine.state.jump(self, 200.5)

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
