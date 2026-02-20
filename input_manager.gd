extends Node2D

@onready var block_cluster = $Blocks
@onready var cam = $Camera2D

var bpm: float = 200

const block_scene: PackedScene = preload('res://box.tscn')
var blocks: Array[Array] = []

var left_points := 0
var right_points := 0

func _ready(): 
	cam.position.x = cam.get_viewport_rect().size.x / 2
	cam.position.y = cam.get_viewport_rect().size.y / 2
	
	$Timer.wait_time = 30 / bpm
	randomize()

func _physics_process(_delta):
	if Input.is_action_just_pressed('left'): 
		test_for_blocks('left')
		print(left_points)
				
	if Input.is_action_just_pressed('right'): 
		test_for_blocks('right')
		print(right_points)

func _on_timer_timeout():
	#$Sound/GoodHit.play()
	var block: Area2D = block_scene.instantiate()

	block_cluster.add_child(block)
	$Timer.start()

func _on_area_2d_area_entered(area: Area2D):
	blocks.append(
		[area, area.get_meta('side')]
	)
	$Sound/GoodHit.play()

func _on_area_2d_area_exited(area: Area2D):
	blocks.erase(
		[area, area.get_meta('side')]
	)

func test_for_blocks(input_side: String):
	for datapiece in blocks: 
		var block = datapiece[0]
		var side = datapiece[1]
		if side == input_side:
			block.queue_free()
			blocks.erase(
				[block, side]
			)
			if input_side == 'left':
				left_points += 1
			elif input_side == 'right':
				right_points += 1
