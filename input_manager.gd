extends Node2D

@onready var block_cluster = $Blocks
@onready var cam = $Camera2D

var bpm: float = 100

const block_scene: PackedScene = preload('res://box.tscn')
var blocks: Array[Dictionary] = [] # <-- HERE'S THE LIST NO FREAKING WAY

var left_points := 0
var right_points := 0

func _ready(): 
	Globals.line_y = $Line2D.points[0].y
	cam.position.x = cam.get_viewport_rect().size.x / 2
	cam.position.y = cam.get_viewport_rect().size.y / 2
	
	$Timer.wait_time = 30 / bpm
	randomize()
	
	spawn_box('left')
	spawn_box('right')
	$Timer.start()

func _physics_process(_delta):
	if Input.is_action_just_pressed('left'): 
		test_for_blocks('left')
		print(left_points)
				
	if Input.is_action_just_pressed('right'): 
		test_for_blocks('right')
		print(right_points)

func _on_timer_timeout():
	$Sound/GoodHit.play()
	
	spawn_box('left')
	spawn_box('right')
	
	$Timer.start()

func add_block(block: Node2D):
	blocks.append(
		{'block': block, 'side': block.get_meta('side')}
	)

func remove_block(block: Node2D):
	blocks.erase(
		{'block': block, 'side': block.get_meta('side')}
	)
	block.queue_free()

func test_for_blocks(input_side: String):
	for datapiece in blocks: 
		var block = datapiece.block; print(block)
		var side = datapiece.side; print(side)
		if side == input_side and (block.position.y + block.height) >= Globals.line_y:
			print(absf(block.centered_gpos().y - Globals.line_y))
			remove_block(block)
			if input_side == 'left':
				left_points += 1
			elif input_side == 'right':
				right_points += 1

func spawn_box(side: String): # <-- WOW LOOK AT THIS FUNCTION THAT MEETS ALL OF THE REQUIREMENTS
	var block: Area2D = block_scene.instantiate()
	block.set_meta('side', side)
	block_cluster.add_child(block)
	add_block(block)
