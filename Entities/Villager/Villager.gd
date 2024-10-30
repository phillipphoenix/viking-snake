class_name Villager extends CharacterBody2D

@export var _villager_sprites: Array[Texture2D] = []
@export var _sprite: Sprite2D
@export var visual_node: Node2D

var base_layer: TileMapLayer

var _is_moving: bool = false
var _target_pos: Vector2
var _target_walking_speed: float = 1.0

func _ready() -> void:
	if _villager_sprites.size() > 0:
		_sprite.texture = _villager_sprites.pick_random()


func _on_move_timer_timeout() -> void:
	var current_tile: Vector2i = base_layer.local_to_map(global_position)
	var player_pos = GameManager.player.global_position
	var player_tile: Vector2i = base_layer.local_to_map(player_pos)
	var path = GameManager.astar_grid.get_id_path(current_tile, player_tile)

	# First tile in path is current tile.
	# So if the path size is 1 or below, the villager is at target position.
	if path.size() < 2:
		return

	var target_tile = path[1]
	
	var tile_data: TileData = base_layer.get_cell_tile_data(target_tile)
	if !tile_data:
		return
		
	if !tile_data.get_custom_data("Walkable"):
		return
	
	# When moving, only the visual layer is animated.
	# We do this by moving the player, but setting the visual node back to the previous position
	# and then animating it to the current one.
	var prev_pos = global_position

	_is_moving = true
	_target_pos = base_layer.map_to_local(target_tile)
	_target_walking_speed = tile_data.get_custom_data("WalkingSpeed")
	global_position = _target_pos
	visual_node.global_position = prev_pos
	

func _physics_process(delta: float) -> void:
	if !_is_moving:
		return
		
	if visual_node.global_position == _target_pos:
		_is_moving = false
		return
	
	visual_node.global_position = visual_node.global_position.move_toward(_target_pos, _target_walking_speed)
