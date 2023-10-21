extends Node2D

class_name Player

signal hit_note
signal release_note
signal player_lost

@onready var sprite : Sprite2D = $"Sprite2D"
@onready var anim_player : AnimationPlayer = $"AnimationPlayer"
var cheating = false

var lives = 3

var witch_tex = preload("res://Assets/Sprites/Player/Night/Walking/BRUJA-CAMINANDO_1.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	anim_player.animation_finished.connect(_on_anim_finished)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("main_action"):
		hit_note.emit()
	if Input.is_action_just_released("main_action"):
		release_note.emit()
	if Input.is_action_just_pressed("cheat"):
		cheating = true

func miss():
	if cheating:
		return
	lives -= 1
	if lives == 0:
		player_lost.emit()

func turn_witch():
	position.y -= 8
	sprite.texture = witch_tex

func _on_note_success():
	if anim_player.current_animation == "day_walk":
		play_day_plant()
	elif anim_player.current_animation == "night_walk":
		play_night_harvest()

func _on_anim_finished(anim_name):
	if anim_name == "day_plant":
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

func stop_anim():
	anim_player.stop()
