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

	if Input.is_action_just_pressed('right'):
		test_for_blocks('right')
	
	$ScoreLabel.text = 'Score: %s' % Globals.score

func _on_timer_timeout(): 
	pulse_camera()
	$Timer.start()

func test_for_blocks(input_side: String): # <-- WOW LOOK AT THIS FUNCTION THAT MEETS ALL OF THE REQUIREMENTS
	for datapiece in bmanage.blocks:
		var block = datapiece.block
		var side = datapiece.side
		if side == input_side and (block.position.y + block.height) >= Globals.line_y:
			bmanage.remove_block(block)
			Globals.score += round(100 / abs(Globals.line_y - block.position.y)) # the closer to the line it is, the higher the value
			$Sound/GoodHit.play()

func pulse_camera():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	$Camera2D.zoom = Vector2(0.99, 0.99)
	tween.tween_property($Camera2D, 'zoom', Vector2(1.0, 1.0), 0.1)
