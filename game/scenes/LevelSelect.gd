extends Control

# TODO populate level buttons from folder

onready var buttons = [
	
]

onready var temp_button : Button = $GridContainer/Button

func _ready():
	for button in buttons:
		assert(button is Button)
		# TODO make the bind dynamic
		button.connect("pressed", self, "level_selected", [""])
	temp_button.connect("pressed", self, "level_selected", [""])

func level_selected(level : int):
	LevelData.current_level = level
	TransitionManager.transition_to(Scenes.Scenes.Game)


func _on_Back_pressed():
	TransitionManager.transition_to(Scenes.Scenes.Titlescreen)
