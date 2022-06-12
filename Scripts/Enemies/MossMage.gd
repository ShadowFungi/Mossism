extends "res://Scripts/Enemies/BaseEnemy.gd"

var space_state
var entered
var target

onready var eyes = $Eyes
onready var shootTimer = $ShootTimer

const TURN_SPEED = 2

func _ready():
	space_state = get_world().direct_space_state


func _on_Area_body_entered(body):
	entered = true


func _on_Area_body_exited(body):
	entered = false


func _on_FleeArea_body_entered(body):
	if body.is_in_group("Player"):
		state = FLEE
		target = body
		shootTimer.stop()


func _on_FleeArea_body_exited(body):
	if body.is_in_group("Player"):
		state = ALERT


func _on_AlertArea_body_entered(body):
	if body.is_in_group("Player"):
		state = ALERT
		target = body
		shootTimer.start()


func _on_AlertArea_body_exited(body):
	if body.is_in_group("Player"):
		state = CHASE


func _on_ChaseArea_body_entered(body):
	if body.is_in_group("Player"):
		state = CHASE
		target = body


func _on_ChaseArea_body_exited(body):
	if body.is_in_group("Player"):
		if state != IDLE:
			state = IDLE
			shootTimer.stop()


func _on_ShootTimer_timeout():
	if ray.is_colliding():
		var hit = ray.get_collider()
		if hit.is_in_group("Player"):
			print("hit")
			randomize()
			var rand = rand_range(1, 2.5)
			shootTimer.set_wait_time(rand)


func _process(delta):
	
	if ray.is_colliding():
		state = ALERT
	
	elif entered:
		state = STUNNED
	
	match state:
		IDLE:
			pass
		ALERT:
			eyes.look_at(target.global_transform.origin, Vector3.UP)
			rotate_y(deg2rad(eyes.rotation.y * TURN_SPEED))
		FLEE:
			pass
		CHASE:
			pass
		STUNNED:
			pass

