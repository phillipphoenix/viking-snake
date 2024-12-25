extends Node

var game: Game

func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	GameSignalHub.game_over.connect(_on_game_over)
	pass
	
func _on_game_over() -> void:
	Scenery.switch_to("main_menu")
