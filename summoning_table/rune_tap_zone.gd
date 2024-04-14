extends Area2D

signal rune_missed

func _ready():
	pass

func _on_area_exited(area):
	if area is Rune and !area.validated:
		var rune = area as Rune
		rune_missed.emit(rune)
