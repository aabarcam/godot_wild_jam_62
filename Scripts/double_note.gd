extends Node2D

signal note_done(this_note, success_state)

@onready var note : Note = $"Note"
@onready var note_2 : Note = $"Note2"
@onready var timer : Timer = $"Timer"
@onready var sprout_timer : Timer = $"SproutTimer"
@onready var harvest_timer : Timer = $"HarvestTimer"
@onready var anim_player : AnimationPlayer = $"AnimationPlayer"
var to_harvest : bool = false
var radians
# Called when the node enters the scene tree for the first time.
func _ready():
	note.play_left_skull_anim()
	note_2.play_right_skull_anim()
	note.note_done.connect(_on_first_note_done)
	note_2.note_done.connect(_on_second_note_done)
	timer.timeout.connect(_on_timer_timeout)
	sprout_timer.timeout.connect(_on_sprout_timer_timeout)
	harvest_timer.timeout.connect(_on_harvest_timer_timeout)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func reset():
	note.reset()
	note_2.reset()

func start_note():
	note.start()
	timer.start(note.cue_time / 2.0)

func hit_note():
	if note.active:
		note.hit_note()
	else:
		note_2.hit_note()

func release_note():
	pass

func sprout():
	anim_player.play("idle_sprout")
	note.sprout()
	note_2.sprout()

func grow():
	anim_player.play("grown")
	note.grow_skull_left()
	note_2.grow_skull_right()
	note.position.x = -4
	note.position.y = -760
	note_2.position.x = 144
	note_2.position.y = -384

func harvest():
	harvest_timer.start()

func _on_harvest_timer_timeout():
	self.queue_free()

func set_cue(time):
	note.set_cue(time)
	note_2.set_cue(time)

func _on_timer_timeout():
	timer.stop()
	note_2.start()

func _on_sprout_timer_timeout():
	sprout()

func _on_first_note_done(success_state):
	if success_state == false:
		timer.stop()
		note_2.active = false
		note.hide_outline()
		note_2.hide_outline()
		note_done.emit(self, false)

func _on_second_note_done(success_state):
	note_done.emit(self, success_state)
	note.hide_outline()
	note_2.hide_outline()
	if not to_harvest:
		sprout_timer.start()
