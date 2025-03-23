class_name State_Walk extends State

@export var walk_speed: float = 100.0

@onready var idle: State = $"../Idle"
@onready var attack: State = $"../Attack"


func enter() -> void:
	player.UpdateAnimation("walk")


func exit() -> void:
	pass

func process( _delta: float ) -> State:
	if player.direction == Vector2.ZERO:
		return idle
	
	player.velocity = player.direction * walk_speed
	
	if player.SetDirection():
		player.UpdateAnimation("walk")
	
	return null

func physics( _delta: float ) -> State:
	return null

func handle_input( _event: InputEvent ) -> State:
	if _event.is_action_pressed("attack"):
		return attack
	if _event.is_action_pressed("interact"):
		PlayerManager.interact_pressed.emit()
	return null
