class_name Player extends CharacterBody2D

@export var ground_layer: TileMapLayer

var can_move = true

var _is_moving: bool = false
var _target_pos: Vector2
var _target_walking_speed: float = 1.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
	var current_tile: Vector2i = ground_layer.local_to_map(global_position)
	var target_tile: Vector2i = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y,
	)
	
	var tile_data: TileData = ground_layer.get_cell_tile_data(target_tile)
	if !tile_data:
		return
		
	if !tile_data.get_custom_data("Walkable"):
		return
		
	_is_moving = true
	_target_pos = ground_layer.map_to_local(target_tile)
	_target_walking_speed = tile_data.get_custom_data("WalkingSpeed")

func _physics_process(delta: float) -> void:
	if !_is_moving:
		return
		
	if global_position == _target_pos:
		_is_moving = false
		return
	
	global_position = global_position.move_toward(_target_pos, _target_walking_speed)