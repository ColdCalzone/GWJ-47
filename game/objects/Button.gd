extends KinematicBody2D

onready var area = $Area2D
onready var collision = $CollisionShape2D
onready var sprite = $Sprite

export var only_once = true
export var toggle = true
export(Dictionary) var signal_data
export var color = -1
export var enabled = true setget set_enabled, get_enabled

var value : bool = false

signal depressed
signal released

func _ready():
	color += 1
	sprite.region_rect.position.x = (16 * int(value)) + (color * 32 * int(!enabled))
	collision.disabled = !enabled
	area.monitoring = enabled

func set_enabled(val):
	enabled = val
	if area is Area2D:
		area.set_deferred("monitoring", enabled and !(only_once and value))
	if collision is CollisionShape2D:
		collision.set_deferred("disabled", !enabled)
	if sprite is Sprite:
		sprite.region_rect.position.x = (16 * int(value)) + (color * 32 * int(!enabled))

func get_enabled():
	return enabled

func _on_Area2D_body_entered(body):
	value = true
	sprite.region_rect.position.x = (16 * int(value)) + (color * 32 * int(!enabled))
	if only_once: area.set_deferred("monitoring", false)
	emit_signal("depressed", signal_data)


func _on_Area2D_body_exited(body):
	if !only_once:
		value = false
		sprite.region_rect.position.x = 0 + (color * 32 * int(!enabled))
	if !toggle:
		emit_signal("released", signal_data)
