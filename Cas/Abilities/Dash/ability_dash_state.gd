class_name AbilityDashState extends AbilityState

@onready var idle: AbilityIdleState = $"../Idle"

var base_cooldown: float = 0
@export var cooldown: float = 0
@export var dash_strength: float = 400
@export var dash_duration: float = 1

var is_dashin: bool = false
var decelerate_speed: float = 10.0
var direction: Vector2 = Vector2.ZERO
var _timer: float = 0

var end_state: bool = false

func init() -> void:
	base_cooldown = cooldown

func enter() -> void:
	if is_on_cooldown:
		end_state = true
	else:
		end_state = false
		_timer = dash_duration
		ability_started.emit(self)
		direction = player.direction
	pass

func exit() -> void:
	pass

func process( _delta: float ) -> AbilityState:
	if end_state:
		return idle
	_timer -= _delta
	if _timer <= 0:
		return idle
	
	player.velocity = direction * dash_strength
	return null

func physics( _delta: float ) -> AbilityState:
	return null

func handle_input( _event: InputEvent ) -> AbilityState:
	return null

func reset_cooldown() -> void:
	is_on_cooldown = false
	cooldown = base_cooldown
