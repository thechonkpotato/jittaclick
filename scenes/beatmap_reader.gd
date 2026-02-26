extends Node

@onready var beat_timer := $Timer
@onready var bmanage := get_node('../BlockManager')

@export var beatmap_path: NodePath = 'res://assets/beatmap.json'
var beatmap_file = FileAccess.open(beatmap_path, FileAccess.READ)
var beatmap = JSON.parse_string(beatmap_file.get_as_text())

var beat := 0

func _ready():
	var song = beatmap['trigger']
	Globals.bpm = song.bpm
	var beats: Array = song.beats
	
	beat_timer.wait_time = Globals.bpm_wait
	beat_timer.start()
	
	print(beatmap)
	
func _on_timer_timeout(): inc_beat()

func inc_beat():
	beat += 1
	print('beat: ' + str(beat))
	bmanage.spawn_box('left')
	bmanage.spawn_box('right')
