class_name Village extends Node2D

@export var _pillage_time_sec: float = 1.0
@export var _village_area: Area2D
@export var _default_sprite: Sprite2D
@export var _pillaged_sprite: Sprite2D

var _is_pillaged: bool = false

func _ready() -> void:
	_connect_signals()
	GameManager.villages_total += 1
	_default_sprite.visible = !_is_pillaged
	_pillaged_sprite.visible = _is_pillaged

func _connect_signals() -> void:
	_village_area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if _is_pillaged:
		return
	
	if body is Player:
		_on_player_entered(body)
		
func _on_player_entered(player: Player) -> void:
	player.can_move = false
	await get_tree().create_timer(_pillage_time_sec).timeout
	_pillage(player)

func _pillage(player: Player) -> void:
	_is_pillaged = true
	_default_sprite.visible = false
	_pillaged_sprite.visible = true
	player.can_move = true
	GameSignalHub.village_pillaged.emit(self)
