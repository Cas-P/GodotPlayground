extends CanvasLayer

signal shown
signal hidden

@onready var button_save: Button = $Control/VBoxContainer/Button_Save
@onready var button_load: Button = $Control/VBoxContainer/Button_Load
@onready var item_description: Label = $Control/ItemDescription
@onready var audio_stream_player: AudioStreamPlayer = $Control/AudioStreamPlayer

var is_paused: bool = false


func _ready() -> void:
	hide_pause_menu()
	button_load.pressed.connect(_on_load_pressed)
	button_save.pressed.connect(_on_save_pressed)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if !is_paused:
			show_pause_menu()
		else:
			hide_pause_menu()
		get_viewport().set_input_as_handled()


func show_pause_menu() -> void:
	shown.emit()
	get_tree().paused = true
	visible = true
	is_paused = true

func hide_pause_menu() -> void:
	hidden.emit()
	get_tree().paused = false
	visible = false
	is_paused = false

func _on_save_pressed() -> void:
	if !is_paused:
		return
	SaveManager.save_game()
	hide_pause_menu()

func _on_load_pressed() -> void:
	if !is_paused:
		return
	SaveManager.load_game()
	await LevelManager.level_load_started
	hide_pause_menu()

func update_item_description(new_text: String):
	item_description.text = new_text


func play_audio(audio: AudioStream) -> void:
	audio_stream_player.stream = audio
	audio_stream_player.play()
