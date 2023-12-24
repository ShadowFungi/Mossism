class_name PlayerFall
extends AirState


@export_category('Fall Options')
@export var fall_timer: Timer

var falling: bool = false

func _ready() -> void:
	fall_timer.timeout.connect(start_fall)

func enter_state():
	super()
	fall_timer.start()
	falling = false

func physics_update(delta: float) -> State:
	if parent.is_on_floor():
		return idle_state
	
	if falling == true:
		parent.velocity.y -= (gravity * parent.mass) * delta
	
	parent.move_and_slide()
	
	return null

func start_fall():
	falling = true
