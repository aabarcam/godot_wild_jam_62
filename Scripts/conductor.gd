extends AudioStreamPlayer

class_name Conductor

@export var bpm : int = 100

var prev_song_position : float = 0.0
var song_position : float = 0.0
var song_position_beats : int = 1
var last_reported_beat : int = 0
var beats_before_start : int = 0
var sec_per_beat : float

var closest : int = 0

func _ready():
	sec_per_beat = 60.0 / bpm

func _process(_delta):
	if playing:
		prev_song_position = song_position
		song_position = get_playback_position() + AudioServer.get_time_since_last_mix()
		song_position -= AudioServer.get_output_latency()
		song_position_beats = int(floor(song_position / sec_per_beat)) + beats_before_start

func adjusted_delta():
	return song_position - prev_song_position

func get_song_pos():
	return song_position

func get_current_beat():
	return song_position_beats

func get_sec_per_beat():
	return sec_per_beat

func time_until_next_beat():
	return (get_current_beat() + 1) * get_sec_per_beat() - get_song_pos()
