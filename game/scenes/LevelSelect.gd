extends Control

# TODO populate level buttons from folder

onready var buttons = [
	
]

func _ready():
	MusicPlayer.load_file("res://music/mamus_titlescreen_draft.ogg", true)
	for button in buttons:
		# TODO make the bind dynamic
		button.connect("pressed", self, "level_selected", [0])
	$GridContainer/Button.connect("pressed", self, "level_selected", [0])
	$GridContainer/Button2.connect("pressed", self, "level_selected", [1])
	$GridContainer/Button3.connect("pressed", self, "level_selected", [2])
	$GridContainer/Button4.connect("pressed", self, "level_selected", [3])

func level_selected(level : int):
	TransitionManager.transition_to(Scenes.Scenes.Game, level)


func _on_Back_pressed():
	TransitionManager.transition_to(Scenes.Scenes.Titlescreen)
