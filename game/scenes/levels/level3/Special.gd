extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _process(delta):
	rotation = rotation + delta / 50
	if rotation > 6.282:
		rotation = 0
