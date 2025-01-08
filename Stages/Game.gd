class_name Game extends Node

var villages_total: int = 0
var villages_burned: int = 0
var level: Level
var player: Player
var villager_head: Villager
var villager_tail: Villager

func scenery_init(data) -> void:
	var level_meta = data as LevelMeta
	initialise(level_meta)

func initialise(level_meta: LevelMeta) -> void:
	GameManager.game = self
	level = level_meta.scene.instantiate()
	add_child(level)

func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	GameSignalHub.village_pillaged.connect(_on_village_pillaged)
	GameSignalHub.villager_spawned.connect(_on_villager_spawned)

func _on_village_pillaged(_village: Village) -> void:
	villages_burned += 1
	GameSignalHub.update_score_ui.emit()
	if are_win_conditions_met():
		GameSignalHub.win_conditions_met.emit()

func _on_villager_spawned(villager: Villager) -> void:
	if villager_head == null:
		villager_head = villager
		villager.is_head = true
		villager_tail = villager
		return
		
	villager_tail.add_villager(villager)
	villager_tail = villager

func are_win_conditions_met() -> bool:
	return villages_burned == villages_total
