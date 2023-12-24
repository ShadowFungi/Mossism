extends CharacterBody3D


## Define enum for state machine
enum States {
	GROUNDED,
	IN_AIR,
	IDLE,
	WALKING,
	CLIMBING,
	JUMPING
}

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
var cur_speed = 14
var gravity = 24.5

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
@onready var snap_detect = self.get_node('SnapDetection')
@onready var step_detect = self.get_node('StepDetection')
@onready var stair_timer = self.get_node('StairTimer')
var timer_start_from : String
## Get PauseMenu node
@onready var pause_menu = self.get_node("PauseMenu")
@onready var gameover = self.get_node("GameOver")
## Preload the weapon projectile scene(s)
@onready var sawed_off_bullet = preload("res://nodes/player/SawedOffBullet.tscn")

## Export the player ID so it can be changed when needed
@export var id : int = 0

## Variables used for camera movement 
@onready var pivot := self.get_node("Pivot")
@onready var camera := self.get_node("Pivot/Camera3D")
var mouse_pos = 0
var mouse_sensitivity = 0.01
var controller_sensitivity = 0.07

## Variables used for actions
@onready var timer = self.get_node("CoyoteTimer")
var was_on_floor

## Define Variables for state machine
var state : int = States.GROUNDED

## Define upgrade variables
var fire_res : bool = false


func _ready() -> void:
	sawed_off_bullet.instantiate()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#	elif event.is_action_pressed('player-%s_pause' % id):
#		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event.is_action_pressed('player-%s_pause' % id):
		get_node("PauseMenu").pause()
		set_process_input(true)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			self.rotate_y(-event.relative.x * mouse_sensitivity)
			pivot.rotate_x(-event.relative.y * mouse_sensitivity)
			pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-80), deg_to_rad(75))

