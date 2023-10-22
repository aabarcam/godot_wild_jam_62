extends Node2D

signal note_success

enum Notes {EMPTY, SINGLE, DOUBLE, HOLD}

@onready var sun = $"Sun"
@onready var moon = $"Moon"
@onready var background : ColorRect = $"Background"
@onready var day_conductor : Conductor = $"DaySong"
@onready var night_conductor : Conductor = $"NightSong"
@onready var current_conductor : Conductor = day_conductor
@onready var player : Player = $"Player"
@onready var world : World = $"World"
@onready var shift : ColorRect = $"Shift"
@onready var hud : Node2D = $"HUD"
@onready var hud_anim_player : AnimationPlayer = $"HUD/AnimationPlayer"
@onready var start_label : Label = $"Start"
@onready var game_over_label : Label = $"GameOver"
@onready var full_rot_time : float = current_conductor.stream.get_length()
@onready var world_rotation_ratio : float = 2 * PI / full_rot_time
@export var rotation_speed : float = 1
@export var beats_per_note = 4
var seconds_per_note : float
var time : float = 0.0
var beat : int = 0
var started : bool = false
var perimeter : float
var ratio : float
var next_note_ratio : float
var current_notes : Array = []
var night_notes : Array = []
var active_notes : Array = []
var spawned : int = 0
var is_day : bool
var game_started : bool = false

var single_note_scene = preload("res://Scenes/single_note.tscn")
var double_note_scene = preload("res://Scenes/double_note.tscn")
var hold_note_scene = preload("res://Scenes/single_hold_note.tscn")
var night_hud_3 = "night_3"
var night_hud_2 = "night_2"
var night_hud_1 = "night_1"
var night_hud_0 = "night_0"
var night_huds = [night_hud_0, night_hud_1, night_hud_2, night_hud_3]
var night_hud = night_hud_3
var day_hud_3 = "day_3"
var day_hud_2 = "day_2"
var day_hud_1 = "day_1"
var day_hud_0 = "day_0"
var day_huds = [day_hud_0, day_hud_1, day_hud_2, day_hud_3]
var day_hud = day_hud_3
# Called when the node enters the scene tree for the first time.
func _ready():
	MusicManager.set_conductor(day_conductor)
	player.hit_note.connect(_on_hit_note)
	player.release_note.connect(_on_release_note)
	player.player_lost.connect(_on_player_lost)
	self.note_success.connect(player._on_note_success)
	day_conductor.finished.connect(on_day_finished)
	night_conductor.finished.connect(on_night_finished)
	hud_anim_player.play("day_3")
	
	seconds_per_note = beats_per_note * MusicManager.get_sec_per_beat()
	perimeter = world.get_perimeter()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("main_action") and not game_started:
		game_started = true
		start_day()
	elif Input.is_action_just_pressed("reset") and game_started:
		reset()
		
	if started:
		world.rotation = world_rotation_ratio * current_conductor.get_song_pos()
		if not is_day:
			world.rotation *= -1
#		time += adjusted_delta
#		if time > seconds_per_note:
		var new_beat = current_conductor.get_current_beat()
		if new_beat > beat and new_beat%beats_per_note==0:
#			time -= seconds_per_note
			beat=new_beat
			if is_day:
				spawn_note()
			activate_next()

func activate_next():
	if current_notes.is_empty():
		return
	var next_note = current_notes.pop_front()
	if next_note == null:
		return
	next_note.set_cue(2 * current_conductor.get_sec_per_beat())
	active_notes.append(next_note)
	next_note.start_note()

func spawn_note(offset=0):
	if spawned > full_rot_time / seconds_per_note - 4:
		return
	spawned += 1
	var next_note = [Notes.EMPTY, Notes.SINGLE, Notes.DOUBLE, Notes.HOLD].pick_random()
	next_note = [single_note_scene, double_note_scene, hold_note_scene].pick_random()
#	if next_note == Notes.EMPTY:
		
	var radius = world.get_radius() + 256
#	var note_pos = -next_note_ratio * 2 * PI - deg_to_rad(90)
	var note_pos = -next_note_ratio - deg_to_rad(120) + offset
	var note_instance = next_note.instantiate()
	note_instance.radians = note_pos
	world.add_child(note_instance)
	var angle_offset = -note_pos - deg_to_rad(90)
	note_instance.rotation = -angle_offset
	note_instance.scale = Vector2(0.4, 0.4)
	note_instance.position = Vector2(radius * cos(note_pos), radius * sin(note_pos))
	next_note_ratio = world_rotation_ratio * current_conductor.get_song_pos()
	current_notes.append(note_instance)
	
	note_instance.note_done.connect(_on_note_done)

func start_day():
	start_label.hide()
	is_day = true
	started = true
	current_conductor.play()
	player.play_day_walk()
	world.start_day()
	spawn_note(world_rotation_ratio * current_conductor.get_sec_per_beat() * 10)
	spawn_note(world_rotation_ratio * current_conductor.get_sec_per_beat() * 5)

func play_night():
	current_conductor = night_conductor
	MusicManager.set_conductor(current_conductor)
	current_conductor.play()
	full_rot_time = current_conductor.stream.get_length()
	world_rotation_ratio = 2 * PI / full_rot_time
	is_day = false
	started = true
	player.play_night_walk()

func start_night():
	var tween = get_tree().create_tween()
	tween.tween_property(shift, "color:a", 1, 4)
	tween.finished.connect(brighten_screen)

func brighten_screen():
	background.color = Color("1b1b0f")
	hud_anim_player.play(night_hud)
	sun.hide()
	moon.show()
	world.start_night()
	player.turn_witch()
	
	for n in night_notes:
		if n != null:
			n.grow()
	
	var tween = get_tree().create_tween()
	tween.tween_property(shift, "color:a", 0, 4)
	tween.finished.connect(play_night)

func game_over():
	game_over_label.show()
	current_conductor.stop()
	started = false
	player.stop_anim()

func reset():
	get_tree().reload_current_scene()

func _on_note_done(note, success_state):
	active_notes.erase(note)
	if success_state and note.to_harvest:
		note.harvest()
	if not success_state:
		player.miss()
		day_hud = day_huds[player.lives]
		night_hud = night_huds[player.lives]
		if is_day:
			night_notes.push_front(null)
			hud_anim_player.play(day_hud)
		else:
			hud_anim_player.play(night_hud)
		if not note.to_harvest:
			note.queue_free()
		return
	if is_day:
		night_notes.push_front(note)
	note_success.emit()
	var new_radius = world.get_radius() - 32
	var tween_time = 0.8
	var pos_tween = get_tree().create_tween()
	var radians = note.radians
	var new_pos = Vector2(new_radius * cos(radians), new_radius * sin(radians))
	pos_tween.tween_property(note, "position", new_pos, tween_time)

func _on_hit_note():
	if active_notes.is_empty():
		return
	var next_note = active_notes.front()
	next_note.hit_note()

func _on_release_note():
	if active_notes.is_empty():
		return
	var next_note = active_notes.front()
	next_note.release_note()

func _on_player_lost():
	game_over()

func on_day_finished():
	active_notes = []
	player.stop_anim()
	started = false
	beat = 0
	current_notes = night_notes
	for n in current_notes:
		if n == null:
			continue
		n.reset()
		n.to_harvest = true
	start_night()

func on_night_finished():
	player.stop_anim()
	var tween = get_tree().create_tween()
	tween.tween_property(shift, "color:a", 1, 4)
	tween.finished.connect(_go_to_credits)

func _go_to_credits():
	get_tree().change_scene_to_file("res://Scenes/credits.tscn")
