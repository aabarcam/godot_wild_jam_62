extends Node2D

class_name Note

@onready var anim_player : AnimationPlayer = $"AnimationPlayer"
@onready var outline_sprite : Sprite2D = $"Outline"
@onready var sprite : Sprite2D = $"Sprite"
var start_scale : float = 3
var cue_time : float = 1.0 : set = set_cue
var remaining_time : float = cue_time
var expire_time : float = -0.5
var active : bool = false : set = set_active

var eye_tex = preload("res://Assets/Sprites/Seeds/Eye/SEMILLA-OJO_1.png")
var left_skull_tex = preload("res://Assets/Sprites/Seeds/Skull/SEMILLA-CALAVERA_IZQ_1.png")
var right_skull_tex = preload("res://Assets/Sprites/Seeds/Skull/SEMILLA-CALAVERA_DER_1.png")

var eye_outline_tex = preload("res://Assets/Sprites/Plants/Eye/OJO-FLOR_OUTLINE.png")
var left_skull_outline_tex = preload("res://Assets/Sprites/Plants/Skull/CALAVERAS_IZQ_OUTLINE.png")
var right_skull_outline_tex = preload("res://Assets/Sprites/Plants/Skull/CALAVERAS_DER_OUTLINE.png")
var pumpkin_outline_tex = preload("res://Assets/Sprites/Plants/Pumpkin/CALABAZA_OUTLINE.png")

signal note_done(success_state)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if remaining_time > expire_time and active:
		var adjusted_delta = MusicManager.adjusted_delta()
		remaining_time -= adjusted_delta
		update_outline()
	elif remaining_time <= expire_time and active:
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

func sprout():
	anim_player.stop()
	sprite.visible = false

func grow_pumpkin():
	outline_sprite.texture = pumpkin_outline_tex

func grow_eye():
	outline_sprite.texture = eye_outline_tex

func grow_skull_left():
	outline_sprite.texture = left_skull_outline_tex

func grow_skull_right():
	outline_sprite.texture = right_skull_outline_tex

func reset():
	remaining_time = cue_time
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
	return start_scale - (start_scale - 1) * (1 - remaining_time)

func check_hit():
	var success = false
	if remaining_time < 0.2 and remaining_time > -0.2:
		success = true
	return success

func hit_note():
	if not active:
		return
	active = false
	outline_sprite.hide()
	var success = check_hit()
	emit_note_done(success)

func emit_note_done(success_state):
	active = false
	note_done.emit(success_state)

func set_active(new_state):
	active = new_state

func set_cue(time):
	cue_time = time
