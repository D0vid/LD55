class_name Rune extends BaseTimelineObject

@export var rune_base: RuneBase
@onready var sprite = $Sprite2D as Sprite2D

func _ready():
	sprite.texture = rune_base.sprite
	pass

func size() -> Vector2:
	return Vector2(10, 10)

func get_action() -> String:
	return self.rune_base.key
