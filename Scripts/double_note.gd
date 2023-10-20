extends Node2D

signal note_done(this_note, success_state)

@onready var note : Note = $"Note"
@onready var note_2 : Note = $"Note2"
@onready var timer : Timer = $"Timer"
var radians
# Called when the node enters the scene tree for the first time.
func _ready():
	note.play_left_skull_anim()
	note_2.play_right_skull_anim()
	note.note_done.connect(_on_first_note_done)
	note_2.note_done.connect(_on_second_note_done)
	timer.timeout.connect(_on_timer_timeout)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func reset():
	note.reset()
	note_2.reset()

func start_note():
	note.start()
	timer.start()

func hit_note():
	if note.active:
		note.hit_note()
	else:
		note_2.hit_note()

func release_note():
	pass

func _on_timer_timeout():
	print("timeout")
	timer.stop()
	note_2.start()

func _on_first_note_done(success_state):
	if success_state == false:
		timer.stop()
		note_2.active = false
		note_done.emit(self, false)

func _on_second_note_done(success_state):
	print("Double note emitting: ", success_state)
	print("first note active:", note.active)
	print("second note active:", note_2.active)
	note_done.emit(self, success_state)
