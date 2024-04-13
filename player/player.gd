extends Sprite2D

@export var move_speed = 100

func _process(delta):
	if position.y > -16 * 5:
		position -= Vector2(0, delta * move_speed)
	else:
		position = Vector2(0, -16 * 5)
