extends Node2D

signal note_done(this_note, success_state)

@onready var note : Note = $"Note"
var radians
# Called when the node enters the scene tree for the first time.
func _ready():
	note.play_eye_anim()
	note.note_done.connect(_on_note_done)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func reset():
	note.reset()

func start_note():
	note.start()

func hit_note():
	note.hit_note()

func release_note():
	pass

func _on_note_done(success_state):
	note_done.emit(self, success_state)
