extends Node2D

@onready var block_cluster = $Blocks
@onready var cam = $Camera2D

const block_scene: PackedScene = preload('res://box.tscn')

func _ready(): 
	cam.position.x = cam.get_viewport_rect().size.x / 2
	cam.position.y = cam.get_viewport_rect().size.y / 2
	
	randomize()

func _physics_process(_delta):
	if Input.is_action_just_pressed('left'): 
		print('left')
	if Input.is_action_just_pressed('right'): 
		print('right')

func _on_timer_timeout():
	var block: Area2D = block_scene.instantiate()

	block_cluster.add_child(block)
	$Timer.start()

func _on_area_2d_area_entered(area: Area2D):
	print('orientation: ' + area.get_meta('side'))
