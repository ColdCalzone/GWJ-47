extends CanvasLayer

var mode = 0

func _enter_tree():
	MusicPlayer.volume_db = linear2db(db2linear(MusicPlayer.volume_db) / 2)
	get_tree().paused = true
	if mode == 1:
		$Conotrol/CenterContainer/VBoxContainer/Resume.visible = false
		$Conotrol/CenterContainer2/Label.text = "Game Over"
		$Conotrol/CenterContainer2/Label2.text = "Game Over"

#func _exit_tree():
	#get_tree().paused = false

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		if mode == 0:
			_on_Resume_pressed()
		else:
			_on_Restart_pressed()

func _on_Resume_pressed():
	get_tree().paused = false
	MusicPlayer.volume_db = linear2db(db2linear(MusicPlayer.volume_db) * 2)
	queue_free()

func _on_Restart_pressed():
	# Boldly assuming the parent is a Game which can restart
	get_parent().restart()
	get_tree().paused = false
	MusicPlayer.volume_db = linear2db(db2linear(MusicPlayer.volume_db) * 2)
	queue_free()

func _on_Quit_pressed():
	TransitionManager.transition_to(Scenes.Scenes.LevelSelect)
	get_tree().paused = false
	MusicPlayer.volume_db = linear2db(db2linear(MusicPlayer.volume_db) * 2)
	queue_free()
