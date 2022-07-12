extends Control

# TODO populate level buttons from folder

onready var buttons = [
	
]

onready var temp_button : Button = $GridContainer/Button

func _ready():
	for button in buttons:
		# TODO make the bind dynamic
		button.connect("pressed", self, "level_selected", [0])
	temp_button.connect("pressed", self, "level_selected", [0])

func level_selected(level : int):
	TransitionManager.transition_to(Scenes.Scenes.Game, level)


func _on_Back_pressed():
	TransitionManager.transition_to(Scenes.Scenes.Titlescreen)
