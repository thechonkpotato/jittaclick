extends Node2D

const block_scene: PackedScene = preload('res://scenes/box.tscn')
const score_effect_scene: PackedScene = preload('res://scenes/score_effect.tscn')
const explode_effect_scene: PackedScene = preload('res://scenes/explode_effect.tscn')
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

func remove_block(block: Node2D, score):
	blocks.erase(
		{'block': block, 'side': block.get_meta('side')}
	)
	var colour := Color.WHITE
	if block.get_meta('side') == 'left':
		colour = Color.PINK
	elif block.get_meta('side') == 'right':
		colour = Color.AQUA
	spawn_score_effect(score, block.global_position, colour)
	spawn_hit_effect(block.global_position, colour)
	block.queue_free()

func spawn_score_effect(score, pos: Vector2, colour: Color):
	print('spawned score!')

	var score_effect = score_effect_scene.instantiate()
	if score: score_effect.score = score
	score_effect.colour = colour
	score_effect.global_position = pos
	add_child(score_effect)

func spawn_hit_effect(pos: Vector2, colour: Color):
	print('spawned hit!')

	var explode_effect = explode_effect_scene.instantiate()
	explode_effect.colour = colour
	explode_effect.global_position = pos
	add_child(explode_effect)
