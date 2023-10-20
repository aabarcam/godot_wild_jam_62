extends "res://Scripts/note.gd"

@onready var progress_bar = $"ProgressBar"
var hold_value : float = 0
var note_hit : bool = false

func _process(delta):
	if note_hit:
		hold_value += delta * 200
	progress_bar.value = hold_value
	if hold_value > 100:
		active = false
		hold_value = 0
		note_hit = false
		emit_note_done(true)
	super._process(delta)

func hit_note():
	if not active:
		return
	if check_hit():
		note_hit = true
	else:
		emit_note_done(false)

func release_note():
	if not active or not note_hit:
		return
	note_hit = false
	if hold_value < 100:
		emit_note_done(false)
