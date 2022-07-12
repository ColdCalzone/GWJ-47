extends CanvasLayer

onready var tween : Tween = $Tween
onready var color : ColorRect = $Color

onready var _scenes = {
	Scenes.Scenes.Titlescreen: load("res://scenes/Titlescreen.tscn"),
	Scenes.Scenes.Settings: load("res://scenes/Settings.tscn"),
	Scenes.Scenes.Credits: load("res://scenes/Credits.tscn"),
	Scenes.Scenes.LevelSelect: load("res://scenes/LevelSelect.tscn"),
	Scenes.Scenes.Game: load("res://scenes/Game.tscn"),
}

func transition_to(to):
	var scene = _scenes.get(to)
	if scene == null: return
	# this is ugly but I hate warnings
	var _x = tween.interpolate_property(color, "color:a", 0, 1.0, 0.2)
	var _y = tween.interpolate_property(color, "color:a", 1, 0.0, 0.2, 0, 2, 0.25)
	var _z = tween.start()
	yield(tween, "tween_completed")
	var _a = get_tree().change_scene_to(scene)
