class_name HoldNote
extends PlayableNote

var ghost_dict: Dictionary = {}
var active_ghost: AnimatedSprite2D
@onready var note_component = $"HoldNoteComponent" as HoldNoteComponent
@onready var seed_sprite = $"Sprites/Seed" as AnimatedSprite2D
@onready var sprout_sprite = $"Sprites/Sprout" as AnimatedSprite2D
@onready var plant_sprite = $"Sprites/Plant" as AnimatedSprite2D
@onready var seed_ghost = $"Ghosts/Seed" as AnimatedSprite2D
@onready var plant_ghost = $"Ghosts/Plant" as AnimatedSprite2D
@onready var progress_bar = $"ProgressBar" as ProgressBar


func _ready() -> void:
	note_component.note_done.connect(_on_note_done)
	use_sprite(seed_sprite)
	active_ghost = seed_ghost
	offset = 32


func _process(_delta: float) -> void:
	var ghost_scale = time_to_scale(note_component.get_remaining_time())
	var ghost = ghost_dict.get(note_component) as AnimatedSprite2D
	if ghost != null:
		ghost.scale = Vector2(ghost_scale, ghost_scale)
	var progress = note_component.get_progress()
	progress_bar.value = progress


func sprout() -> void:
	_is_seed = false
	use_sprite(sprout_sprite)


func grow() -> void:
	active_ghost = plant_ghost
	use_sprite(plant_sprite)
	progress_bar.show()
	progress_bar.position.y = -1080


func start_note() -> void:
	note_component.start()
	ghost_dict[note_component] = active_ghost
	activate_ghost(active_ghost)


func hit_note() -> void:
	note_component.hit_note()
	deactivate_ghost(active_ghost)


func release_note() -> void:
	note_component.release_note()


func reset() -> void:
	note_component.reset()
	ghost_dict = {}


func set_cue(time: float) -> void:
	note_component.set_cue_time(time)
	note_component.max_progress = time / 3.0
	progress_bar.max_value = time / 3.0


func _on_note_done(success: bool) -> void:
	note_done.emit(self, success)
	progress_bar.hide()
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

