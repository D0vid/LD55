extends Sprite2D

@export var timeline_speed = 100
var rune_scene = preload("res://rune/rune.tscn")

func _ready():
	for i in 5:
		var rune = rune_scene.instantiate()
		rune.position = Vector2(153 + (i * 14), 7)
		rune.name += str(i)
		add_child(rune)

func _process(delta):
	for child in get_children():
		child.position -= Vector2(delta * timeline_speed, 0)
		if child.position.x <= 0:
			child.queue_free()
	pass
