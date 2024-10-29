class_name InGameMenuSpawner extends Node

@export var _menu_container: Control
@export var _menu_background: Panel
@export var _menu_background_anim_duration: float = 0.5

var _current_menu: InGameMenu

func _ready() -> void:
	_connect_signals()
	_menu_background.self_modulate.a = 0.0
	_menu_background.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _connect_signals() -> void:
	pass

func _init_menu(menu: InGameMenu) -> void:
	if (_current_menu == null):
		_show_menu_background()

	menu.initialise_menu(_menu_container)
	_menu_container.add_child(menu)
	_current_menu = menu
	menu.on_close_menu.connect(_close_current_menu)

func _show_menu_background() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(_menu_background, "self_modulate:a", 1.0, _menu_background_anim_duration)
	_menu_background.mouse_filter = Control.MOUSE_FILTER_STOP

func _hide_menu_background() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(_menu_background, "self_modulate:a", 0.0, _menu_background_anim_duration)
	_menu_background.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _close_current_menu() -> void:
	if (_current_menu == null):
		return
	_current_menu.on_close_menu_finished.connect(_on_menu_cleared)
	_current_menu.clear_menu()
	_current_menu = null

func _on_menu_cleared() -> void:
		_hide_menu_background()
