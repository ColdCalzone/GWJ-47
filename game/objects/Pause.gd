extends CanvasLayer

var mode = 0

func _enter_tree():
	MusicPlayer.stop()
	get_tree().paused = true
	if mode == 1:
		$Conotrol/CenterContainer/VBoxContainer/Resume.visible = false
		$Conotrol/CenterContainer2/Label.text = "Game Over"
		$Conotrol/CenterContainer2/Label2.text = "Game Over"

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
