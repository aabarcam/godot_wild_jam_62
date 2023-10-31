class_name PlayableNote
extends Node2D

signal note_done(this_note: SingleNote, success_state: bool)

@export var offset: float = 64.0: get = get_offset
var radians: float
var _is_seed: bool = true
var current_sprite: AnimatedSprite2D


func _process(_delta: float) -> void:
	pass


func use_sprite(sprite: AnimatedSprite2D) -> void:
	if current_sprite != null:
		current_sprite.queue_free()
	current_sprite = sprite
	current_sprite.visible = true
	current_sprite.play()


func activate_ghost(ghost: AnimatedSprite2D) -> void:
	ghost.visible = true
	ghost.play()


func deactivate_ghost(ghost: AnimatedSprite2D) -> void:
	ghost.visible = false
	ghost.stop()


func time_to_scale(time: float) -> float:
	var start_scale = 2.5
	return start_scale - (start_scale - 1) * (1 - time)


func get_offset() -> float:
	return offset


func start_note() -> void:
	assert(false, "Override function")


func hit_note() -> void:
	assert(false, "Override function")


func release_note() -> void:
	assert(false, "Override function")


func reset() -> void:
	assert(false, "Override function")


func set_cue(_time: float):
	assert(false, "Override function")

# Override
func _on_note_done(_success: bool) -> void:
	assert(false, "Override function")
