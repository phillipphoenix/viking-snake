extends Node

var villages_burned: int = 0
var level: Level
var player: Player
var villager_head: Villager
var villager_tail: Villager

func _ready() -> void:
	_connect_signals()
	reset()

func reset() -> void:
	villages_burned = 0

func _connect_signals() -> void:
	GameSignalHub.village_pillaged.connect(_on_village_pillaged)
	GameSignalHub.villager_spawned.connect(_on_villager_spawned)
	
func _on_village_pillaged(village: Village) -> void:
	villages_burned += 1

func _on_villager_spawned(villager: Villager) -> void:
	if villager_head == null:
		villager_head = villager
		villager.is_head = true
		villager_tail = villager
		return
	
	villager_tail.add_villager(villager)
	villager_tail = villager