class_name Player
extends CharacterBody3D


const BASE_SPEED = 12.0
const WALKING_MODIFIER = 1.45
const RUNNING_MODIFIER = 1.98
const CROUCHING_MODIFIER = 0.65
const CANNONBALL_MODIFIER = 1.55
const JUMP_VELOCITY = 16.25

const MAX_HEALTH = 20000
const DEFAULT_HEALTH = 500
const MIN_HEALTH = 1


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var min_pitch: float = -55.0
var max_pitch: float = 80.0

var min_yaw: float = 0
var max_yaw: float = 360

var mouse_pos: Vector2

var active_object: Array = []

var can_step_up: bool = false
var can_snap_down: bool = true
var is_grounded: bool = false
var was_grounded: bool = false

var smooth_step: bool = false

var cur_health: float = DEFAULT_HEALTH
var cur_max_health: float = DEFAULT_HEALTH
var max_available_health: int = 10
var health: int = 10
var fire_res: bool = false
var running: bool = false

var joypad_rotation_mult: float = 180.0 * PI / 90.0


## Movement HSM
@onready var movement_hsm: LimboHSM = get_node('MovementHSM')
@onready var idle_state: LimboState = get_node('MovementHSM/PlayerIdleState')
@onready var walk_state: LimboState = get_node('MovementHSM/PlayerWalkingState')
@onready var run_state: LimboState = get_node('MovementHSM/PlayerRunningState')

## Jumping HSM
@onready var elevation_hsm: LimboHSM = get_node('ElevationHSM')
@onready var jump_state: LimboState = get_node('ElevationHSM/PlayerJumpState')
@onready var coyote_state: LimboState = get_node('ElevationHSM/PlayerCoyoteState')
@onready var fall_state: LimboState = get_node('ElevationHSM/PlayerFallState')
@onready var grounded_state: LimboState = get_node('ElevationHSM/PlayerGroundedState')
@onready var ledge_state: LimboState = get_node('ElevationHSM/PlayerLedgeGrabState')

## Height HSM
@onready var height_hsm: LimboHSM = get_node('HeightHSM')
@onready var standing_state: LimboState = get_node('HeightHSM/PlayerStandingState')
@onready var crouch_state: LimboState = get_node('HeightHSM/PlayerCrouchingState')

## Pain HSM
@onready var pain_hsm: LimboHSM = get_node('PainHSM')

#@onready var state_chart: StateChart = get_node('StateChart')
@export var pcam: PhantomCamera3D
@export var interact_label: Label
@export var id: int = 1
@export var pivot: Node3D
@export var skel: Skeleton3D
@export var look_pivot: Node3D
@export var sawed_off: Node3D
@export var step_detect: RayCast3D
@export var ground_ray: RayCast3D
@export var step_shape: ShapeCast3D
@export var hud: Control
@export var gameover: Control
@export var max_step_up : float = 0.5
@export var max_step_down : float = -0.5

func get_input_dir() -> Vector2:
	var input_dir = Input.get_vector(
		'analog--strafe_left',
		'analog--strafe_right',
		'analog--forward',
		'analog--backward',
		).normalized()
	return input_dir

func get_camera_dir() -> Vector2:
	var camera_dir = ((Input.get_vector(
		'analog--camera_down',
		'analog--camera_up',
		'analog--camera_right',
		'analog--camera_left'
		) * SFInputRemapper.joypad_sensitivity) * joypad_rotation_mult)
	return camera_dir

func _timeline_ended():
	toggle_mouse_lock()
	elevation_hsm.set_active(true)
	movement_hsm.set_active(true)
	height_hsm.set_active(true)

func _ready() -> void:
	get_node("Camera3D").make_current()
	#skel.set_bone_enabled(3, true)
	SFInputRemapper.mouse_sensitivity = 0.15
	SFInputRemapper.load_example_map()
	toggle_mouse_lock()
	_init_movement_hsm()
	_init_elevation_hsm()
	_init_height_hsm()
