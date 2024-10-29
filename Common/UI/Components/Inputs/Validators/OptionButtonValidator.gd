class_name OptionButtonValidator extends Validator

@export var required: bool = false

var option_button: OptionButton

func _ready() -> void:
	var parent = get_parent()
	assert(parent is OptionButton, "OptionButtonValidator must be a child of an OptionButton.")
	option_button = parent
	option_button.item_selected.connect(_on_item_selected)

func _exit_tree() -> void:
	option_button.item_selected.disconnect(_on_item_selected)

## This function returns true if the input is valid, false otherwise.
func validate() -> bool:
	if required:
		return option_button.selected != -1
	return true

func _on_item_selected(_index: int) -> void:
	should_check_validation.emit()