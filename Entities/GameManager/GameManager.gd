extends Node

var villages_burned: int = 0

func _ready() -> void:
	_connect_signals()
	reset()

func reset() -> void:
	villages_burned = 0

func _connect_signals() -> void:
	GameSignalHub.village_pillaged.connect(_on_village_pillaged)
	
func _on_village_pillaged(village: Village) -> void:
	villages_burned += 1
