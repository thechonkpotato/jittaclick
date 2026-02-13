extends Node2D

func _process(_delta):
	if Input.is_action_just_pressed('left'):
		print('left')
	if Input.is_action_just_pressed('right'):
		print('right')
