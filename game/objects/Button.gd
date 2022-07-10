extends KinematicBody2D

onready var area = $Area2D
onready var sprite = $Sprite

signal depressed

func _on_Area2D_body_entered(body):
	sprite.region_rect.position.x = 16
	area.set_deferred("monitoring", false)
	emit_signal("depressed")
