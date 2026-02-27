extends Node

@onready var bmanage := get_node('../BlockManager')

@export var beatmap_path: NodePath = 'res://assets/beatmap.json'
var beatmap_file = FileAccess.open(beatmap_path, FileAccess.READ)
var beatmap = JSON.parse_string(beatmap_file.get_as_text())

var beat := 0
var time := 0.0
var note_idx := 0 
var timestamp := 0.0 
var song = beatmap['trigger']
var beats: Array = song.beats
var next_note_timestamp: float = beats[0].beat * Globals.bpm_wait # 0.6 secs

func _ready():
	print(beats)
	print(next_note_timestamp)

func _physics_process(delta: float) -> void:
	time += delta
	if note_idx >= beats.size():
		return
	if time >= next_note_timestamp:
		bmanage.spawn_box(beats[note_idx].side)
		note_idx += 1
		if note_idx < beats.size():
			next_note_timestamp = beats[note_idx].beat * Globals.bpm_wait
