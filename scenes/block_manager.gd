extends Node2D

const block_scene: PackedScene = preload('res://scenes/box.tscn')
var blocks: Array[Dictionary] = [] # <-- HERE'S THE LIST NO FREAKING WAY

func spawn_box(side: String): 
	var block: Area2D = block_scene.instantiate()
	block.set_meta('side', side)
	add_block(block)

func add_block(block: Node2D):
	blocks.append(
		{'block': block, 'side': block.get_meta('side')}
	)
	add_child(block)

func remove_block(block: Node2D):
	blocks.erase(
		{'block': block, 'side': block.get_meta('side')}
	)
	block.queue_free()
