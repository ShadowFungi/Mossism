extends KinematicBody

const GRAVITY = -16
var vel = Vector3()
const MAX_SPEED = 12
const JUMP_SPEED = 14
const ACCEL = 4.5

var dir = Vector3()

const DEACCEL= 16
const MAX_SLOPE_ANGLE = 60

export (PackedScene) var bullet

onready var world1 = get_parent().get_parent().get_parent().get_node("ViewportContainer/Viewport/ThePit")

export var id = 0

var camera
var rotation_helper

var MOUSE_SENSITIVITY = 0.05

func _ready():
	camera = $pivot/PlayerCamera
	rotation_helper = $pivot

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	process_input(delta)
	process_movement(delta)

func process_input(delta):
	
	# ----------------------------------
	# Walking
	dir = Vector3()
	var cam_xform = camera.get_global_transform()

	var input_movement_vector = Vector2()
	if id != 0:
		if Input.is_action_pressed('player-%s_forward' % id):
			input_movement_vector.y += 1
		if Input.is_action_pressed('player-%s_back' % id):
			input_movement_vector.y -= 1
		if Input.is_action_pressed('player-%s_strafe_left' % id):
			input_movement_vector.x -= 1
		if Input.is_action_pressed('player-%s_strafe_right' % id):
			input_movement_vector.x += 1
		
		if Input.is_action_pressed('player-%s_look_up' % id):
			rotation_helper.rotate_x(deg2rad(25 * MOUSE_SENSITIVITY))

			var camera_rot = rotation_helper.rotation_degrees
			camera_rot.x = clamp(camera_rot.x, -70, 70)
			rotation_helper.rotation_degrees = camera_rot
		if Input.is_action_pressed('player-%s_look_down' % id):
			rotation_helper.rotate_x(deg2rad(-25 * MOUSE_SENSITIVITY))

			var camera_rot = rotation_helper.rotation_degrees
			camera_rot.x = clamp(camera_rot.x, -70, 70)
			rotation_helper.rotation_degrees = camera_rot
		if Input.is_action_pressed('player-%s_look_left' % id):
			self.rotate_y(deg2rad(-25 * MOUSE_SENSITIVITY * -1))
			
			var camera_rot = rotation_helper.rotation_degrees
			camera_rot.x = clamp(camera_rot.x, -70, 70)
			rotation_helper.rotation_degrees = camera_rot
		if Input.is_action_pressed('player-%s_look_right' % id):
			self.rotate_y(deg2rad(25 * MOUSE_SENSITIVITY * -1))
			
			var camera_rot = rotation_helper.rotation_degrees
			camera_rot.x = clamp(camera_rot.x, -70, 70)
			rotation_helper.rotation_degrees = camera_rot

		if Input.is_action_just_pressed('player-%s_shoot' % id):
			var b = bullet.instance()
			world1.add_child(b)
			b.transform = $pivot/PlayerCamera/SawedOff/Muzzle.global_transform
			b.apply_central_impulse(-$pivot/PlayerCamera/SawedOff/Muzzle.global_transform.basis.z * 100)
		
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
		
	else:
		
		if Input.is_action_pressed('keyboard_forward'):
			input_movement_vector.y += 1
		if Input.is_action_pressed('keyboard_back'):
			input_movement_vector.y -= 1
		if Input.is_action_pressed('keyboard_strafe_left'):
			input_movement_vector.x -= 1
		if Input.is_action_pressed('keyboard_strafe_right'):
			input_movement_vector.x += 1

		if Input.is_action_just_pressed('mouse_shoot'):
			var b1 = bullet.instance()
			var b2 = bullet.instance()
			world1.add_child(b1)
			world1.add_child(b2)
			b1.transform.origin.y = $pivot/PlayerCamera/SawedOff/Muzzle.global_transform.origin.y
			b1.transform.origin.x = $pivot/PlayerCamera/SawedOff/Muzzle.global_transform.origin.x + .2
			b1.transform.origin.z = $pivot/PlayerCamera/SawedOff/Muzzle.global_transform.origin.z
			b1.apply_central_impulse(-$pivot/PlayerCamera/SawedOff/Muzzle.global_transform.basis.z * 80)
			b2.transform.origin.y = $pivot/PlayerCamera/SawedOff/Muzzle.global_transform.origin.y
			b2.transform.origin.x = $pivot/PlayerCamera/SawedOff/Muzzle.global_transform.origin.x - .2
			b2.transform.origin.z = $pivot/PlayerCamera/SawedOff/Muzzle.global_transform.origin.z
			b2.apply_central_impulse(-$pivot/PlayerCamera/SawedOff/Muzzle.global_transform.basis.z * 80)
		
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

		# ----------------------------------
		# Capturing/Freeing the cursor
		if Input.is_action_just_pressed('keyboard_cancel'):
			if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		# ----------------------------------

func _input(event):
	if id == 0:
		if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			rotate_y(-event.relative.x * (MOUSE_SENSITIVITY / 15))
			$pivot.rotate_x(-event.relative.y * (MOUSE_SENSITIVITY / 15))
			
			var camera_rot = rotation_helper.rotation_degrees
			camera_rot.x = clamp(camera_rot.x, -70, 70)
			rotation_helper.rotation_degrees = camera_rot

func process_movement(delta):
	dir.y = 0
	dir = dir.normalized()

	vel.y += delta * GRAVITY

	var hvel = vel
	hvel.y = 0

	var target = dir
	target *= MAX_SPEED

	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL

	hvel = hvel.linear_interpolate(target, accel * delta)
	vel.x = hvel.x
	vel.z = hvel.z
	vel = move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))
