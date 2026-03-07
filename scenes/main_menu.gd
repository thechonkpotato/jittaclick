extends Control

func _ready():
	if Globals.score > Globals.highscore: Globals.highscore = Globals.score # fix highscore
	$HighScoreLabel.text = 'HIGH SCORE: %s' % Globals.highscore

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file('res://scenes/main.tscn') # start game
