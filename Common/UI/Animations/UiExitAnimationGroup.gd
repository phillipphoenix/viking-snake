class_name UiExitAnimationGroup extends Node

@export var first_exit_animation: UiAnimation
@export var last_exit_animation: UiAnimation

func _ready() -> void:
	last_exit_animation.exited.connect(_on_last_animation_finished)

func start_exit_animations() -> void:
	first_exit_animation.start_exit_animation()

func _on_last_animation_finished() -> void:
	get_parent().queue_free()
