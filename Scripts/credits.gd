extends Control

@onready var fade_in : Panel = $"FadeIn"

func _ready():
	fade_in.show()
	var tween = get_tree().create_tween()
	tween.tween_property(fade_in.get_node("ColorRect"), "modulate:a", 0, 2)
