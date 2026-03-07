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
var next_note_timestamp: float = beats[note_idx].beat * Globals.bpm_wait - (2 * Globals.bpm_wait)

func _ready():
	print(beats)

func _physics_process(delta: float) -> void:
	time += delta
	if note_idx >= beats.size():
		print('done')
		return
	if time >= next_note_timestamp:
		var side = beats[note_idx].side
		if side == 'end':
			get_tree().change_scene_to_file('res://scenes/main_menu.tscn')
			return

		else:
			bmanage.spawn_box(side)
			note_idx += 1
			if note_idx < beats.size():
				next_note_timestamp = beats[note_idx].beat * Globals.bpm_wait
				next_note_timestamp -= 2 * Globals.bpm_wait # offset by 2 beats so it's timed properly
