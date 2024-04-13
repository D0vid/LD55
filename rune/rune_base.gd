extends Resource
class_name RuneBase

@export var sprite: Texture
@export var key: String

func _init(p_sprite = null, p_key = ""):
	sprite = p_sprite
	key = p_key