func _physics_process(delta):
	if cur_health <= 0:
		dead()
	## Add the gravity.
	if !is_on_floor() and state != States.CLIMBING:
		velocity.y -= gravity * delta + 0.1
	
	## Handle Jump.
	if Input.is_action_just_pressed('player-%s_jump' % id):
		if is_on_floor() or !timer.is_stopped():
			can_snap_down = false
			velocity.y = JUMP_SPEED * (delta + 0.75)
		state = States.JUMPING
	
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
		can_snap_down = true
	else:
		was_on_floor = false
	
	var direction
	
	direction = (self.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if state == States.CLIMBING:
		direction.y = input_dir.y
		direction.z = 0
	
	if input_dir.x == 0 and input_dir.y == 0:
		step_detect.rotation.y = deg_to_rad(0.0)
	
	## Check if a direction is available for movement
	if direction:
		## Apply velocity for horizontal movement
		velocity.x = direction.x * cur_speed
		if state == States.CLIMBING:
			velocity.y = -direction.y * cur_speed
		else: velocity.z = direction.z * cur_speed
		
		if input_dir.x > 0:
			if input_dir.y > 0:
				step_detect.rotation.y = deg_to_rad(225.0)
			if input_dir.y < 0:
				step_detect.rotation.y = deg_to_rad(325.0)
			if input_dir.y == 0:
				step_detect.rotation.y = deg_to_rad(270.0)
		if input_dir.x < 0:
			if input_dir.y > 0:
				step_detect.rotation.y = deg_to_rad(125.0)
			if input_dir.y < 0:
				step_detect.rotation.y = deg_to_rad(25.0)
			if input_dir.y == 0:
				step_detect.rotation.y = deg_to_rad(90.0)
		if input_dir.y > 0:
			if input_dir.x > 0:
				step_detect.rotation.y = deg_to_rad(225.0)
			if input_dir.x < 0:
				step_detect.rotation.y = deg_to_rad(125.0)
			if input_dir.x == 0:
				step_detect.rotation.y = deg_to_rad(180.0)
		if input_dir.y < 0:
			if input_dir.x > 0:
				step_detect.rotation.y = deg_to_rad(325.0)
			if input_dir.x < 0:
				step_detect.rotation.y = deg_to_rad(25.0)
			if input_dir.x == 0:
				step_detect.rotation.y = deg_to_rad(0.0)
				
	else:
		## Neutralize movement otherwise
		velocity.x = move_toward(velocity.x, 0, cur_speed)
		velocity.z = move_toward(velocity.z, 0, cur_speed)
		
		## Check if player is climbing
		if state == States.CLIMBING:
			velocity.y = 0
		
	
	## Check if the player is trying to use a tool
	if Input.is_action_just_pressed('player-%s_tool_mouse' % id) && Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED or Input.is_action_just_pressed('player-%s_tool_key' % id):
		## If so starts appropriate function
		fire()
		velocity += pivot.global_transform.basis.z * 2
	
	## Apply movement
	move_and_slide()
	
	## Start timer for coyote time
	if was_on_floor and !is_on_floor():
		timer.start()
	
	snap_down()


func fire():
	## Prepare sawed_off_bullet instances
	var shot1 = sawed_off_bullet.instantiate()
	var shot2 = sawed_off_bullet.instantiate()
	
	## Add sawed_off_bullet instances to the world
	get_tree().root.get_node("/root/SplitScreen/GridContainer/SubViewportContainer/SubViewport/NavigationRegion3D").add_child(shot1)
	get_tree().root.get_node("/root/SplitScreen/GridContainer/SubViewportContainer/SubViewport/NavigationRegion3D").add_child(shot2)
	
	## Set sawed_off_bullets to appropriate position1
	shot1.transform = camera.get_node("SawedOffBody/SawedOff/Muzzle").global_transform.translated(Vector3(0.2, 0, 0))
	shot2.transform = camera.get_node("SawedOffBody/SawedOff/Muzzle").global_transform.translated(Vector3(-0.2, 0, 0))
	
	## FIRE!
	## Launch sawed_off_bullets through a central impulse
	shot1.apply_central_impulse(-camera.get_node("SawedOffBody/SawedOff/Muzzle").global_transform.basis.z * 80)
	shot2.apply_central_impulse(-camera.get_node("SawedOffBody/SawedOff/Muzzle").global_transform.basis.z * 80)

func snap_down():
	if !is_on_floor():
		if can_snap_down == true:
			can_step_up = false
			if snap_detect.is_colliding() == true:
				var body = snap_detect
				if body.get_collider().is_in_group("ground") or body.get_collider().is_in_group("wall"):
					#print("group")
					if body.get_collider().get_child(0).get_aabb().size.y <= 1.5:
						if global_position.distance_to(body.get_collision_point()) > 3.25 and global_position.distance_to(body.get_collision_point()) < 3.9:
							global_position = global_position.move_toward(body.get_collision_point(), 0.2)
			stair_timer.start()
			timer_start_from = "down"

func step_up(body: Node3D) -> void:
	if can_step_up == true:
		can_snap_down = false
		var step = body
		#print(step.get_child(0).get_aabb().size.y)
		if body.is_in_group("ground") or body.is_in_group("wall"):
			if step.get_child(0).get_aabb().size.y <= 1.25:
				global_position.y = global_position.move_toward(step.global_position, 0.2).y + 0.75
			#translate_object_local(Vector3(-step.global_transform.basis.z.x, -step.global_transform.basis.z.y, -step.global_transform.basis.z.z / 1.75))
			## Might be useful // saving for later
			#translate_object_local(Vector3(-step.global_transform.basis.z * 3)
		stair_timer.start()
		timer_start_from = "up"

func _on_stair_timer_timeout() -> void:
	if timer_start_from == "up":
		can_snap_down = true
	if timer_start_from == "down":
		can_step_up = true


func damage(type: String) -> void:
	var fire_timer = Timer.new()
	print(type)
	if type == "lava":
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


func change_state(new_state: int) -> void:
	var old_state := state
	state = new_state
	
	match state:
		States.GROUNDED:
			cur_speed = DEFAULT_SPEED
		States.IN_AIR:
			cur_speed = JUMP_SPEED
