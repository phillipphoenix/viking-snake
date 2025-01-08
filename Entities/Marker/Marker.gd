extends Node2D

@export var _play_on_ready: bool = true
@export var _loop_animation: bool = false
@export var _animation_player: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_animation_player.get_animation("Rotation").loop_mode = Animation.LoopMode.LOOP_LINEAR if _loop_animation else Animation.LoopMode.LOOP_NONE
	if _play_on_ready:
		_animation_player.play("Rotation")
