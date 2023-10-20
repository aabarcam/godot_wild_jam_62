extends Node2D

signal note_success

@onready var player : Player = $"Player"
@onready var world : World = $"World"
@export var rotation_speed : float = 1
var seconds_per_note = 2
var time : float = 0.0
var full_rot_time : float
var started : bool = false
var perimeter : float
var ratio : float
var next_note_ratio : float
var day_notes : Array = []
var night_notes : Array = []
var spawned : int = 0

var single_note_scene = preload("res://Scenes/single_note.tscn")
var double_note_scene = preload("res://Scenes/double_note.tscn")
var hold_note_scene = preload("res://Scenes/single_hold_note.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	player.hit_note.connect(_on_hit_note)
	player.release_note.connect(_on_release_note)
	self.note_success.connect(player._on_note_success)
	world.anim_player.animation_finished.connect(_on_world_anim_finished)
	
	world.set_anim_speed(rotation_speed)
	full_rot_time = 10 / rotation_speed
	perimeter = world.get_perimeter()
	ratio = seconds_per_note / full_rot_time
	next_note_ratio = ratio * 2
	spawn_note()
	spawn_note()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("turn_day"):
		start_day()
	elif Input.is_action_just_pressed("turn_night"):
		start_night()
		
	if started:
		time += delta
		if time > seconds_per_note:
			time -= seconds_per_note
			spawn_note()
			activate_next()

func activate_next():
	if day_notes.is_empty():
		return
	var next_note = day_notes.front()
	next_note.start_note()

func spawn_note():
	if spawned > full_rot_time / seconds_per_note - 4:
		return
	spawned += 1
	var next_note = [single_note_scene, double_note_scene, hold_note_scene].pick_random()
	var radius = world.get_radius() + 256
	var note_pos = -next_note_ratio * 2 * PI - deg_to_rad(90)
	var note_instance = next_note.instantiate()
	note_instance.radians = note_pos
	world.add_child(note_instance)
	var angle_offset = -note_pos - deg_to_rad(90)
	note_instance.rotation = -angle_offset
	note_instance.scale = Vector2(0.7, 0.7)
	note_instance.position = Vector2(radius * cos(note_pos), radius * sin(note_pos))
	next_note_ratio += ratio
	day_notes.append(note_instance)
	night_notes.push_front(note_instance)
	
	note_instance.note_done.connect(_on_note_done)

func start_day():
	started = true
	player.play_day_walk()
	world.start_day()

func start_night():
	started = true
	player.play_night_walk()
	world.start_night()

func _on_note_done(note, success_state):
	day_notes.erase(note)
	var new_radius
	var tween_time
	if success_state:
		note_success.emit()
		new_radius = world.get_radius() - 64 * 4
		tween_time = 1
	else:
		new_radius = world.get_radius() - 16
		tween_time = 0.5
	var pos_tween = get_tree().create_tween()
	var radians = note.radians
	var new_pos = Vector2(new_radius * cos(radians), new_radius * sin(radians))
	pos_tween.tween_property(note, "position", new_pos, tween_time)

func _on_hit_note():
	if day_notes.is_empty():
		return
	var next_note = day_notes.front()
	next_note.hit_note()

func _on_release_note():
	if day_notes.is_empty():
		return
	var next_note = day_notes.front()
	next_note.release_note()

func _on_world_anim_finished(anim_name):
	started = false
	print(anim_name)
	if anim_name == "day":
		print("reseting")
		for n in night_notes:
			n.reset()
