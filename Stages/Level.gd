class_name Level extends Node2D

@export var base_layer: TileMapLayer
@export var level_grid_size: Vector2i = Vector2i(16, 16)
@export var level_tile_size: Vector2 = Vector2(16, 16)

var astar_grid: AStarGrid2D
var villagers: Array[Villager] = []

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
	astar_grid.update()

func _update_astar_grid() -> void:
	astar_grid.fill_solid_region(Rect2i(0, 0, level_grid_size.x, level_grid_size.y), false)
	for villager in villagers:
		var villager_tile = base_layer.local_to_map(villager.global_position)
		astar_grid.set_point_solid(villager_tile, true)

func _on_villager_spawned(villager: Villager) -> void:
	villagers.append(villager)
