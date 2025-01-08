extends Marker2D

@export var _win_condition_area: Area2D
@export var _win_area_marker_scene: PackedScene

var _win_area_marker: Node2D

func _ready() -> void:
	_connect_signals()


func _connect_signals() -> void:
	_win_condition_area.body_entered.connect(_on_body_entered)
	GameSignalHub.win_conditions_met.connect(_on_win_conditions_met)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		_on_player_entered(body as Player)

func _on_win_conditions_met() -> void:
	if _win_area_marker == null:
		_win_area_marker = _win_area_marker_scene.instantiate()
		add_child(_win_area_marker)

func _on_player_entered(_player: Player) -> void:
	if GameManager.game.are_win_conditions_met():
		GameSignalHub.player_won.emit()
		print_rich("Player won game! 🎉")
