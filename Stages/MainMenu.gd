extends Control

@export var _play_button: Button
@export var _quit_button: Button

func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	_play_button.pressed.connect(_on_play)
	_quit_button.pressed.connect(_on_quit)

func _on_play() -> void:
	Scenery.switch_to("level_select")

func _on_quit() -> void:
	get_tree().quit()
