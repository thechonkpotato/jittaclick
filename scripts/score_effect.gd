extends Node2D

var score := 0
var colour := Color.WHITE
var speed := 10.0

func _ready():
	if score: $Label.text = '+%s' % score
	$Label.label_settings = $Label.label_settings.duplicate()
	$Label.label_settings.font_size = clamp(32 + (score / 4), 32, 64) # sets size to how big the score is while keeping it reasonablee
	$Label.modulate = colour

func _process(delta):
	position.y -= speed * delta
	var tween = create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property($Label, 'modulate', Color.TRANSPARENT, 0.25)
	tween.tween_property(self, 'global_position', global_position + Vector2(0, -100), 0.5)

	await tween.finished
	queue_free()
