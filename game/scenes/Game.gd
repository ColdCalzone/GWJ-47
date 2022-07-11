extends Node2D

onready var special_button = $Button2
onready var dynamic_tilemap : TileMap = $DynamicBlocks

func _ready():
	special_button.connect("depressed", self, "toggle_green")

func toggle_green(_arg):
	var green_outline = dynamic_tilemap.get_used_cells_by_id(0)
	var green_solid = dynamic_tilemap.get_used_cells_by_id(1)
	for cell in green_outline:
		dynamic_tilemap.set_cellv(cell, 1)
		dynamic_tilemap.update_bitmask_area(cell)
	for cell in green_solid:
		dynamic_tilemap.set_cellv(cell, 0)
		dynamic_tilemap.update_bitmask_area(cell)
