extends Node2D

@onready var bmanage = $BlockManager
@onready var cam = $Camera2D

var bpm: float = 100

var left_points := 0
var right_points := 0

func _ready(): 
	Globals.line_y = $Line2D.points[0].y
	cam.position.x = cam.get_viewport_rect().size.x / 2
	cam.position.y = cam.get_viewport_rect().size.y / 2
	
	$Timer.wait_time = 30 / bpm
	randomize()
	$Timer.start()

func _physics_process(_delta):
	if Input.is_action_just_pressed('left'): 
		test_for_blocks('left')
				
	if Input.is_action_just_pressed('right'): 
		test_for_blocks('right')

func _on_timer_timeout():
	$Sound/GoodHit.play()
	$Timer.start()

func test_for_blocks(input_side: String): # <-- WOW LOOK AT THIS FUNCTION THAT MEETS ALL OF THE REQUIREMENTS
	for datapiece in bmanage.blocks: 
		var block = datapiece.block
		var side = datapiece.side
		if side == input_side and (block.position.y + block.height) >= Globals.line_y:
			bmanage.remove_block(block)
			if input_side == 'left':
				left_points += 1
			elif input_side == 'right':
				right_points += 1
