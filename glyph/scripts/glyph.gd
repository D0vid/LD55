class_name Glyph extends Node2D


var length_in_blocks: int = 3
var validated = false

@onready var background: Sprite2D  = $Background

@onready var collider: CollisionShape2D  = $CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready():
	background.region_rect.size.x *= self.length_in_blocks
	collider.shape.extents *= Vector2(length_in_blocks, 0)

func size() -> Vector2: 
	return background.region_rect.size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
