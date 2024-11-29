extends Control

@export var back_button: Button

@export var level_list: LevelList
@export var level_select_box_scene: PackedScene
@export var level_select_box_container: Container

func _ready() -> void:
	_connect_signals()
	_create_level_select_boxes(level_list)

func _create_level_select_boxes(_level_list: LevelList) -> void:
	for child in level_select_box_container.get_children():
		child.queue_free()

	for level_meta in _level_list.levels:
		var level_select_box = level_select_box_scene.instantiate()
		level_select_box.initialise(level_meta)
		level_select_box_container.add_child(level_select_box)

func _connect_signals() -> void:
	back_button.pressed.connect(_on_back_button_pressed)

func _on_back_button_pressed() -> void:
	Scenery.switch_to("main_menu")