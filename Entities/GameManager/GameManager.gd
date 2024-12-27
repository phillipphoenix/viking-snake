extends Node

var game: Game

func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	GameSignalHub.game_over.connect(_on_game_over)
	GameSignalHub.win_conditions_met.connect(_on_win_conditions_met)
	
func _on_game_over() -> void:
	Scenery.switch_to("main_menu")

func _on_win_conditions_met() -> void:
	Scenery.switch_to("level_select")
