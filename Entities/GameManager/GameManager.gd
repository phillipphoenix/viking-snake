extends Node

@export var game_stage: PackedScene

var game: Game

# var villages_total: int = 0
# var villages_burned: int = 0
# var level: Level
# var player: Player
# var villager_head: Villager
# var villager_tail: Villager

func _ready() -> void:
	_connect_signals()
# 	reset()

# func reset() -> void:
# 	villages_total = 0
# 	villages_burned = 0

func _connect_signals() -> void:
	GameSignalHub.level_selected.connect(_on_level_selected)
	# GameSignalHub.village_pillaged.connect(_on_village_pillaged)
	# GameSignalHub.villager_spawned.connect(_on_villager_spawned)
	
func _on_level_selected(level_meta: LevelMeta) -> void:
	if game != null:
		game.queue_free()

	game = game_stage.instantiate()
	game.initialise(level_meta)

	add_child(game)

# func _on_village_pillaged(village: Village) -> void:
# 	villages_burned += 1

# func _on_villager_spawned(villager: Villager) -> void:
# 	if villager_head == null:
# 		villager_head = villager
# 		villager.is_head = true
# 		villager_tail = villager
# 		return
	
# 	villager_tail.add_villager(villager)
# 	villager_tail = villager

# func are_win_conditions_met() -> bool:
# 	return game.are_win_conditions_met()