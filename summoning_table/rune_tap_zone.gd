extends Area2D

func _ready():
	pass

func _on_area_exited(area):
	if area is Rune and !area.validated:
		print("fail")
