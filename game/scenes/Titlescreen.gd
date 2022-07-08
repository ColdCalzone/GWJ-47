extends Control

func _ready():
	pass 


func _on_Play_pressed():
	TransitionManager.transition_to(Scenes.Scenes.LevelSelect)
