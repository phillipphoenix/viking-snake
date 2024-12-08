extends PanelContainer

@export var level_meta: LevelMeta
@export var level_title_label: Label
@export var level_select_button: Button

func _ready():
	if level_meta:
		initialise(level_meta)

	_connect_signals()

func initialise(_level_meta: LevelMeta) -> void:
	self.level_meta = _level_meta
	level_title_label.text = level_meta.name

func _connect_signals() -> void:
	level_select_button.pressed.connect(_on_level_select_button_pressed)

func _on_level_select_button_pressed() -> void:
	Scenery.switch_to("game", level_meta)