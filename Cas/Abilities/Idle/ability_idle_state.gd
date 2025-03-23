class_name AbilityIdleState extends AbilityState
@onready var swipe: SwipeState = $"../Swipe"

func enter() -> void:
	pass

func exit() -> void:
	pass

func process( _delta: float ) -> AbilityState:
	return null

func physics( _delta: float ) -> AbilityState:
	return null

func handle_input( _event: InputEvent ) -> AbilityState:
	if _event.is_action_pressed("swipe"):
		return swipe
	return null
