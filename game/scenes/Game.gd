extends Node2D

export(Array) var sym_offsets = [
	Vector2(0, 0)
]

onready var dynamic_tilemaps : Array = get_tree().get_nodes_in_group("Dynamic")

onready var camera = $Camera2D

const PAUSE = preload("res://objects/Pause.tscn")

onready var win_particles = [$WinParticles, $WinParticles2]

onready var level_complete = $Victory

func _ready():
	var buttons = get_tree().get_nodes_in_group("Button")
	for button in buttons:
		button.connect("depressed", self, "toggle_colors")
		button.connect("released", self, "toggle_colors")
	for player in get_tree().get_nodes_in_group("player"):
		player.connect("player_died", self, "game_over")
	for block in get_tree().get_nodes_in_group("MoveableBlock"):
		block.connect("moved", self, "check_symmetry")

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		var playback_pos = MusicPlayer.get_playback_position()
		add_child(PAUSE.instance())
		MusicPlayer.play(playback_pos)

func restart():
	TransitionManager.transition_to(Scenes.Scenes.Game)

# colors is an array of ints - 0 for green, 1 for blue, 2 for red
func toggle_colors(colors):
	if colors is Array:
		var blocks = get_tree().get_nodes_in_group("MoveableBlock")
		var buttons = get_tree().get_nodes_in_group("Button")
		for block in range(blocks.size()):
			blocks[block] = blocks[block].position
		for color in colors:
			for dynamic_tilemap in dynamic_tilemaps:
				var outline = dynamic_tilemap.get_used_cells_by_id(color * 2)
				var solid = dynamic_tilemap.get_used_cells_by_id(color * 2 + 1)
				for cell in outline:
					if blocks.has(cell * 16 + (Vector2.ONE * 8)):
						continue
					dynamic_tilemap.set_cellv(cell, color * 2 + 1)
					dynamic_tilemap.update_bitmask_area(cell)
				for cell in solid:
					dynamic_tilemap.set_cellv(cell, color * 2)
					dynamic_tilemap.update_bitmask_area(cell)
			for button in buttons:
				if button.color == color + 1:
					button.enabled = !button.enabled
		check_symmetry()

func check_symmetry(_x = null):
	var symmetrical = true
	var tilemap_used_positions = []
	for dyn in dynamic_tilemaps:
		var tilemap : TileMap = dyn
		var used_positions = []
		used_positions.append_array(tilemap.get_used_cells_by_id(1))
		used_positions.append_array(tilemap.get_used_cells_by_id(3))
		used_positions.append_array(tilemap.get_used_cells_by_id(5))
		tilemap_used_positions.push_back(used_positions)
	for i in range(tilemap_used_positions.size() - 1):
		if tilemap_used_positions[i].size() != tilemap_used_positions[i + 1].size():
			symmetrical = false
			break
		for x in range(tilemap_used_positions[i].size()):
			if tilemap_used_positions[i].find(tilemap_used_positions[i + 1][x]) ==-1:
				symmetrical = false
				break
		if !symmetrical: break
	var blocks = get_tree().get_nodes_in_group("MoveableBlock")
	var block_positions = []
	for x in range(blocks.size()):
		if block_positions.size() < blocks[x].world + 1:
			block_positions.push_back([])
		block_positions[blocks[x].world].push_back(blocks[x].position + sym_offsets[blocks[x].world - 1])
	for world in range(block_positions.size() - 1):
		for block in range(block_positions[world].size()):
			if block_positions[world].find(block_positions[world + 1][block]) == -1:
				symmetrical = false
				break
		if !symmetrical: break
	if symmetrical:
		win()

func win():
	MusicPlayer.stop()
	# Jank way to make the players stop moving
	for player in get_tree().get_nodes_in_group("player"):
		player.dead = true
	for block in get_tree().get_nodes_in_group("MoveableBlock"):
		for area in block.areas:
			area.monitoring = false
	var tween = Tween.new()
	add_child(tween)
	for part in win_particles:
		part.emitting = true
		tween.interpolate_property(part, "position:x", part.position.x, abs(part.position.x - 400), 3.0, Tween.TRANS_QUAD)
	tween.start()
	level_complete.play()
	yield(level_complete, "finished")
	TransitionManager.transition_to(Scenes.Scenes.LevelSelect)

func game_over():
	yield(get_tree().create_timer(1.0), "timeout")
	var game_over = PAUSE.instance()
	game_over.mode = 1
	add_child(game_over)
