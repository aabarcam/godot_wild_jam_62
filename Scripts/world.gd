extends Node2D

class_name World

@onready var anim_player : AnimationPlayer = $"AnimationPlayer"
@onready var sprite : Sprite2D = $"Sprite"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func start_day():
	anim_player.play("day")

func start_night():
	anim_player.play("night")

func set_anim_speed(new_speed):
	anim_player.speed_scale = new_speed

func get_radius():
	return sprite.texture.get_height() / 2

func get_perimeter():
	return 2 * get_radius() * PI
