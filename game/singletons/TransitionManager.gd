extends CanvasLayer

onready var tween : Tween = $Tween
onready var color : ColorRect = $Color

onready var _scenes = {
	Scenes.Scenes.Titlescreen: load("res://scenes/Titlescreen.tscn"),
	Scenes.Scenes.LevelSelect: load("res://scenes/LevelSelect.tscn"),
	Scenes.Scenes.Game: load("res://scenes/Game.tscn"),
}

func transition_to(to):
	var scene = _scenes.get(to)
	if scene == null: return
	tween.interpolate_property(color, "color:a", 0, 1.0, 0.2)
	tween.interpolate_property(color, "color:a", 1, 0.0, 0.2, 0, 2, 0.25)
	tween.start()
	yield(tween, "tween_completed")
	get_tree().change_scene_to(scene)
