class_name PlayerGroundIdle
extends AirState


@export_category('Jump Options')
@export var coyote_timer: Timer

func _ready() -> void:
	coyote_timer.timeout.connect(timeout)

func enter_state() -> void:
	super()
	coyote_timer.start()

func handle_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('player-%s_jump' % parent.id):
		if parent.is_on_floor() or parent.can_jump:
			parent.can_jump = false
			return jump_state
	return null

func physics_update(delta: float):
	parent.velocity.y -= (gravity * parent.mass) * delta
	parent.move_and_slide()
	if parent.is_on_floor():
		parent.can_jump = true
		coyote_timer.start()

func timeout() -> void:
	if parent.is_on_floor() == false:
		parent.can_jump = false
