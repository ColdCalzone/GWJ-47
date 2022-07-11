extends Node2D

onready var dynamic_tilemap : TileMap = $DynamicBlocks

func _ready():
	var buttons = get_tree().get_nodes_in_group("Button")
	for button in range(buttons.size()):
		buttons[button].connect("depressed", self, "toggle_colors", [[button]])
		buttons[button].connect("released", self, "toggle_colors", [[button]])
		

# colors is an array of ints - 0 for green, 1 for blue, 2 for red
func toggle_colors(_x, colors):
	if colors is Array:
		var blocks = get_tree().get_nodes_in_group("MoveableBlock")
		var buttons = get_tree().get_nodes_in_group("Button")
		for block in range(blocks.size()):
			blocks[block] = blocks[block].position
		for color in colors:
			var outline = dynamic_tilemap.get_used_cells_by_id(color * 2)
			var solid = dynamic_tilemap.get_used_cells_by_id(color * 2 + 1)
			for cell in outline:
				if blocks.has(cell * 16 + (Vector2.ONE * 8)):
					continue
				dynamic_tilemap.set_cellv(cell, color * 2 + 1)
				dynamic_tilemap.update_bitmask_area(cell)
			for cell in solid:
				dynamic_tilemap.set_cellv(cell, color * 2)
				dynamic_tilemap.update_bitmask_area(cell)
			for button in buttons:
				if button.color == color + 1:
					print(button.get_enabled())
					button.enabled = !button.enabled
