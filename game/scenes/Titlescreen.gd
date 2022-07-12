extends Control

func _ready():
	Bg.visible = true


func _on_Play_pressed():
	TransitionManager.transition_to(Scenes.Scenes.LevelSelect)


func _on_Settings_pressed():
	TransitionManager.transition_to(Scenes.Scenes.Settings)


func _on_Quit_pressed():
	pass # Replace with function body.


func _on_Credits_pressed():
	TransitionManager.transition_to(Scenes.Scenes.Credits)
