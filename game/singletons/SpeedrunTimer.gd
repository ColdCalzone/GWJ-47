extends CanvasLayer

onready var label = $SpeedrunTimer

var time : float = 0

func _ready():
	label.visible = false
	set_process(false)

func start_counting():
	set_process(true)
	label.visible = true

func stop_counting():
	set_process(false)

func hide():
	label.visible = false

func reset():
	time = 0
	set_process(false)
	label.text = "0:00"

func _process(delta):
	time += delta
	var minutes = int(floor(time / 60.0))
	var seconds = int(time) % 60
	label.text = String(minutes) + ":" + ("0" if seconds < 10 else "") + String(seconds)
