class_name HoldNoteComponent
extends NoteComponent

var max_progress: float
var progress: float = 0 : get = get_progress
var _note_hit: bool = false


func _process(delta: float) -> void:
	if _note_hit:
		progress += MusicManager.adjusted_delta()
	if progress > max_progress:
		_emit_note_done(true)
	super._process(delta)


func hit_note() -> void:
	if not _active:
		return
	if not _hit_successful():
		_emit_note_done(false)
		return
	_note_hit = true
	remaining_time = cue_time


func release_note() -> void:
	if not _active or not _note_hit:
		return
	_emit_note_done(false)


func reset() -> void:
	_note_hit = false
	progress = 0
	super.reset()


func get_progress() -> float:
	return progress
