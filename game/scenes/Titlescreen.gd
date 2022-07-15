extends Control

onready var logo = $CenterContainer2/TextureRect
onready var tween = $Tween

func _ready():
	MusicPlayer.load_file("res://music/mamus_titlescreen_draft.ogg", true)
	Bg.visible = Settings.backgrounds

func _on_Play_pressed():
	TransitionManager.transition_to(Scenes.Scenes.LevelSelect)


func _on_Settings_pressed():
	TransitionManager.transition_to(Scenes.Scenes.Settings)


func _on_Quit_pressed():
	TransitionManager.transition_to(Scenes.Scenes.None)


func _on_Credits_pressed():
	TransitionManager.transition_to(Scenes.Scenes.Credits)



func _on_TextureRect_gui_input(event):
	if tween.is_active(): return
	if event.is_action_pressed("click"):
		tween.interpolate_property(logo, "rect_scale:y", logo.rect_scale.y, -logo.rect_scale.y, 0.75, Tween.TRANS_CIRC)
		tween.start()

