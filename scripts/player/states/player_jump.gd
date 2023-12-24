class_name PlayerJump
extends AirState


var gravity_scale_old

@export_category('Jump Options')
@export var jump_height: float = 35
@export var coyote_timer: Timer

func enter_state():
	super()
	parent.velocity.y += jump_height
	parent.can_jump = false

func physics_update(delta: float) -> State:
	parent.velocity.y -= (gravity * parent.mass) * delta
	
	if parent.velocity.y < 0:
		return fall_state
	
	parent.move_and_slide()
	
	return null
