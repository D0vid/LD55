class_name Glyph extends BaseTimelineObject

var length_in_blocks: int = 3
var drawing_ended = false
var handled = false
var glyph_shape_base: GlyphShapeBase

@onready var background: Sprite2D  = $Background

@onready var collider: CollisionShape2D  = $CollisionShape2D

func _ready():
	background.region_rect.size.x *= self.length_in_blocks
	var shape: RectangleShape2D = RectangleShape2D.new()
	shape.size = Vector2(10 * length_in_blocks, 0)
	collider.shape = shape

func size() -> Vector2: 
	return background.region_rect.size
