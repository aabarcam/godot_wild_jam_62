extends Node2D

signal note_done(this_note, success_state)

@onready var note : Note = $"HoldNote"
@onready var anim_player : AnimationPlayer = $"AnimationPlayer"
@onready var sprout_timer : Timer = $"SproutTimer"
@onready var harvest_timer : Timer = $"HarvestTimer"
var to_harvest : bool = false
var radians
# Called when the node enters the scene tree for the first time.
func _ready():
	note.note_done.connect(_on_note_done)
	sprout_timer.timeout.connect(_on_sprout_timer_timeout)
	harvest_timer.timeout.connect(_on_harvest_timer_timeout)

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
	note.release_note()

func set_cue(time):
	note.set_cue(time)

func sprout():
	anim_player.play("sprout")
	note.sprout()

func grow():
	anim_player.play("grown")
	note.grow_pumpkin()
	note.position.x = -20
	note.position.y = -352

func harvest():
	harvest_timer.start()

func _on_harvest_timer_timeout():
	self.queue_free()

func _on_note_done(success_state):
	note_done.emit(self, success_state)
	if not to_harvest:
		sprout_timer.start()

func _on_sprout_timer_timeout():
	sprout()
