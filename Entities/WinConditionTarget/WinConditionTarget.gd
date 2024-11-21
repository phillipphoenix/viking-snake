extends Marker2D

@export var _win_condition_area: Area2D

func _ready() -> void:
	_connect_signals()


func _connect_signals() -> void:
	_win_condition_area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		_on_player_entered(body as Player)

func _on_player_entered(_player: Player) -> void:
	if GameManager.are_win_conditions_met():
		GameSignalHub.win_conditions_met.emit()
		print_rich("Win conditions met! 🎉")
