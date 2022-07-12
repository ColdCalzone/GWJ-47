extends CanvasLayer



func _ready():
	MusicPlayer.stop()
	get_tree().paused = true

func _exit_tree():
	get_tree().paused = false

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		_on_Resume_pressed()

func _on_Resume_pressed():
	queue_free()

func _on_Restart_pressed():
	# Boldly assuming the parent is a Game which can restart
	get_parent().restart()
	queue_free()

func _on_Quit_pressed():
	TransitionManager.transition_to(Scenes.Scenes.LevelSelect)
	queue_free()
