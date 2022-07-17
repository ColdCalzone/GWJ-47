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
	var jank : TextureRect = padlock.duplicate()
	jank.rect_position = Vector2(-20, 0)
	padlock.rect_position -= Vector2.ONE * 10
	checkmark.texture = load("res://sprites/checkmark.png")
	padlock.texture = load("res://sprites/padlock.png")
	jank.texture = load("res://sprites/jank.png")
	jank.theme = load("res://src/jank.tres")
	
	var hbox : HBoxContainer = HBoxContainer.new()
	var center = CenterContainer.new()
	grid.add_child(center)
	center.add_child(hbox)
	hbox.add_constant_override("separation", 25)
	var y = -1
	for x in range(LevelData.levels.size()):
		y += 1
		if y > 2:
			y = 0
			hbox = HBoxContainer.new()
			center = CenterContainer.new()
			grid.add_child(center)
			center.add_child(hbox)
			hbox.add_constant_override("separation", 25)
		var button = Button.new()
		button.expand_icon = true
		button.theme = button_theme
		button.rect_min_size = Vector2(100, 90)
		hbox.add_child(button)
		button.icon = LevelData.levels[x].preview
		if LevelData.save_data["levels"][LevelData.levels[x].level_name]["beaten"]:
			button.add_child(checkmark.duplicate())
		if LevelData.save_data["levels"][LevelData.levels[max(0, x - 1)].level_name]["beaten"] or x == 0:
			button.connect("mouse_entered", self, "preview_level", [x])
			if LevelData.jank_descriptions.has(LevelData.levels[x].level_name):
				var jank_instance = jank.duplicate()
				jank_instance.hint_tooltip = LevelData.jank_descriptions[LevelData.levels[x].level_name]
				button.add_child(jank_instance)
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
