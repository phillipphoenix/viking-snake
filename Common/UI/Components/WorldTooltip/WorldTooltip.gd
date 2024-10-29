@tool
class_name WorldTooltip extends PanelContainer

@export var label: Label

@export var text: String:
	set(value):
		if label:
			label.text = value
	get:
		return label.text

func _ready() -> void:
	_hide()
	_setup.call_deferred()

func _setup() -> void:
	var parent = get_parent()
	assert(parent.has_signal("mouse_entered") == true, "WorldTooltip needs to be a child of a node that emits mouse_entered signal.")
	assert(parent.has_signal("mouse_exited") == true, "WorldTooltip needs to be a child of a node that emits mouse_exited signal.")

	parent.connect("mouse_entered", _show)
	parent.connect("mouse_exited", _hide)

func _show() -> void:
	show()

func _hide() -> void:
	hide()