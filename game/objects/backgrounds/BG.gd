tool
extends CanvasItem

const MAX_SIZE = 20

var time = 0;

var width = 21
var height = 12

var circle_distance = 40

var speed = 1.5

func _draw():
	for x in range(width):
		for y in range(height):
			# Godot is throwing a hissy fit about the colors send help
			draw_circle(Vector2(x * circle_distance, y * circle_distance), MAX_SIZE * cos(x + y * speed + time), Settings.colors[(x + y) % Settings.colors.size()])

func _process(d):
	time += d
	update()

