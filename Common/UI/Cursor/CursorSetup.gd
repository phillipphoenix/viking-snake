extends Node

var cursor_arrow: Texture2D = load("res://Common/UI/Cursor/Icons/CursorArrow.png")
var cursor_ibeam: Texture2D = load("res://Common/UI/Cursor/Icons/CursorIbeam.png")
var cursor_pointer: Texture2D = load("res://Common/UI/Cursor/Icons/CursorPointer.png")

var _cursor_over_interactable_count: int = 0

func _ready() -> void:
	Input.set_custom_mouse_cursor(cursor_arrow, Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(cursor_ibeam, Input.CURSOR_IBEAM)
	_connect_signals()

func _connect_signals() -> void:
	GameSignalHub.mouse_entered_interactable.connect(_on_mouse_entered_interactable)
	GameSignalHub.mouse_exited_interactable.connect(_on_mouse_exited_interactable)

func _on_mouse_entered_interactable() -> void:
	_cursor_over_interactable_count += 1
	_update_cursor()

func _on_mouse_exited_interactable() -> void:
	_cursor_over_interactable_count -= 1
	_update_cursor()

func _update_cursor() -> void:
	if _cursor_over_interactable_count > 0:
		Input.set_custom_mouse_cursor(cursor_pointer, Input.CURSOR_ARROW)
	else:
		Input.set_custom_mouse_cursor(cursor_arrow, Input.CURSOR_ARROW)