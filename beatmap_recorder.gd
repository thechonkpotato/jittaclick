extends Node

var time: float = 0.0
var inputs: Array[Dictionary] = []

func _process(delta: float) -> void:
	time += delta

	if Input.is_action_just_pressed('left'):
		inputs.append({
			'beat': time * Globals.bpm_wait,
			'side': 'left'
		})

	if Input.is_action_just_pressed('right'):
		inputs.append({
			'beat': time * Globals.bpm_wait,
			'side': 'right'
		})

	if Input.is_action_just_pressed('ui_accept'):
		print(inputs)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		tune_inputs()
		print(inputs)

func snap_number(input: float, precision: float):
	return roundf(input / precision) * precision

func tune_inputs():
	for input in inputs:
		input.beat = snap_number(input.beat, 0.25)
