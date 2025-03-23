class_name Player extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]
#const LOOK_DIR = ["R", "RD", "D", "LD", "L", "LU", "U", "RU"]
const LOOK_DIR = [Vector2(1,0), Vector2(1,-1), Vector2(0,-1), Vector2(-1,-1), Vector2(-1,0), Vector2(-1,1), Vector2(0,1), Vector2(1,1)]

@onready var ability_machine: AbilityStateMachine = $AbilityMachine
@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var look_animation: AnimationPlayer = $LookAnimation

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var label: Label = $Label

var cardinal_direction: Vector2 = Vector2.DOWN
var look_direction: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO
var mouse_direction: Vector2 = Vector2.ZERO
@onready var swipe: SwipeState = $AbilityMachine/Swipe


func _ready() -> void:
	PlayerManager.player = self
	state_machine.initialize(self)
	ability_machine.initialize(self)

func _process(delta: float) -> void:
	#if swipe:
		#label.text = str(rad_to_deg(swipe.angle)) + "\n" + str(swipe.rotation_offset) + "\n" + str(swipe.rotation_degrees)
	direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized()
	var mouse_pos: Vector2 = get_global_mouse_position()
	mouse_direction = global_position.direction_to(mouse_pos).normalized()
	
	if set_direction():
		update_animation("look")

func _physics_process(delta: float) -> void:
	move_and_slide()

func update_animation(state: String) -> void:
	#animation_player.play(state + "_" + anim_direction())
	if state != "look":
		return
	look_animation.play( state + "_" + anim_direction())

func set_direction() -> bool:
	var look_id: int = int(round((mouse_direction + cardinal_direction * 0.1).angle() / TAU * LOOK_DIR.size()))
	var new_direction: Vector2 = LOOK_DIR[look_id]
	
	if new_direction == cardinal_direction:
		return false
	
	cardinal_direction = new_direction
	return true

func set_looking_direction() -> bool:
	var look_id: int = int(round((mouse_direction + cardinal_direction * 0.1).angle() / TAU * LOOK_DIR.size()))
	var new_look_dir: Vector2 = LOOK_DIR[look_id]
	
	if new_look_dir == look_direction:
		return false
	
	look_direction = new_look_dir
	return true

func anim_direction() -> String:
	if cardinal_direction == Vector2(1,0):
		return "R"
	elif cardinal_direction == Vector2(1,1):
		return "RU"
	elif cardinal_direction == Vector2(0, 1):
		return "U"
	elif cardinal_direction == Vector2(-1,1):
		return "LU"
	elif cardinal_direction == Vector2(-1,0):
		return "L"
	elif cardinal_direction == Vector2(-1,-1):
		return "LD"
	elif cardinal_direction == Vector2(0,-1):
		return "D"
	elif cardinal_direction == Vector2(1,-1):
		return "RD"
	return ""

#func anim_look_direction() -> String:
	#if look_direction == Vector2(1,0):
		#return "R"
	#elif look_direction == Vector2(1,1):
		#return "RU"
	#elif look_direction == Vector2(0, 1):
		#return "U"
	#elif look_direction == Vector2(-1,1):
		#return "LU"
	#elif look_direction == Vector2(-1,0):
		#return "L"
	#elif look_direction == Vector2(-1,-1):
		#return "LD"
	#elif look_direction == Vector2(0,-1):
		#return "D"
	#elif look_direction == Vector2(1,-1):
		#return "RD"
	#return ""
