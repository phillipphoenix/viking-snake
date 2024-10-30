extends Node

@export var _time_to_villager_spawn_sec: float = 3.0
@export var _villager_scene: PackedScene
@export var _base_layer: TileMapLayer

func _ready() -> void:
	_connect_signals()
	
func _connect_signals() -> void:
	GameSignalHub.village_pillaged.connect(_on_village_pillaged)

func _on_village_pillaged(village: Village) -> void:
	await get_tree().create_timer(_time_to_villager_spawn_sec).timeout
	var villager_instance: Villager = _villager_scene.instantiate()
	villager_instance.global_position = village.global_position
	villager_instance.base_layer = _base_layer
	add_child(villager_instance)
