extends Node2D

var colour := Color.WHITE

func _ready():
	$Sprite2D.modulate = colour
	$Sprite2D.modulate.a = 0.5

func _process(_delta):
	var tween = create_tween().set_parallel(true)

	tween.tween_property(self, 'scale', Vector2.ONE * 1.6, 0.5)
	tween.tween_property($Sprite2D, 'modulate', Color.TRANSPARENT, 0.25)

	await tween.finished
	queue_free()
