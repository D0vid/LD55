class_name GlyphShape extends Area2D

@export var base: GlyphShapeBase

@onready var sprite = $Sprite2D as Sprite2D
@onready var collider = $CollisionPolygon2D as CollisionPolygon2D

func _ready():
	reload_glyph_base()

func _on_visibility_changed():
	call_deferred("reload_glyph_base")
	
func reload_glyph_base():
	if !sprite or !collider:
		return
	sprite.texture = base.sprite
	collider.polygon = base.collider
