extends Node2D

func _ready():
	$SingleHoldNote.grow()
	
	for i in range(4):
		print(i)
		await get_tree().create_timer(1.0).timeout
