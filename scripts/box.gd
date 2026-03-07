extends Area2D

@export var speed: float = 500.0

var x_range := 0.0
var y_range := 0.0
var width := 0.0
var height := 0.0
@export var padding := 80.0

var y_offset: float = Globals.line_y - (speed * Globals.bpm_wait * 2) + 10

func _ready():
	x_range = get_viewport_rect().size.x
	y_range = get_viewport_rect().size.y
	width = $CollisionShape2D.shape.size.y * global_scale.y
	height = $CollisionShape2D.shape.size.y * global_scale.y

	if get_meta('side') == 'left':
		global_position.x = padding
		$Block.modulate = Color.PINK
	else:
		global_position.x = x_range - padding
		$Block.modulate = Color.AQUA
		$Arrow.scale.x *= -1

	$Block.modulate.a = 0.2

	global_position.y = y_offset

func _process(delta: float) -> void:
	global_position.y += speed * delta
	if global_position.y > y_range + height:
		print('miss')
		Globals.score -= 100
		global_position.y = -100000 # make it stop triggering this if statement
		get_parent().remove_block(self, null) # get the blocks node2d in the main scene

func centered_gpos():
	return global_position + Vector2(width / 2, height / 2)
