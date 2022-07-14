extends Control

onready var grid = $CenterContainer/GridContainer

onready var preview_image = $Preview/TextureCenter/TextureRect

onready var preview_desc = $Preview/TextCenter/Label

var rotate = false

func _ready():
	MusicPlayer.load_file("res://music/mamus_titlescreen_draft.ogg", true)
	var button_theme = load("res://src/LevelSelect.tres")
	
	var checkmark : TextureRect = TextureRect.new()
	checkmark.texture = load("res://sprites/checkmark.png")
	checkmark.rect_size = Vector2.ONE * 16
	checkmark.expand = true
	checkmark.rect_position = Vector2(92, 82)
	
	for x in range(LevelData.levels.size()):
		var button = Button.new()
		button.expand_icon = true
		button.theme = button_theme
		button.rect_min_size = Vector2(100, 90)
		grid.add_child(button)
		button.icon = LevelData.levels[x].preview
		if LevelData.save_data["levels"][LevelData.levels[x].level_name]["beaten"]:
			button.add_child(checkmark.duplicate())
		button.connect("pressed", self, "level_selected", [x])
		button.connect("mouse_entered", self, "preview_level", [x])
		button.connect("mouse_exited", self, "preview_level", [-1])

func preview_level(level : int):
	if level == -1:
		rotate = false
		preview_desc.text = ""
		preview_image.texture = null
	else:
		rotate = true
		preview_image.texture = LevelData.levels[level].preview
		preview_desc.text = LevelData.levels[level].description

func _process(delta):
	if rotate:
		preview_image.rect_rotation += delta * 5
		if preview_image.rect_rotation > 360:
			preview_image.rect_rotation = 0

func level_selected(level : int):
	TransitionManager.transition_to(Scenes.Scenes.Game, level)


func _on_Back_pressed():
	TransitionManager.transition_to(Scenes.Scenes.Titlescreen)
