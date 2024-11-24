class_name Player extends CharacterBody2D

@export var visual_node: Node2D

var can_move = true

var _base_layer: TileMapLayer
var _is_moving: bool = false
var _target_pos: Vector2
var _target_walking_speed: float = 1.0

func _ready() -> void:
	GameManager.game.player = self
	_base_layer = GameManager.game.level.base_layer

func _process(_delta: float) -> void:
	if !can_move:
		return

	if _is_moving:
		return

	if Input.is_action_pressed("move_up"):
		move(Vector2.UP)
	elif Input.is_action_pressed("move_down"):
		move(Vector2.DOWN)
	elif Input.is_action_pressed("move_left"):
		move(Vector2.LEFT)
	elif Input.is_action_pressed("move_right"):
		move(Vector2.RIGHT)

func move(direction: Vector2) -> void:
	var current_tile: Vector2i = GameManager.game.level.tile_map_local_to_map(global_position)
	var target_tile: Vector2i = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y,
	)

	var is_walkable: bool = GameManager.game.level.get_tile_is_walkable(target_tile)
	if !is_walkable:
		return

	var prev_pos = global_position

	_is_moving = true
	_target_pos = GameManager.game.level.tile_map_map_to_local(target_tile)
	_target_walking_speed = GameManager.game.level.get_tile_walking_speed(target_tile)
	global_position = _target_pos
	visual_node.global_position = prev_pos


func _physics_process(_delta: float) -> void:
	if !_is_moving:
		return

	if visual_node.global_position == _target_pos:
		_is_moving = false
		return

	visual_node.global_position = visual_node.global_position.move_toward(_target_pos, _target_walking_speed)
