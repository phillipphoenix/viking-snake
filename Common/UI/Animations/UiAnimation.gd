class_name UiAnimation extends Node

# NOTE: Using this video for inspiration: https://www.youtube.com/watch?v=jF3UgstQ1Yk&t=237s
# NOTE: Currently on this one (the above is the final one): https://www.youtube.com/watch?v=GwqLPb0-NRc

signal entered()
signal exited()

@export_group("Options")
@export var from_center: bool = true
@export var has_enter_animation: bool = false
@export var has_hover_animation: bool = false
@export var isParallel: bool = true
@export var properties: Array[String] = [
	"scale",
	"position",
	# "position:x"
	"rotation",
	"size",
	"self_modulate"
	# "visible_ratio" # How much of the text should be visible.
]
@export var exitProperties: Array[String] = [
	"scale",
	"position",
	# "position:x"
	"rotation",
	"size",
	"self_modulate"
	# "visible_ratio"
]

@export_group("Enter Settings")
@export var enter_wait_for: UiAnimation
@export var enter_time: float = 0.1
@export var enter_delay: float = 0.0
@export var enter_transition: Tween.TransitionType
@export var enter_easing: Tween.EaseType
@export var enter_position: Vector2
@export var enter_scale: Vector2 = Vector2(1, 1)
@export var enter_rotation: float
@export var enter_size: Vector2
@export var enter_self_modulate: Color = Color.WHITE
@export var enter_text_visible_ratio: float = 1.0

@export_group("Exit Settings")
@export var exit_wait_for: UiAnimation
@export var exit_time: float = 0.1
@export var exit_delay: float = 0.0
@export var exit_transition: Tween.TransitionType
@export var exit_easing: Tween.EaseType
@export var exit_position: Vector2
@export var exit_scale: Vector2 = Vector2(1, 1)
@export var exit_rotation: float
@export var exit_size: Vector2
@export var exit_self_modulate: Color = Color.WHITE
@export var exit_text_visible_ratio: float = 1.0

@export_group("Hover Settings")
@export var hover_time: float = 0.1
@export var hover_delay: float = 0.0
@export var hover_transition: Tween.TransitionType
@export var hover_easing: Tween.EaseType
@export var hover_position: Vector2
@export var hover_scale: Vector2 = Vector2(1, 1)
@export var hover_rotation: float
@export var hover_size: Vector2
@export var hover_self_modulate: Color = Color.WHITE

var target: Control
var default_scale: Vector2
var hover_values: Dictionary
var default_values: Dictionary
var enter_values: Dictionary
var exit_values: Dictionary

const IMMEDIATE_TRANSITION = Tween.TRANS_LINEAR

func _ready() -> void:
	target = get_parent()
	setup.call_deferred()

func setup_connections() -> void:
	if has_hover_animation:
		target.mouse_entered.connect(add_tween.bind(
			properties,
			hover_values,
			isParallel,
			hover_time,
			hover_delay,
			hover_transition,
			hover_easing,
			AnimationSignalType.NONE
		))
		target.mouse_exited.connect(add_tween.bind(
			properties,
			default_values,
			isParallel,
			hover_time,
			hover_delay,
			hover_transition,
			hover_easing,
			AnimationSignalType.NONE
		))
	if enter_wait_for:
		enter_wait_for.entered.connect(add_tween.bind(
			properties,
			default_values,
			isParallel,
			enter_time,
			enter_delay,
			enter_transition,
			enter_easing,
			AnimationSignalType.ENTER
		))
	if exit_wait_for:
		exit_wait_for.exited.connect(add_tween.bind(
			exitProperties,
			exit_values,
			isParallel,
			exit_time,
			exit_delay,
			exit_transition,
			exit_easing,
			AnimationSignalType.EXIT
		))


func setup() -> void:
	if from_center:
		target.pivot_offset = target.size / 2

	default_scale = target.scale
	default_values = {
		"scale": target.scale,
		"position": target.position,
		"position:x": target.position.x,
		"rotation": target.rotation,
		"size": target.size,
		"self_modulate": target.self_modulate,
		"visible_ratio": exit_text_visible_ratio
	}
	hover_values = {
		"scale": hover_scale,
		"position": target.position + hover_position,
		"position:x": target.position.x + hover_position.x,
		"rotation": target.rotation + deg_to_rad(hover_rotation),
		"size": target.size + hover_size,
		"self_modulate": hover_self_modulate,
		"visible_ratio": exit_text_visible_ratio
	}
	enter_values = {
		"scale": enter_scale,
		"position": target.position + enter_position,
		"position:x": target.position.x + enter_position.x,
		"rotation": target.rotation + deg_to_rad(enter_rotation),
		"size": target.size + enter_size,
		"self_modulate": enter_self_modulate,
		"visible_ratio": enter_text_visible_ratio
	}
	exit_values = {
		"scale": exit_scale,
		"position": target.position + exit_position,
		"position:x": target.position.x + exit_position.x,
		"rotation": target.rotation + deg_to_rad(exit_rotation),
		"size": target.size + exit_size,
		"self_modulate": exit_self_modulate,
		"visible_ratio": exit_text_visible_ratio
	}
	setup_connections()
	if (has_enter_animation):
		on_enter()
	else:
		entered.emit()

func on_enter() -> void:
	add_tween(properties, enter_values, true, 0.0, 0.0, IMMEDIATE_TRANSITION, enter_easing, AnimationSignalType.NONE)
	if (!enter_wait_for):
		add_tween(properties, default_values, isParallel, enter_time, enter_delay, enter_transition, enter_easing, AnimationSignalType.ENTER)

func start_exit_animation() -> void:
	add_tween(properties, exit_values, isParallel, exit_time, exit_delay, exit_transition, exit_easing, AnimationSignalType.EXIT)

func add_tween(tweenProperties: Array[String], values: Dictionary, isParrallel: bool, seconds: float, delay: float, transition: Tween.TransitionType, easing: Tween.EaseType, signal_type: AnimationSignalType = AnimationSignalType.NONE) -> void:
	var tween = get_tree().create_tween()
	tween.set_parallel(isParrallel)
	tween.pause()
	for property in tweenProperties:
		tween.tween_property(target, str(property), values[property], seconds).set_trans(transition).set_ease(easing)
	await get_tree().create_timer(delay).timeout
	tween.play()

	# Trigger signals, when animation is finished.
	await tween.finished
	match signal_type:
		AnimationSignalType.ENTER:
			entered.emit()
		AnimationSignalType.EXIT:
			exited.emit()

enum AnimationSignalType {
	NONE,
	ENTER,
	EXIT
}
