extends Control

onready var colors = [
	$CenterContainer2/VBoxContainer/HBoxContainer/ColorPickerButton,
	$CenterContainer2/VBoxContainer/HBoxContainer/ColorPickerButton2,
	$CenterContainer2/VBoxContainer/HBoxContainer/ColorPickerButton3,
	$CenterContainer2/VBoxContainer/HBoxContainer/ColorPickerButton4,
	$CenterContainer2/VBoxContainer/HBoxContainer/ColorPickerButton5,
]

onready var fullscreen = $CenterContainer/VBoxContainer2/Fullscreen
onready var backgrounds = $CenterContainer/VBoxContainer2/Background
onready var music = $CenterContainer/VBoxContainer2/VBoxContainer/HBoxContainer/Music
onready var sfx = $CenterContainer/VBoxContainer2/VBoxContainer/HBoxContainer2/SFX

var default_colors = [
	Color("68386c"),
	Color("b55088"),
	Color("f6757a"),
	Color("3a4466"),
	Color("262b44")
]

func _ready():
	for x in range(Settings.colors.size()):
		colors[x].color = Settings.colors[x]
		colors[x].connect("color_changed", self, "update_colors", [x])
	fullscreen.pressed = Settings.fullscreen
	backgrounds.pressed = Settings.backgrounds
	music.value = Settings.music_volume
	sfx.value = Settings.sound_volume
	

func update_colors(value, id):
	Settings.set_color(value, id)


func _on_Reset_pressed():
	for x in range(Settings.colors.size()):
		colors[x].color = default_colors[x]
		Settings.set_color(default_colors[x], x)


func _on_Back_pressed():
	TransitionManager.transition_to(Scenes.Scenes.Titlescreen)


func _on_Fullscreen_toggled(button_pressed):
	Settings.set_fullscreen(button_pressed)


func _on_Music_value_changed(value):
	Settings.set_music_volume(value)


func _on_SFX_value_changed(value):
	Settings.set_sound_volume(value)


func _on_Background_toggled(button_pressed):
	Settings.set_background(button_pressed)
