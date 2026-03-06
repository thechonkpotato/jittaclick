extends Node2D

@onready var bmanage = $BlockManager
@onready var cam = $Camera2D

var bpm: float = 100

func _ready():
	Globals.line_y = $Line2D.points[0].y
	cam.position.x = cam.get_viewport_rect().size.x / 2
	cam.position.y = cam.get_viewport_rect().size.y / 2

	$Timer.wait_time = 30 / bpm
	randomize()
	$Timer.start()

func _process(_delta):
	if Input.is_action_just_pressed('left'):
		test_for_blocks('left')
		highlight_score(Color.RED)

	if Input.is_action_just_pressed('right'):
		test_for_blocks('right')
		highlight_score(Color.AQUA)

	$CanvasLayer/ScoreLabel.text = str(Globals.score)

func _on_timer_timeout():
	pulse_all_the_things()
	$Timer.start()

func test_for_blocks(input_side: String): # <-- WOW LOOK AT THIS FUNCTION THAT MEETS ALL OF THE REQUIREMENTS
	for datapiece in bmanage.blocks:
		var block = datapiece.block
		var side = datapiece.side
		if side == input_side and (block.position.y + block.height) >= Globals.line_y:
			bmanage.remove_block(block)
			Globals.score += clamp(round(100 / abs(Globals.line_y - block.position.y)), 0, 200) # the closer to the line it is, the higher the value. can't go over 100.
			$Sound/GoodHit.play()

func pulse_camera():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	$Camera2D.zoom = Vector2(0.98, 0.98)
	tween.tween_property($Camera2D, 'zoom', Vector2(1.0, 1.0), 0.1)

func pulse_score():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	$CanvasLayer/ScoreLabel.scale = Vector2(1.1, 1.1)
	tween.tween_property($CanvasLayer/ScoreLabel, 'scale', Vector2(1.0, 1.0), 0.1)

func highlight_score(colour: Color):
	pulse_score()
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	$CanvasLayer/ScoreLabel.modulate = colour
	tween.tween_property($CanvasLayer/ScoreLabel, 'modulate', Color.WHITE, 0.1)

func pulse_line():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	$Line2D.modulate = Color.WHITE
	tween.tween_property($Line2D, 'modulate', Color.from_rgba8(255, 255, 255, 0.5), 0.2)

func pulse_all_the_things():
	pulse_line()
	pulse_score()
	pulse_camera()
