@tool
class_name SpriteColourRandomiser extends Node

@export var colour: Color = Color(1, 1, 1)
@export var useRandomColour: bool:
	set(newUseRandomColour):
		useRandomColour = newUseRandomColour
		if useRandomColour:
			colour = Color(randf(), randf(), randf())
		else:
			colour = colour
		if Engine.is_editor_hint():
			get_parent().self_modulate = colour


func _ready() -> void:
	_randomiseColour.call_deferred()

func _randomiseColour() -> void:
	if useRandomColour:
		colour = Color(randf(), randf(), randf())
		get_parent().self_modulate = colour