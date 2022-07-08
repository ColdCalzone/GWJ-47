extends Control

onready var rainbow = $TextureRect
onready var god_ot = $TextureRect2

onready var label = $CenterContainer/Label
onready var bloop = $AudioStreamPlayer
onready var tween = $Tween

func _ready():
	set_process(false)
	yield(get_tree().create_timer(1.0), "timeout")
	set_process(true)
	yield(get_tree().create_timer(1.625), "timeout")
	yield(get_tree().create_timer(0.125), "timeout")
	label.visible = true
	yield(get_tree().create_timer(1.0), "timeout")
	tween.interpolate_property(label, "rect_scale", Vector2.ONE, Vector2.ONE * 1.05, 0.2, Tween.TRANS_QUART, Tween.EASE_OUT)
	tween.interpolate_property(label, "rect_scale", Vector2.ONE * 1.05, Vector2.ONE, 0.2, Tween.TRANS_QUINT, Tween.EASE_IN_OUT, 0.2)
	bloop.play()
	tween.start()
	yield(get_tree().create_timer(0.2), "timeout")
	tween.interpolate_property(label, "modulate:a", 1.0, 0.0, 0.75)
	tween.start()
	yield(tween, "tween_all_completed")
	TransitionManager.transition_to(Scenes.Scenes.Titlescreen)

var time = 0.0

func _input(event):
	if event is InputEventKey:
		tween.stop_all()
		TransitionManager.transition_to(Scenes.Scenes.Titlescreen)

func _process(delta):
	if time < 3:
		time += delta
		rainbow.material.set_shader_param("time", time)
		god_ot.material.set_shader_param("time", time)
