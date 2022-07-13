extends AudioStreamPlayer

var _music_files = {
	"res://music/mamus_titlescreen_draft.ogg": preload("res://music/mamus_titlescreen_draft.ogg")
}

var current_song : String

func load_file(file, play : bool = false, volume : float = 0):
	if current_song == file and playing: return
	volume_db = volume
	if !_music_files.has(file):
		_music_files[file] = load(file)
	current_song = file
	stream = _music_files[file]
	if play: play()
