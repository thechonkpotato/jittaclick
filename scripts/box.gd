extends Area2D

@export var speed: float = 500.0

var x_range := 0.0
var y_range := 0.0
var width := 0.0
var height := 0.0
@export var padding := 80.0

var y_offset: float = Globals.line_y - (speed * Globals.bpm_wait * 2)

func _ready(): 
	print(y_offset)
	print(Globals.line_y)
	x_range = get_viewport_rect().size.x
	y_range = get_viewport_rect().size.y
	width = $CollisionShape2D.shape.size.y * global_scale.y
	height = $CollisionShape2D.shape.size.y * global_scale.y
	
	if get_meta('side') == 'left': 
		global_position.x = padding
		modulate = Color.RED
	else: 
		global_position.x = x_range - padding
		modulate = Color.BLUE
	
	global_position.y = y_offset

func _physics_process(delta: float) -> void:
	global_position.y += speed * delta
	if global_position.y > y_range + height: get_node('../..').remove_block(self) # get the blocks node2d in the main scene

func centered_gpos():
	return global_position + Vector2(width / 2, height / 2)
