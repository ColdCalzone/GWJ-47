extends Node

var levels = [
	preload("res://scenes/levels/level1/level.tscn"),
	preload("res://scenes/levels/level2/level.tscn"),
	preload("res://scenes/levels/level3/level.tscn"),
	preload("res://scenes/levels/level4/level.tscn"),
]

var current_level : int = 0

func _ready():
	pass
	#load all levels
