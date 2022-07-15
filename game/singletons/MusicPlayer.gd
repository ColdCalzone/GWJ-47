extends AudioStreamPlayer

onready var tween = $Tween

var _music_files = {
	"res://music/mamus_titlescreen_draft.ogg": preload("res://music/mamus_titlescreen_draft.ogg"),
	"res://music/mamus_level_draft.ogg": preload("res://music/mamus_level_draft.ogg"),
}

var current_song : String

func load_file(file, play : bool = false, volume : float = 0):
	if current_song == file and playing: return
	tween.interpolate_property(self, "volume_db", self.volume_db, -80, 0.2)
	tween.interpolate_property(self, "volume_db", -10, volume, 0.1, 0, 2, 0.25)
	if !_music_files.has(file):
		_music_files[file] = load(file)
	tween.start()
	yield(tween, "tween_completed")
	current_song = file
	stream = _music_files[file]
	if play: play()
