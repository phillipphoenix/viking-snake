extends PanelContainer

@export var _pillaged_value_text: Label

func _ready() -> void:
	_connect_signals()
	
func _connect_signals() -> void:
	GameSignalHub.village_pillaged.connect(_on_village_pillaged)
	
func _on_village_pillaged(village: Village) -> void:
	_pillaged_value_text.text = str(GameManager.villages_burned)
