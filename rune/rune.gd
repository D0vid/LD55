class_name Rune extends Area2D

@export var rune_base: RuneBase
@onready var sprite = $Sprite2D as Sprite2D
var validated = false

func _ready():
	sprite.texture = rune_base.sprite
	pass
