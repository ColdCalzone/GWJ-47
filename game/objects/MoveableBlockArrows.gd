tool
extends Node

enum Arrow {
	Down = 1
	Right = 2
	Left = 4
	Up = 8
}

export var activated_arrows = 0 setget set_arrows

onready var arrows = [
	$ArrowDown,
	$ArrowRight,
	$ArrowLeft,
	$ArrowUp,
]

func set_arrows(value : int):
	activated_arrows = value
	for x in range(4):
		arrows[x].visible = 0 < activated_arrows & int(pow(2, x))
