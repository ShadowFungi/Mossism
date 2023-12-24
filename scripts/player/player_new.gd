class_name Player
extends CharacterBody3D


@export_category('Player info')
@export var id : int = 1
@export var mass : float = 8
@export var current_health : int = 500

@export_category('Node Dependencies')
@export var camera : Camera3D
@export var pivot : Node3D

@export_group('Timers')
@export var ragdoll_timer : Timer
@export var coyote_timer : Timer
@export var jump_timer : Timer

@export_group('GUI')
@export var heads_up_display : Control

@export_group('Animation')
@export var animator: AnimationPlayer

@export_group('State Machines')
@export var player_machine : FiniteStateMachine
@export var weapon_machine : FiniteStateMachine
@export var look_machine : FiniteStateMachine
@export var health_machine : FiniteStateMachine
@export var damage_machine : FiniteStateMachine
@export var jump_machine : FiniteStateMachine

var can_jump: bool = true
#@onready var ground_cast : ShapeCast3D = get_node('GroundedCast')
#
### Variables used for actions
#@onready var timer = self.get_node('CoyoteTimer')
#var was_on_floor : bool
#
### Define upgrade variables
#var fire_res : bool = false
#var collision_layers : Array


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	player_machine.init(self, id)
	weapon_machine.init(self, id)
	look_machine.init(self, id)
	health_machine.init(self, id)
	damage_machine.init(self, id)
	jump_machine.init(self, id)

func _unhandled_input(event: InputEvent) -> void:
	player_machine.handle_input(event)
	weapon_machine.handle_input(event)
	look_machine.handle_input(event)
	jump_machine.handle_input(event)

func _process(delta: float) -> void:
	player_machine.frame_update(delta)
	weapon_machine.frame_update(delta)
	look_machine.frame_update(delta)
	health_machine.frame_update(delta)
	damage_machine.frame_update(delta)
	jump_machine.frame_update(delta)

func _physics_process(delta: float) -> void:
	player_machine.physics_update(delta)
	weapon_machine.physics_update(delta)
	look_machine.physics_update(delta)
	health_machine.physics_update(delta)
	damage_machine.physics_update(delta)
	jump_machine.physics_update(delta)
#	if cur_health <= 0:
#		dead()

func damage(type: String) -> void:
	damage_machine.do_damage = true

#func damage(type: String) -> void:
#	var fire_timer = Timer.new()
#	print(type)
#	if type == 'lava':
#		if fire_res != true:
#			cur_health -= 2
#			hud.update_health(cur_health, cur_max_health)
#			print(cur_health)
#		elif fire_res == true:
#			fire_timer.set_wait_time(7.5)
#			fire_timer.one_shot = true
#			fire_timer.start()
#			await fire_timer.timeout
#			fire_res = false
#	else: return
#
#func dead() -> void:
#	gameover.show()
#	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#	get_tree().set_pause(true)
