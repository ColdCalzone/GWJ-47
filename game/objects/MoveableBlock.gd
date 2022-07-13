extends KinematicBody2D

export var activated_arrows = 0
export var world = 0

onready var arrows = $Arrows

onready var tween = $Tween

onready var world_left = $WorldCheckLeft
onready var world_right = $WorldCheckRight
onready var world_down = $WorldCheckDown
onready var world_up = $WorldCheckUp

onready var areas = [
	$Top,
	$Left,
	$Right,
	$Bottom,
]

var area_state = [
	true,
	true,
	true,
	true,
]

signal moved

func _ready():
	arrows.activated_arrows = activated_arrows
	for x in range(4):
		area_state[x] = 0 < activated_arrows & int(pow(2, x))
		areas[x].monitoring = area_state[x]

func _on_Top_body_entered(_b):
	if world_up.is_colliding(): return
	tween.interpolate_property(self, "position:y", position.y, position.y + 16, 0.5)
	for area in areas:
		area.set_deferred("monitoring", false)
	tween.start()
	yield(tween, "tween_all_completed")
	for x in range(4):
		areas[x].monitoring = area_state[x]
	emit_signal("moved")

func _on_Bottom_body_entered(_b):
	if world_down.is_colliding(): return
	tween.interpolate_property(self, "position:y", position.y, position.y - 16, 0.5)
	for area in areas:
		area.set_deferred("monitoring", false)
	tween.start()
	yield(tween, "tween_all_completed")
	for x in range(4):
		areas[x].monitoring = area_state[x]
	emit_signal("moved")

func _on_Left_body_entered(_b):
	if world_left.is_colliding(): return
	tween.interpolate_property(self, "position:x", position.x, position.x + 16, 0.5)
	for area in areas:
		area.set_deferred("monitoring", false)
	tween.start()
	yield(tween, "tween_all_completed")
	for x in range(4):
		areas[x].monitoring = area_state[x]
	emit_signal("moved")

func _on_Right_body_entered(_b):
	if world_right.is_colliding(): return
	tween.interpolate_property(self, "position:x", position.x, position.x - 16, 0.5)
	for area in areas:
		area.set_deferred("monitoring", false)
	tween.start()
	yield(tween, "tween_all_completed")
	for x in range(4):
		areas[x].monitoring = area_state[x]
	emit_signal("moved")
