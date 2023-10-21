extends "res://Scripts/note.gd"

@onready var progress_bar = $"ProgressBar"
var hold_value : float = 0
var note_hit : bool = false

func _process(delta):
	if note_hit:
		var adjusted_delta = MusicManager.adjusted_delta()
		hold_value += adjusted_delta
	progress_bar.max_value = cue_time / 3.0
	progress_bar.value = hold_value
	if hold_value > cue_time / 3.0:
		active = false
		hold_value = 0
		note_hit = false
		progress_bar.hide()
		emit_note_done(true)
	super._process(delta)

func hit_note():
	if not active:
		return
	outline_sprite.hide()
	if check_hit():
		note_hit = true
		outline_sprite.hide()
	else:
		emit_note_done(false)

func release_note():
	if not active or not note_hit:
		return
	note_hit = false
	if hold_value < 100:
		emit_note_done(false)
