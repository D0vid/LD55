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
	timeline.connect("speed_up", on_speed_up)

func _process(_delta):
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
			
func on_speed_up():
	animation_player.speed_scale += 0.5
	
func add_health(amount = 1):
	if !dead and health < 10:
		health += amount
		print("+" + str(amount) + " HP")
