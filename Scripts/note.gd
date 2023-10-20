extends Node2D

class_name Note

@onready var anim_player : AnimationPlayer = $"AnimationPlayer"
@onready var outline_sprite : Sprite2D = $"Outline"
var start_scale : float = 3
var end_scale : float = 0.5
var progress : float = 0.0
var active : bool = false : set = set_active

var eye_tex = preload("res://Assets/Sprites/Seeds/Eye/SEMILLA-OJO_1.png")
var left_skull_tex = preload("res://Assets/Sprites/Seeds/Skull/SEMILLA-CALAVERA_IZQ_1.png")
var right_skull_tex = preload("res://Assets/Sprites/Seeds/Skull/SEMILLA-CALAVERA_DER_1.png")

signal note_done(success_state)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if progress < 100 and active:
		progress = min(progress + delta * 75, 100)
		update_outline()
	elif progress == 100 and active:
		active = false
		emit_note_done(false)
		hide_outline()

func play_eye_anim():
	outline_sprite.texture = eye_tex
	anim_player.play("idle_eye")

func play_left_skull_anim():
	outline_sprite.texture = left_skull_tex
	anim_player.play("idle_skull_left")

func play_right_skull_anim():
	outline_sprite.texture = right_skull_tex
	anim_player.play("idle_skull_right")

func reset():
	progress = 0
	hide_outline()
	update_outline()
	active = false

func start():
	active = true
	show_outline()

func update_outline():
	var outline_scale = current_scale()
	if outline_scale > 0:
		outline_sprite.scale = Vector2(outline_scale, outline_scale)

func hide_outline():
	outline_sprite.visible = false

func show_outline():
	outline_sprite.visible = true

func current_scale():
	return start_scale - (start_scale - end_scale) * progress / 100

func check_hit():
	var success = false
	if current_scale() > 1.5:
		print("bad")
	elif current_scale() > 1.1:
		print("early")
	elif current_scale() > 0.9:
		success = true
		print("good")
	elif current_scale() > 0.5:
		print("late")
	else:
		print("bad")
	return success

func hit_note():
	if not active:
		return
	active = false
	var success = check_hit()
	emit_note_done(success)

func emit_note_done(success_state):
	active = false
	note_done.emit(success_state)

func set_active(new_state):
	active = new_state
