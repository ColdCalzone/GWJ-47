extends Control

onready var grid = $CenterContainer/GridContainer

onready var preview_image = $Preview/TextureCenter/TextureRect

onready var preview_name = $Preview/TextCenter/Label
onready var preview_description = $Preview/TextCenter2/Label

var rotate = false

func _ready():
	MusicPlayer.load_file("res://music/mamus_titlescreen_draft.ogg", true)
	var button_theme = load("res://src/LevelSelect.tres")
	
	var checkmark : TextureRect = TextureRect.new()
	checkmark.rect_size = Vector2.ONE * 16
	checkmark.expand = true
	checkmark.rect_position = Vector2(92, 82)
	var padlock : TextureRect = checkmark.duplicate()
	padlock.rect_size *= 1.5
	padlock.rect_position -= Vector2.ONE * 10
	checkmark.texture = load("res://sprites/checkmark.png")
	padlock.texture = load("res://sprites/padlock.png")
	
	for x in range(LevelData.levels.size()):
		var button = Button.new()
		button.expand_icon = true
		button.theme = button_theme
		button.rect_min_size = Vector2(100, 90)
		grid.add_child(button)
		button.icon = LevelData.levels[x].preview
		if LevelData.save_data["levels"][LevelData.levels[x].level_name]["beaten"]:
			button.add_child(checkmark.duplicate())
		if LevelData.save_data["levels"][LevelData.levels[max(0, x - 1)].level_name]["beaten"] or x == 0:
			button.connect("mouse_entered", self, "preview_level", [x])
		else:
			button.add_child(padlock.duplicate())
			button.disabled = true
		button.connect("pressed", self, "level_selected", [x])
		button.connect("mouse_exited", self, "preview_level", [-1])

func preview_level(level : int):
	if level == -1:
		rotate = false
		preview_name.text = ""
		preview_description.text = ""
		preview_image.texture = null
	else:
		rotate = true
		preview_image.texture = LevelData.levels[level].preview
		preview_name.text = LevelData.levels[level].display_name
		preview_description.text = LevelData.levels[level].description

func _process(delta):
	if rotate:
		preview_image.rect_rotation += delta * 5
		if preview_image.rect_rotation > 360:
			preview_image.rect_rotation = 0

func level_selected(level : int):
	TransitionManager.transition_to(Scenes.Scenes.Game, level)


func _on_Back_pressed():
	TransitionManager.transition_to(Scenes.Scenes.Titlescreen)
