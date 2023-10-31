class_name DoubleNote
extends PlayableNote

var left_ghost: AnimatedSprite2D
var right_ghost: AnimatedSprite2D
var ghost_dict: Dictionary = {}
@onready var note_component = $"NoteComponent" as NoteComponent
@onready var note_component_2 = $"NoteComponent2" as NoteComponent
@onready var seed_sprite = $"Sprites/Seed" as AnimatedSprite2D
@onready var sprout_sprite = $"Sprites/Sprout" as AnimatedSprite2D
@onready var plant_sprite = $"Sprites/Plant" as AnimatedSprite2D
@onready var seed_ghosts = $"Ghosts/Seeds" as Node2D
@onready var plant_ghosts = $"Ghosts/Plants" as Node2D
@onready var left_seed_ghost = $"Ghosts/Seeds/Left" as AnimatedSprite2D
@onready var right_seed_ghost = $"Ghosts/Seeds/Right" as AnimatedSprite2D
@onready var left_plant_ghost = $"Ghosts/Plants/Left" as AnimatedSprite2D
@onready var right_plant_ghost = $"Ghosts/Plants/Right" as AnimatedSprite2D


func _ready() -> void:
	note_component.note_done.connect(_on_first_note_done)
	note_component_2.note_done.connect(_on_second_note_done)
	use_sprite(seed_sprite)
	left_ghost = left_seed_ghost
	right_ghost = right_seed_ghost
	offset = 96


func _process(_delta: float) -> void:
	for key in ghost_dict:
		var ghost_scale = time_to_scale(key.get_remaining_time())
		var ghost = ghost_dict.get(key) as AnimatedSprite2D
		if ghost != null:
			ghost.scale = Vector2(ghost_scale, ghost_scale)


func sprout() -> void:
	_is_seed = false
	use_sprite(sprout_sprite)


func grow() -> void:
	left_ghost = left_plant_ghost
	right_ghost = right_plant_ghost
	use_sprite(plant_sprite)


func start_note() -> void:
	note_component.start()
	ghost_dict[note_component] = left_ghost
	activate_ghost(left_ghost)
	await get_tree().create_timer(note_component.get_cue_time()/2.0).timeout
	note_component_2.start()
	ghost_dict[note_component_2] = right_ghost
	activate_ghost(right_ghost)


func hit_note() -> void:
	if note_component.get_active():
		note_component.hit_note()
	else:
		note_component_2.hit_note()


func release_note() -> void:
	return


func reset() -> void:
	note_component.reset()
	note_component_2.reset()
	ghost_dict = {}


func set_cue(time: float) -> void:
	note_component.set_cue_time(time)
	note_component_2.set_cue_time(time)


func _on_first_note_done(success: bool) -> void:
	deactivate_ghost(ghost_dict[note_component])
	if not success:
		note_done.emit(self, false)
		var second_ghost = ghost_dict.get(note_component_2) as AnimatedSprite2D
		if second_ghost != null:
			deactivate_ghost(ghost_dict[note_component_2])
		if _is_seed:
			queue_free()


func _on_second_note_done(success: bool) -> void:
	note_done.emit(self, success)
	deactivate_ghost(ghost_dict[note_component])
	deactivate_ghost(ghost_dict[note_component_2])
	if not success and _is_seed:
		queue_free()
	await get_tree().create_timer(1.0).timeout
	if success:
		if _is_seed:
			sprout()
		else:
			queue_free()
