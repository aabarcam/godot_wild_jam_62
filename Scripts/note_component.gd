class_name NoteComponent
extends Node2D

signal note_done(success: bool)

@export var low_lim: float = -0.2
@export var upp_lim: float = 0.2

var cue_time: float : set = set_cue_time, get = get_cue_time
var remaining_time: float : set = set_remaining_time, get = get_remaining_time
var _active: bool = false : set = set_active, get = get_active


func _ready() -> void:
	set_process(false)


func _process(_delta: float) -> void:
	if remaining_time >= low_lim:
		remaining_time -= MusicManager.adjusted_delta()
	elif remaining_time < low_lim:
		set_active(false)
		_emit_note_done(false)


func start() -> void:
	_active = true
	assert(cue_time > 0)


func hit_note() -> void:
	if not _active:
		return
	set_active(false)
	_emit_note_done(_hit_successful())


func release_note() -> void:
	return


func set_remaining_time(time: float) -> void:
	remaining_time = time


func get_remaining_time() -> float:
	return remaining_time


func set_active(state: bool) -> void:
	_active = state
	set_process(state)


func get_active() -> bool:
	return _active


func set_cue_time(time: float) -> void:
	cue_time = time
	remaining_time = time


func get_cue_time() -> float:
	return cue_time


func _hit_successful() -> bool:
	if remaining_time > low_lim and remaining_time < upp_lim:
		return true
	return false


func _emit_note_done(success: bool) -> void:
	set_active(false)
	note_done.emit(success)


func reset() -> void:
	set_active(false)
	remaining_time = cue_time
