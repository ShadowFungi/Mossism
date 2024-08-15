extends LimboHSM

@export_category("Dependencies")
@export var holder: CharacterBody3D 
@export var health_label: Label
@export var health_bar: Node3D
@export_category("Options")
@export var health: int = 500
@export var current_health: int = 500
@export var current_max_health: int = 500
@export var fire_res: bool = false
@export var fire_damage_multiplier: int = 1

@onready var safe_state: LimboState = get_node('SafeState')
@onready var fire_state: LimboState = get_node('FireState')
@onready var explosion_state: LimboState = get_node('ExplosionState')
@onready var bullet_state: LimboState = get_node('BulletState')
@onready var melee_state: LimboState = get_node('MeleeState')
@onready var poison_state: LimboState = get_node('PoisonState')
@onready var bleed_state: LimboState = get_node('BleedState')

var take_damage: bool = false
var damage_type: String = 'none' 
var damage_multiplier: int = 1 
var damage_additional: int = 0 


func _ready() -> void:
	_init_hsm()


func _init_hsm() -> void:
	add_transition(ANYSTATE, safe_state, &'pain_stopped')
	add_transition(explosion_state, fire_state, &'caught_fire')
	add_transition(safe_state, fire_state, &'caught_fire')
	add_transition(safe_state, explosion_state, &'exploded')
	add_transition(safe_state, bullet_state, &'shot')
	add_transition(safe_state, melee_state, &'slashed')
	add_transition(safe_state, poison_state, &'illness')
	add_transition(safe_state, bleed_state, &'stabbed')
	initial_state = safe_state
	initialize(get_parent())
	set_active(true)


func _process(_delta: float) -> void:
	if current_health != health:
		health = current_health
		#print(current_health)
		update_health(health, current_max_health)


func update_health(new_health: int, max_health: int = current_max_health) -> void:
	print(new_health)
	if health_label == null:
		health_bar.set_text('%d' % new_health + "/%d" % max_health)
	else:
		health_label.set_text('%d' % new_health + "/%d" % max_health)
	if holder.is_in_group('enemy') and new_health <= 0:
		await get_tree().create_timer(0.2, false).timeout
		holder.queue_free()
