class_name SingleNote
extends PlayableNote

var ghost_dict: Dictionary = {}
var active_ghost: AnimatedSprite2D
@onready var note_component = $"NoteComponent" as NoteComponent
@onready var seed_sprite = $"Sprites/Seed" as AnimatedSprite2D
@onready var sprout_sprite = $"Sprites/Sprout" as AnimatedSprite2D
@onready var plant_sprite = $"Sprites/Plant" as AnimatedSprite2D
@onready var seed_ghost = $"Ghosts/Seed" as AnimatedSprite2D
@onready var plant_ghost = $"Ghosts/Plant" as AnimatedSprite2D


func _ready() -> void:
	note_component.note_done.connect(_on_note_done)
	use_sprite(seed_sprite)
	active_ghost = seed_ghost
	offset = 80


func _process(_delta: float) -> void:
	var ghost_scale = time_to_scale(note_component.get_remaining_time())
	var ghost = ghost_dict.get(note_component) as AnimatedSprite2D
	if ghost != null:
		ghost.scale = Vector2(ghost_scale, ghost_scale)

func sprout() -> void:
	_is_seed = false
	use_sprite(sprout_sprite)


func grow() -> void:
	active_ghost = plant_ghost
	use_sprite(plant_sprite)


func start_note() -> void:
	note_component.start()
	ghost_dict[note_component] = active_ghost
	activate_ghost(active_ghost)


func hit_note() -> void:
	note_component.hit_note()


func release_note() -> void:
	return


func reset() -> void:
	note_component.reset()
	ghost_dict = {}


func set_cue(time: float) -> void:
	note_component.set_cue_time(time)


func _on_note_done(success: bool) -> void:
	note_done.emit(self, success)
	deactivate_ghost(ghost_dict[note_component])
	if not success and _is_seed:
		queue_free()
		return
	await get_tree().create_timer(1.0).timeout
	if success:
		if _is_seed:
			sprout()
		else:
			queue_free()

