extends Node

const SAVE_PATH = "user://save.json"

var save_data : Dictionary = {
	"levels": {},
	"thanked" : false
}

class Level:
	var level
	var level_name
	var description
	var display_name
	var preview
	static func sort(a, b):
		return a.level_name < b.level_name

var levels = [
]
# grrrrr
var names = {
	"level1": "Absolutely Pivoting",
	"level2": "Reflect on that.",
	"level3": "Pushing all your buttons.",
	"level4": "Triple Trouble",
	"level5": "Paradigm Shift.",
}
var descriptions = {
	"level1": "Move the block to make both sides match!",
	"level2": "Move the block and clear away the colors to make both sides match!",
	"level3": "Get the block across!",
	"level4": "Make all the colors blank to win!",
	"level5": "Corporate needs you to find the difference between these two pictures.",
}

var jank_descriptions = {
	"level4": "This level has a few collision issues,\nit should not interfere with the experience.",
	"level5": "This level has a collision issue that will cause Mamus to enter a temporarily enter a wall.\nIt may interfere with the experience.",
}

var current_level : int = 0

func _ready():
	var save_file = File.new()
	if save_file.open(SAVE_PATH, File.READ) == OK:
		save_data = JSON.parse(save_file.get_as_text()).result
		save_file.close()
	var dir : Directory = Directory.new()
	if dir.open("res://scenes/levels") == OK:
		if dir.list_dir_begin(true) == OK:
			var file_name = dir.get_next()
			while file_name != "":
				if dir.current_is_dir():
					var level_data = Level.new()
					level_data.level = load("res://scenes/levels/" + file_name + "/level.tscn")
					level_data.preview = load("res://scenes/levels/" + file_name + "/preview.png")
					level_data.level_name = file_name
					level_data.display_name = names[file_name]
					level_data.description = descriptions[file_name]
					if !save_data["levels"].has(file_name):
						save_data["levels"][file_name] = {
							"beaten": false
						}
						save()
					levels.push_back(level_data)
				file_name = dir.get_next()
			dir.list_dir_end()
	else:
		print("An error occurred when trying to access the path.")
	levels.sort_custom(Level, "sort")

func set_level_beaten(level):
	save_data["levels"]["level" + String(level + 1)]["beaten"] = true
	save()

func save():
	var save_file = File.new()
	if save_file.open(SAVE_PATH, File.WRITE) == OK:
		save_file.store_string(JSON.print(save_data))
		save_file.close()
