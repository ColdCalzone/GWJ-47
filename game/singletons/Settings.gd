extends Node

const CONFIG_PATH = "user://settings.cfg"

var music_volume : float = 1.0 setget set_music_volume
var sound_volume : float = 1.0 setget set_sound_volume
var fullscreen : bool = false setget set_fullscreen
var backgrounds : bool = true setget set_background

var colors = [
			Color("265c42"),
			Color("f77622"),
			Color("e43b44"),
			Color("124e89"),
			Color("5a6988")
		]

var config : ConfigFile

func load_config():
	config = ConfigFile.new()
	var err = config.load(CONFIG_PATH)
	if err == ERR_FILE_NOT_FOUND:
		err = config.save(CONFIG_PATH)
	if err == OK:
		set_music_volume(config.get_value("sound", "music_volume", 1.0))
		set_sound_volume(config.get_value("sound", "sound_volume", 1.0))
		set_fullscreen(config.get_value("video", "fullscreen", false))
		set_background(config.get_value("video", "backgrounds", true))
		set_colors(config.get_value("video", "colors", [
			Color("265c42"),
			Color("f77622"),
			Color("e43b44"),
			Color("124e89"),
			Color("5a6988")
		]))

func save_config():
	config.set_value("sound", "music_volume", music_volume)
	config.set_value("sound", "sound_volume", sound_volume)
	config.set_value("video", "fullscreen", fullscreen)
	config.set_value("video", "backgrounds", backgrounds)
	config.set_value("video", "colors", colors)
	config.save(CONFIG_PATH)

func set_music_volume(value):
	music_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(music_volume))

func set_sound_volume(value):
	sound_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(sound_volume))

func set_fullscreen(value):
	fullscreen = value
	OS.set_window_fullscreen(fullscreen)

func set_background(value):
	Bg.visible = value
	backgrounds = value

func set_colors(array):
	for i in range(array.size()):
		set_color(array[i], i)

func set_color(value, id):
	colors[id] = value
