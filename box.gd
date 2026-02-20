extends Area2D

@export var speed: float = 500.0

var x_range := 0.0
var y_range := 0.0
var y_size := 0.0
@export var padding := 80.0

func _ready(): 
	x_range = get_viewport_rect().size.x
	y_range = get_viewport_rect().size.y
	y_size = $CollisionShape2D.shape.size.y * global_scale.y
	
	if randf() < 0.5: 
		global_position.x = padding
		set_meta('side', 'left')
		modulate = Color.RED
	else: 
		global_position.x = x_range - padding
		set_meta('side', 'right')
		modulate = Color.BLUE
	
	global_position.y = -y_size

func _physics_process(delta: float) -> void:
	global_position.y += speed * delta
	if global_position.y > y_range + y_size: queue_free()
