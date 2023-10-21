extends Node

var conductor : Conductor = null : set = set_conductor

func adjusted_delta():
	return conductor.adjusted_delta()

func get_sec_per_beat():
	return conductor.get_sec_per_beat()

func time_until_next_beat():
	return conductor.time_until_next_beat()

func set_conductor(new_conductor):
	conductor = new_conductor
