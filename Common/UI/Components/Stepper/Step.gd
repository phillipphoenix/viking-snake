class_name Step extends Control

signal should_check_validation()

var validators: Array[Validator]

func _ready() -> void:
	find_validators()

## This function will be called when trying to go to the next step in the stepper form.
## It should validate the step and return true if the step is valid, false otherwise.
func validate() -> bool:
	if validators.size() == 0:
		print("no validators found")
		return true
	print("VALIDATING!")
	return validators.all(func(v): return v.validate())

func _on_should_check_validation() -> void:
	should_check_validation.emit()

func find_validators() -> void:
	if validators.size() > 0:
		# Disconnect signals from previous validators.
		for validator in validators:
			validator.should_check_validation.disconnect(_on_should_check_validation)

	# Find all Validator nodes that are children of this step.
	validators = []
	var nodes = find_children("*", "Validator")
	for node in nodes:
		if node is Validator:
			var validator = node as Validator
			validators.append(validator)
			validator.should_check_validation.connect(_on_should_check_validation)
			print("FOUND VALIDATOR: ", validator)
			print("VALIDATORS: ", validators)
			print("VALIDATORS SIZE: ", validators.size())