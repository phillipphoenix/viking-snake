class_name Stepper extends RefCounted

var prev_btn: Button
var next_btn: Button

var steps_container: Control

var current_step_index: int = 0
var steps: Array[Step] = []

func _init(_steps_container: Control, _prev_btn: Button, _next_btn: Button) -> void:
	steps_container = _steps_container
	prev_btn = _prev_btn
	next_btn = _next_btn

	# Find all Step nodes that are children of the steps_container.
	for step in steps_container.get_children():
		if step is Step:
			steps.append(step)
			step.should_check_validation.connect(on_should_check_validation)

	# Connect the buttons to their respective functions.
	prev_btn.pressed.connect(_on_prev_btn_pressed)
	next_btn.pressed.connect(_on_next_btn_pressed)

	# Update step visibility.
	_update_step_and_button_visibility()
	# Check validation for the first step.
	call_deferred("_check_validation")

func _on_prev_btn_pressed() -> void:
	if current_step_index > 0:
		current_step_index -= 1
		_update_step_and_button_visibility()

func _on_next_btn_pressed() -> void:
	if current_step_index < steps.size() - 1:
		if steps[current_step_index].validate():
			current_step_index += 1
			_update_step_and_button_visibility()

func _update_step_and_button_visibility() -> void:
	for i in range(steps.size()):
		steps[i].visible = i == current_step_index

	prev_btn.visible = current_step_index > 0
	next_btn.visible = current_step_index < steps.size() - 1

func _check_validation() -> void:
	next_btn.disabled = !steps[current_step_index].validate()

func on_should_check_validation() -> void:
	_check_validation()