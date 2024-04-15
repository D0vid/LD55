extends Sprite2D

@export var health = 5

@onready var animation_player = $AnimationPlayer as AnimationPlayer
var timeline
var dead = false

signal died

func _ready():
	timeline = get_node("%Timeline")
	timeline.connect("hit", on_hit)
	timeline.connect("missed", on_missed)

func _process(delta):
	if dead:
		animation_player.play("dead")
	elif !animation_player.is_playing():
		animation_player.play("idle")
		
func die():
	dead = true
	died.emit()

func on_hit():
	if !dead:
		animation_player.play("hit")
	
func on_missed():
	if !dead:
		animation_player.play("miss")
		health -= 1
		if health <= 0:
			die()
