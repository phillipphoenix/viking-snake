class_name InGameMenu extends Control

signal on_close_menu()
signal on_close_menu_finished()

var is_hidden: bool = false
var _current_sub_menu: InGameMenu = null

## The menu container used for all menus.
var _menu_container: Node

## Call super() in the child class,
## if you override this method to ensure that sub menus can be tested locally.
func _ready() -> void:
	if _menu_container == null:
		_menu_container = get_parent()

# --- CALLED BY IN GAME MENU SPAWNER ---

## Called from the menu spawner when the menu should be cleared/freed.
## Override this method in the child class to start exit animation or other before
## calling queue_free().
func clear_menu() -> void:
	on_close_menu_finished.emit()
	queue_free()

# --- CALLED BY IN GAME MENU SPAWNER AND THE MENU ITSELF ---

func initialise_menu(menu_container: Node) -> void:
	_menu_container = menu_container

# --- CALLED BY MENU ITSELF ---

## Call when the menu should be closed, for example when the close button is pressed.
## Should only be called from a GameMenu class or sub class.
func _close_menu() -> void:
	on_close_menu.emit()

func _init_sub_menu(menu: InGameMenu) -> void:
	# Set up sub menu.
	menu.initialise_menu(_menu_container)

	# Hide current menu.
	_hide_menu()

	# Add sub menu to the menu container.
	_menu_container.add_child(menu)
	_current_sub_menu = menu
	menu.on_close_menu.connect(_on_close_sub_menu)

func _on_close_sub_menu() -> void:
	if (_current_sub_menu == null):
		return
	_current_sub_menu.on_close_menu_finished.connect(_on_menu_cleared)
	_current_sub_menu.clear_menu()
	_current_sub_menu = null

func _on_menu_cleared() -> void:
	_unhide_menu()

## The menu spawner calls this, when a sub menu is opened and the current menu should be momentarily hidden.
func _hide_menu() -> void:
	visible = false
	is_hidden = true

## The menu spawner calls this, when the sub menu is closed and the current menu should be shown again.
func _unhide_menu() -> void:
	visible = true
	is_hidden = false