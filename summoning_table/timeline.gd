extends Sprite2D

@export var timeline_speed = 100
var rune_scene = preload("res://rune/rune.tscn")
var tap_zone : Area2D
var actions = ["up", "down", "left", "right", "spacebar"]
var actions_in_tap_zone = []

func _ready():
	tap_zone = get_node("%RuneTapZone")
	for i in 5:
		var rune = rune_scene.instantiate()
		rune.position = Vector2(153 + (i * 14), 7)
		rune.name += str(i)
		add_child(rune)

func _process(delta):
	actions_in_tap_zone.clear()
	for rune in get_children():
		rune.position -= Vector2(delta * timeline_speed, 0)
		if Input.is_action_just_pressed(rune.rune_base.key) and rune.overlaps_area(tap_zone):
			print("validated [" + rune.rune_base.key + "] key for rune " + rune.name)
			rune.validated = true
			rune.queue_free()
		if rune.position.x <= 0:
			rune.queue_free()
		if tap_zone.overlaps_area(rune):
			actions_in_tap_zone.push_back(rune.rune_base.key)
	for action in actions:
		if Input.is_action_just_pressed(action) and !actions_in_tap_zone.has(action):
			print("miss")
			
			
