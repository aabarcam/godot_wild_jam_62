extends Node2D

class_name World

@onready var anim_player : AnimationPlayer = $"AnimationPlayer"
@onready var sprite : Sprite2D = $"Sprite"

var day_sprite = preload("res://Assets/Sprites/World/MUNDO NEGRO SIN FONDO.png")
var night_sprite = preload("res://Assets/Sprites/World/MUNDO BEIGE SIN FONDO.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func start_day():
	sprite.texture = day_sprite

func start_night():
	sprite.texture = night_sprite

func set_anim_speed(new_speed):
	anim_player.speed_scale = new_speed

func get_radius():
	return sprite.texture.get_height() / 2.0

func get_perimeter():
	return 2 * get_radius() * PI
