extends KinematicBody

const GRAVITY = -20
var vel = Vector3()
const MAX_SPEED = 20
const DEFAULT_SPEED = 14
const JUMP_SPEED = 18
const ACCEL = 4.5
const MAX_HEALTH = 50
const DEFAULT_HEALTH = 10
const MIN_HEALTH = 1

var cur_speed = 14
var cur_health : int
var max_available_health : int = 10

var dir = Vector3()
 
const DEACCEL= 16
const MAX_SLOPE_ANGLE = 65

var health = 10

var pause_menu

onready var bullet = preload("res://Scenes/Entities/Player/Bullet.tscn")

var world1

export var id = 0

var camera
var rotation_helper

var MOUSE_SENSITIVITY = 0.05
var CONTROLLER_SENSITIVITY = 0.07

var timer

func _ready():
	world1 = get_tree().root.get_node("Node/ViewContainer/ViewportContainer/Viewport/ThePit")
	pause_menu = get_node("PauseMenu")
	timer = pause_menu.get_node("Timer")
	camera = $pivot/PlayerCamera
	rotation_helper = $pivot

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	process_input(delta)
	process_movement(delta)
	update_health()

func process_input(delta):
	
	# ----------------------------------
	# Walking
	dir = Vector3()
	var cam_xform = camera.get_global_transform()

	var input_movement_vector = Vector2()
	if id >= 0:
		if Input.is_action_pressed('player-%s_forward' % id):
			input_movement_vector.y += 1
		if Input.is_action_pressed('player-%s_back' % id):
			input_movement_vector.y -= 1
		if Input.is_action_pressed('player-%s_strafe_left' % id):
			input_movement_vector.x -= 1
		if Input.is_action_pressed('player-%s_strafe_right' % id):
			input_movement_vector.x += 1
		
		if Input.is_action_pressed('player-%s_look_up' % id):
			rotation_helper.rotate_x(deg2rad(25 * CONTROLLER_SENSITIVITY))

			var camera_rot = rotation_helper.rotation_degrees
			camera_rot.x = clamp(camera_rot.x, -80, 80)
			rotation_helper.rotation_degrees = camera_rot
		if Input.is_action_pressed('player-%s_look_down' % id):
			rotation_helper.rotate_x(deg2rad(-25 * CONTROLLER_SENSITIVITY))

			var camera_rot = rotation_helper.rotation_degrees
			camera_rot.x = clamp(camera_rot.x, -80, 80)
			rotation_helper.rotation_degrees = camera_rot
		if Input.is_action_pressed('player-%s_look_left' % id):
			self.rotate_y(deg2rad(-25 * CONTROLLER_SENSITIVITY * -1))
			
			var camera_rot = rotation_helper.rotation_degrees
			camera_rot.x = clamp(camera_rot.x, -80, 80)
			rotation_helper.rotation_degrees = camera_rot
		if Input.is_action_pressed('player-%s_look_right' % id):
			self.rotate_y(deg2rad(25 * CONTROLLER_SENSITIVITY * -1))
			
			var camera_rot = rotation_helper.rotation_degrees
			camera_rot.x = clamp(camera_rot.x, -80, 80)
			rotation_helper.rotation_degrees = camera_rot

		if Input.is_action_just_pressed('player-%s_shoot' % id):
			fire()
		
		input_movement_vector = input_movement_vector.normalized()
		
		# Basis vectors are already normalized.
		dir += -cam_xform.basis.z * input_movement_vector.y
		dir += cam_xform.basis.x * input_movement_vector.x
		# ----------------------------------

		# ----------------------------------
		# Jumping
		if is_on_floor():
			if Input.is_action_just_pressed('player-%s_jump' % id):
				vel.y = JUMP_SPEED
		# ----------------------------------

		# ----------------------------------
		# Capturing/Freeing the cursor
		if Input.is_action_just_pressed('player-%s_ui_cancel' % id):
			if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		# ----------------------------------
		
	if id == 0:
		
		if Input.is_action_pressed("keyboard_sprint"):
			cur_speed = 18
		else:
			cur_speed = DEFAULT_SPEED
		if Input.is_action_pressed('keyboard_forward'):
			input_movement_vector.y += 1
		if Input.is_action_pressed('keyboard_back'):
			input_movement_vector.y -= 1
		if Input.is_action_pressed('keyboard_strafe_left'):
			input_movement_vector.x -= 1
		if Input.is_action_pressed('keyboard_strafe_right'):
			input_movement_vector.x += 1

		if Input.is_action_just_pressed('mouse_shoot'):
			fire()
			input_movement_vector = -get_node("pivot").global_transform.basis.y * 1.05
		
		input_movement_vector = input_movement_vector.normalized()
		
		# Basis vectors are already normalized.
		dir += -cam_xform.basis.z * input_movement_vector.y
		dir += cam_xform.basis.x * input_movement_vector.x
		# ----------------------------------

		# ----------------------------------
		# Jumping
		if is_on_floor():
			if Input.is_action_just_pressed('keyboard_jump'):
				vel.y = JUMP_SPEED
		# ----------------------------------
		
		# Capturing/Freeing the cursor
		if Input.is_action_just_pressed('keyboard_cancel'):
			pause_menu.visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().paused = true
			timer.one_shot = true
			timer.wait_time = 1
			timer.start()
		# ----------------------------------

func _input(event):
	if id == 0:
		if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			rotate_y(-event.relative.x * (MOUSE_SENSITIVITY / 15))
			$pivot.rotate_x(-event.relative.y * (MOUSE_SENSITIVITY / 15))
			
			var camera_rot = rotation_helper.rotation_degrees
			camera_rot.x = clamp(camera_rot.x, -80, 80)
			rotation_helper.rotation_degrees = camera_rot

func process_movement(delta):
	dir.y = 0
	dir = dir.normalized()
	if cur_speed != DEFAULT_SPEED:
		vel.y += GRAVITY * (delta * (1.2 * (cur_speed / 14.5 )))
	else:
		vel.y += GRAVITY * (delta * 1.2)
		
	var hvel = vel
	hvel.y = 0
	
	var target = dir
	target *= cur_speed
	
	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL
	
	hvel = hvel.linear_interpolate(target, accel * delta)
	vel.x = hvel.x
	vel.z = hvel.z
	vel = move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))

func fire():
	var b1 = bullet.instance()
	world1.add_child(b1)
	b1.transform = $pivot/PlayerCamera/SawedOff/Muzzle.global_transform.translated(Vector3(0.2, 0, 0))
	b1.apply_central_impulse(-$pivot/PlayerCamera/SawedOff/Muzzle.global_transform.basis.z * 100)
	var b2 = bullet.instance()
	world1.add_child(b2)
	b2.transform = $pivot/PlayerCamera/SawedOff/Muzzle.global_transform.translated(-Vector3(0.2, 0, 0))
	b2.apply_central_impulse(-$pivot/PlayerCamera/SawedOff/Muzzle.global_transform.basis.z * 100)

func update_health():
	var health_label = get_node("Hud/Panel/HealthLabel")
	health_label.text = String(cur_health) + "/" + String(max_available_health)

func _on_player_entered(area):
	pass # Replace with function body.
