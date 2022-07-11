extends KinematicBody2D

onready var area = $Area2D
onready var sprite = $Sprite

export var toggle = true
export(Dictionary) var signal_data

signal depressed
signal released

func _on_Area2D_body_entered(body):
	sprite.region_rect.position.x = 16
	if toggle: area.set_deferred("monitoring", false)
	emit_signal("depressed", signal_data)


func _on_Area2D_body_exited(body):
	if !toggle: sprite.region_rect.position.x = 0
	emit_signal("released", signal_data)
