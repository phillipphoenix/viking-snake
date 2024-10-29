class_name IntEdit extends LineEdit

signal value_changed(value: int)

var regex = RegEx.new()
var prev_text: String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	regex.compile("^\\d+$")
	text_changed.connect(_on_text_changed)

func _on_text_changed(new_text: String) -> void:
	if new_text == "" || regex.search(new_text):
		prev_text = text
		value_changed.emit(int(text))
	else:
		text = prev_text
		set_caret_column(text.length())

func reset_value():
	text = ""

func set_value(value: int):
	text = str(value)

func get_value() -> int:
	return (int(text))
