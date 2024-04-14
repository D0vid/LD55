class_name PopupEffect extends Sprite2D

@export var sprite: Texture

func _ready():
	texture = sprite
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.5)
	tween.parallel().tween_property(self, "position", position - Vector2(0, 16), 0.5)
	tween.tween_property(self, "modulate", Color(Color.WHITE, 0), 0.5).set_trans(Tween.TRANS_EXPO)
	tween.tween_callback(queue_free)