#	pain_hsm._init_hsm()
#	pain_hsm.set_active(true)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		toggle_mouse_lock(true, true)
	if event.is_action_pressed('pause_native'):
		get_node('PauseMenu').pause()
		set_process_input(true)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED && id == 1:
		if event is InputEventMouseMotion:
			mouse_pos = (event.relative * SFInputRemapper.mouse_sensitivity)
			pivot.rotate_x(-deg_to_rad(mouse_pos.y))
			pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(min_pitch), deg_to_rad(max_pitch))
			rotate_y(-deg_to_rad(mouse_pos.x))
	if Input.is_action_just_pressed('analog--tool'.format({'n':1})) and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		sawed_off.fire()
	elif Input.is_action_just_pressed('analog--tool'.format({'n':1})):
		toggle_mouse_lock()


func _physics_process(delta: float):
	_pre_phys_proc()
	_post_phys_proc.call_deferred()


func _pre_phys_proc():
	if pain_hsm.current_health <= 0:
		gameover.died()
		toggle_mouse_lock(true, false)
	if abs(get_camera_dir().y) >= 0.01 or abs(get_camera_dir().x) >= 0.01:
		var camera_pos = get_camera_dir()
		pivot.rotation.x += deg_to_rad(camera_pos.x)
		pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(min_pitch), deg_to_rad(max_pitch))
		rotation.y += deg_to_rad(camera_pos.y)
	
	was_grounded = is_grounded
	
	if is_on_floor():
		is_grounded = true
	else:
		is_grounded = false


func _post_phys_proc():
	#if velocity.x == 0 or velocity.z == 0:
	#	step_shape.enabled = false
	#else:
	#	step_shape.enabled = true
	#step_shape.look_at(Vector3(global_transform.origin.x + velocity.x, global_transform.origin.y, global_transform.origin.z + velocity.z), Vector3(0, 0, 1))
	move_and_slide()
	#if !is_on_floor():
	#	can_snap_down = true


func toggle_mouse_lock(forced: bool = false, locked: bool = false):
	if forced == false:
		match Input.mouse_mode:
			Input.MOUSE_MODE_VISIBLE:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			Input.MOUSE_MODE_CAPTURED:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		return
	if forced == true:
		match locked:
			true:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			false:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		return


func _init_movement_hsm() -> void:
	movement_hsm.add_transition(idle_state, walk_state, &'walk_started')
	movement_hsm.add_transition(walk_state, idle_state, &'walk_ended')
	movement_hsm.add_transition(walk_state, run_state, &'run_started')
	movement_hsm.add_transition(run_state, walk_state, &'run_ended')
	movement_hsm.initial_state = idle_state
	movement_hsm.initialize(self)
	movement_hsm.set_active(true)


func _init_elevation_hsm() -> void:
	elevation_hsm.add_transition(fall_state, grounded_state, &'grounded')
	elevation_hsm.add_transition(fall_state, ledge_state, &'grab_started')
	elevation_hsm.add_transition(jump_state, fall_state, &'jump_end')
	elevation_hsm.add_transition(grounded_state, jump_state, &'jump_started')
	elevation_hsm.add_transition(grounded_state, coyote_state, &'ground_lost')
	elevation_hsm.add_transition(coyote_state, fall_state, &'coyote_ended')
	elevation_hsm.add_transition(coyote_state, jump_state, &'jump_started')
	elevation_hsm.add_transition(ledge_state, jump_state, &'jump_started')
	elevation_hsm.add_transition(ledge_state, fall_state, &'grab_ended')
	elevation_hsm.initial_state = fall_state
	elevation_hsm.initialize(self)
	elevation_hsm.set_active(true)


func _init_height_hsm() -> void:
	height_hsm.add_transition(standing_state, crouch_state, &'crouch_started')
	height_hsm.add_transition(crouch_state, standing_state, &'crouch_ended')
	height_hsm.initial_state = standing_state
	height_hsm.initialize(self)
	height_hsm.set_active(true)


func _on_area_3d_area_entered(area: Area3D) -> void:
	active_object.append(area)
	area.interact_icon.show()
	interact_label.text = area.hover_text


func _on_area_3d_area_exited(area: Area3D) -> void:
	active_object.erase(area)
	area.interact_icon.hide()
	interact_label.set_text("")


func damage(type: String) -> void:
	pain_hsm.damage_type = type


func update_health(new_health: int, max_health: int) -> void:
	#hud.update_health(new_health, max_health)
	pass
