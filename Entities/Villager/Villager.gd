class_name Villager extends Node2D

@export var _villager_sprites: Array[Texture2D] = []
@export var _sprite: Sprite2D
@export var visual_node: Node2D

var base_layer: TileMapLayer
var is_head: bool = false
var tail: Villager = null
var just_added_as_tail: bool = true

var _is_moving: bool = false
var _target_pos: Vector2
var _target_walking_speed: float = 1.0

func _ready() -> void:
	if _villager_sprites.size() > 0:
		_sprite.texture = _villager_sprites.pick_random()


func _on_move_timer_timeout() -> void:
	# Only the head actually does pathfinding and such.
	if is_head == false:
		return

	# If the player is not set, the villager cannot move.
	if GameManager.game.player == null:
		return

	var current_tile: Vector2i = GameManager.game.level.tile_map_local_to_map(global_position)
	var player_pos = GameManager.game.player.global_position
	var player_tile: Vector2i = GameManager.game.level.tile_map_local_to_map(player_pos)
	var path = GameManager.game.level.astar_grid.get_id_path(current_tile, player_tile)

	# First tile in path is current tile.
	# So if the path size is 1 or below, the villager is at target position.
	if path.size() < 2:
		return

	var target_tile = path[1]

	var is_walkable: bool = GameManager.game.level.get_tile_is_walkable(target_tile)
	if !is_walkable:
		return

	# When moving, only the visual layer is animated.
	# We do this by moving the player, but setting the visual node back to the previous position
	# and then animating it to the current one.
	var prev_pos = global_position
	var prev_walking_speed = _target_walking_speed

	_is_moving = true
	_target_pos = GameManager.game.level.tile_map_map_to_local(target_tile)
	_target_walking_speed = GameManager.game.level.get_tile_walking_speed(target_tile)
	global_position = _target_pos
	visual_node.global_position = prev_pos

	# Make tail follow, if it exists.
	if tail != null:
		tail.follow(prev_pos, prev_walking_speed)

func follow(follow_to_pos: Vector2, walking_speed: float) -> void:
	if is_head:
		return

	# If a villager is added to the tail,
	# it is added at the last tail villager's position.
	# Therefore it needs to wait one "tick" until it can move.
	if just_added_as_tail:
		just_added_as_tail = false
		return

	# Save current position for the tail to follow.
	var prev_pos = global_position
	var prev_walking_speed = _target_walking_speed

	_is_moving = true
	_target_pos = follow_to_pos
	_target_walking_speed = walking_speed
	global_position = _target_pos
	visual_node.global_position = prev_pos

	# Make tail follow, if it exists.
	if tail != null:
		tail.follow(prev_pos, prev_walking_speed)

	GameSignalHub.villager_head_moved.emit()

func _physics_process(_delta: float) -> void:
	if !_is_moving:
		return

	if visual_node.global_position == _target_pos:
		_is_moving = false
		return

	visual_node.global_position = visual_node.global_position.move_toward(_target_pos, _target_walking_speed)

func add_villager(villager: Villager) -> void:
	if tail != null:
		tail.add_villager(villager)
	else:
		tail = villager
		villager.global_position = global_position
