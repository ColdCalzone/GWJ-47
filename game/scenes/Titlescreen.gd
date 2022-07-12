extends Control

func _ready():
	Bg.visible = Settings.backgrounds

func _on_Play_pressed():
	TransitionManager.transition_to(Scenes.Scenes.LevelSelect)


func _on_Settings_pressed():
	TransitionManager.transition_to(Scenes.Scenes.Settings)


func _on_Quit_pressed():
	TransitionManager.transition_to(Scenes.Scenes.None)


func _on_Credits_pressed():
	TransitionManager.transition_to(Scenes.Scenes.Credits)
