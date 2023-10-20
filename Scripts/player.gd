extends Node2D

class_name Player

signal hit_note
signal release_note

@onready var anim_player : AnimationPlayer = $"AnimationPlayer"

# Called when the node enters the scene tree for the first time.
func _ready():
	anim_player.animation_finished.connect(_on_anim_finished)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("play_note"):
		hit_note.emit()
	if Input.is_action_just_released("play_note"):
		release_note.emit()

func _on_note_success():
	if anim_player.current_animation == "day_walk":
		print("plant")
		play_day_plant()
	elif anim_player.current_animation == "night_walk":
		play_night_harvest()

func _on_anim_finished(anim_name):
	if anim_name == "day_plant":
		print("walk")
		play_day_walk()
	elif anim_name == "night_harvest":
		play_night_walk()

func play_day_walk():
	anim_player.play("day_walk")

func play_day_plant():
	anim_player.play("day_plant")

func play_night_walk():
	anim_player.play("night_walk")

func play_night_harvest():
	anim_player.play("night_harvest")
