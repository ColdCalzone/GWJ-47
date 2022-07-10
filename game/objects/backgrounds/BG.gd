extends CanvasItem

const MAX_SIZE = 20

var time = 0;

func _draw():
	draw_circle(Vector2(0, 0), MAX_SIZE * sin(time), Color.pink)

func _process(d):
	time += d
	update()
