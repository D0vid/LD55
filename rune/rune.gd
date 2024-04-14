class_name Rune extends Area2D

@export var rune_base: RuneBase
var rune_tap_zone: Area2D
var validated = false

func _ready():
	rune_tap_zone = get_node("../../RuneTapZone")
