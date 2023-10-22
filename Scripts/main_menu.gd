extends Control

@onready var play_button : Button = $"Panel/PlayButton"

func _ready():
	play_button.button_up.connect(_on_play_released)
#	play_button.mouse_entered.connect(_on_mouse_entered)
#	play_button.mouse_exited.connect(_on_mouse_exited)

func _process(_delta):
	pass

func _on_play_released():
	get_tree().change_scene_to_file("res://Scenes/main_level.tscn")

#func _on_mouse_entered():
#	var tween = get_tree().create_tween()
#	tween.tween_property(play_button, "modulate:a", 1, 0.5)
#
#func _on_mouse_exited():
#	var tween = get_tree().create_tween()
#	tween.tween_property(play_button, "modulate:a", 0, 0.5)
