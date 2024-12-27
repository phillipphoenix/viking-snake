extends PanelContainer

@export var _pillaged_value_text: Label

func _ready() -> void:
	_connect_signals()
	
func _connect_signals() -> void:
	GameSignalHub.update_score_ui.connect(_update_score_ui)
	
func _update_score_ui() -> void:
	_pillaged_value_text.text = str(GameManager.game.villages_burned)
