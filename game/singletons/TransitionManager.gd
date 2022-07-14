extends CanvasLayer

onready var tween : Tween = $Tween
onready var color : ColorRect = $Color

onready var _scenes = {
	Scenes.Scenes.Titlescreen: load("res://scenes/Titlescreen.tscn"),
	Scenes.Scenes.Settings: load("res://scenes/Settings.tscn"),
	Scenes.Scenes.Credits: load("res://scenes/Credits.tscn"),
	Scenes.Scenes.LevelSelect: load("res://scenes/LevelSelect.tscn"),
	Scenes.Scenes.Thanks: load("res://scenes/Thanks.tscn"),
	Scenes.Scenes.Game: 0,
	Scenes.Scenes.None : 0
}

func transition_to(to, level : int = -1):
	var scene = _scenes.get(to)
	if scene == null: return
	# this is ugly but I hate warnings
	var _x = tween.interpolate_property(color, "color:a", 0, 1.0, 0.2)
	var _y = tween.interpolate_property(color, "color:a", 1, 0.0, 0.2, 0, 2, 0.25)
	var _z = tween.start()
	yield(tween, "tween_completed")
	if to != Scenes.Scenes.None:
		if to == Scenes.Scenes.Game:
			if level > -1:
				LevelData.current_level = level
			Bg.rect_scale = Vector2.ONE * 0.5
			var _a = get_tree().change_scene_to(LevelData.levels[LevelData.current_level].level)
		else:
			Bg.rect_scale = Vector2.ONE
			var _a = get_tree().change_scene_to(scene)
	else:
		get_tree().quit()

func game_win_handler():
	LevelData.set_level_beaten(LevelData.current_level)
	var beaten = 0
	for level in LevelData.save_data["levels"].values():
		beaten += int(level["beaten"])
	if beaten == LevelData.save_data["levels"].size():
		TransitionManager.transition_to(Scenes.Scenes.Thanks)
	else:
		TransitionManager.transition_to(Scenes.Scenes.LevelSelect)
	
