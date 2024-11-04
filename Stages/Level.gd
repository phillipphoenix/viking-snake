class_name Level extends Node2D

@export var base_layer: TileMapLayer
@export var props_layer: TileMapLayer
@export var level_grid_size: Vector2i = Vector2i(16, 16)
@export var level_tile_size: Vector2 = Vector2(16, 16)

var astar_grid: AStarGrid2D
var villagers: Array[Villager] = []
var permanent_obstacles: Array[Vector2i] = []

# Getters.

## Returns the map coordinates of the cell containing the given param local_position. If param local_position is in global coordinates, consider using Node2D.to_local before passing it to this method.
func tile_map_local_to_map(local_position: Vector2) -> Vector2i:
	return base_layer.local_to_map(local_position)

## Returns the centered position of a cell in the TileMapLayer's local coordinate space. To convert the returned value into global coordinates, use Node2D.to_global.
func tile_map_map_to_local(map_position: Vector2i) -> Vector2:
	return base_layer.map_to_local(map_position)

func get_tile_is_walkable(tile_pos: Vector2i) -> bool:
	var tile_data = _get_tile_data(tile_pos)
	if tile_data:
		return tile_data.get_custom_data("Walkable") as bool
	return false

func get_tile_walking_speed(tile_pos: Vector2i) -> float:
	var tile_data = _get_tile_data(tile_pos)
	if tile_data:
		return tile_data.get_custom_data("WalkingSpeed")
	return 0.0

# Internal methods.

func _get_tile_data(tile_pos: Vector2i) -> TileData:
	var tile_data = props_layer.get_cell_tile_data(tile_pos)
	if tile_data:
		return tile_data
	else:
		tile_data = base_layer.get_cell_tile_data(tile_pos)
		if tile_data:
			return tile_data
	return null

func _ready() -> void:
	GameManager.level = self
	_create_astar_grid()
	_connect_signals()

func _connect_signals() -> void:
	GameSignalHub.villager_spawned.connect(_on_villager_spawned)
	GameSignalHub.villager_head_moved.connect(_update_astar_grid)

func _create_astar_grid() -> void:
	astar_grid = AStarGrid2D.new()
	astar_grid.region = Rect2i(0, 0, level_grid_size.x, level_grid_size.y)
	astar_grid.cell_size = level_tile_size
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER

	# Add permanent obstacles to array.
	for x in range(level_grid_size.x):
		for y in range(level_grid_size.y):
			var tile_data = props_layer.get_cell_tile_data(Vector2i(x, y))
			if tile_data and !tile_data.get_custom_data("VillagerNavigable"):
				permanent_obstacles.append(Vector2i(x, y))

	astar_grid.update()

func _update_astar_grid() -> void:
	astar_grid.fill_solid_region(Rect2i(0, 0, level_grid_size.x, level_grid_size.y), false)
	for obstacle in permanent_obstacles:
		astar_grid.set_point_solid(obstacle, true)
	for villager in villagers:
		var villager_tile = base_layer.local_to_map(villager.global_position)
		astar_grid.set_point_solid(villager_tile, true)

func _on_villager_spawned(villager: Villager) -> void:
	villagers.append(villager)
