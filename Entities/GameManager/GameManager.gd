extends Node

var villages_burned: int = 0
var astar_grid: AStarGrid2D
var player: Player

func _ready() -> void:
	_connect_signals()
	_create_astar_grid()
	reset()

func reset() -> void:
	villages_burned = 0

func _connect_signals() -> void:
	GameSignalHub.village_pillaged.connect(_on_village_pillaged)
	
func _on_village_pillaged(village: Village) -> void:
	villages_burned += 1

func _create_astar_grid() -> void:
	astar_grid = AStarGrid2D.new()
	astar_grid.region = Rect2i(0, 0, 16, 16)
	astar_grid.cell_size = Vector2(16, 16)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()
	
func _update_astar_grid() -> void:
	pass
