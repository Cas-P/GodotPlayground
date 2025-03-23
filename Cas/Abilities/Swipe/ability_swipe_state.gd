class_name SwipeState extends AbilityState

@onready var idle: AbilityIdleState = $"../Idle"

var attacking: bool = false
var angle: float = 0.0
var is_action_being_pressed: bool = true
var is_anim_playing: bool = false

var base_cooldown: float = 0
@export var cooldown: float = 0

@export var rotation_offset: float = 0.0
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

func init() -> void:
	base_cooldown = cooldown
	pass

func enter() -> void:
	if state_machine.is_on_gcd or is_on_cooldown:
		attacking = false
	is_action_being_pressed = true
	
	if !animation_player.is_connected("animation_finished", _on_swipe_finish ):
		animation_player.animation_finished.connect(_on_swipe_finish)
		
	var mouse_pos: Vector2 = get_global_mouse_position()
	var mouse_direction = global_position.direction_to(mouse_pos).normalized()
	angle = (mouse_direction + player.cardinal_direction * 0.1).angle()

func exit() -> void:
	animation_player.animation_finished.disconnect(_on_swipe_finish)
	attacking = false
	pass

func process( _delta: float ) -> AbilityState:
	
	if is_action_being_pressed:
		if state_machine.is_on_gcd or is_on_cooldown:
			if is_anim_playing:
				rotation_degrees = rad_to_deg(angle) + rotation_offset
			else:
				return null
		else:
			attacking = true
	
	if !attacking:
		return idle
	
	start_attack()
	rotation_degrees = rad_to_deg(angle) + rotation_offset
	return null

func physics( _delta: float ) -> AbilityState:
	return null

func handle_input( _event: InputEvent ) -> AbilityState:
	if _event.is_action_released("swipe"):
		is_action_being_pressed = false
	if _event.is_action_pressed("swipe"):
		is_action_being_pressed = true
	return null

func _on_swipe_finish(_newAnimName: String) -> void:
	attacking = false
	is_anim_playing = false

func start_attack() -> void:
	if state_machine.is_on_gcd or is_on_cooldown:
		return
		
	ability_started.emit(self)
	state_machine.trigger_gcd()
	animation_player.play("swipe")
	is_anim_playing = true
	var mouse_pos: Vector2 = get_global_mouse_position()
	var mouse_direction = global_position.direction_to(mouse_pos).normalized()
	angle = (mouse_direction + player.cardinal_direction * 0.1).angle()

func reset_cooldown() -> void:
	is_on_cooldown = false
	cooldown = base_cooldown
