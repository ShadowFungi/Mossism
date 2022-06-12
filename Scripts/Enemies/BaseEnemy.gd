extends KinematicBody


enum {
	IDLE,
	ALERT,
	FLEE,
	CHASE,
	STUNNED
}

const GRAVITY = -20
const MAX_SPEED = 24
const DEFAULT_SPEED = 16
const JUMP_SPEED = 24

var state = IDLE

const ACCEL = 6
const DEACCEL= 14

var cur_speed : int
var base_health = 100
var vel = Vector3()
var dir = Vector3()

onready var ray = $EyeMesh/RayCast
onready var hit_area = $HurtArea
