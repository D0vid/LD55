extends Sprite2D

@export var timeline_speed = 100
var rune_scene = preload("res://rune/rune.tscn")
var rune_up = preload("res://rune/rune_up.tres")
var rune_down = preload("res://rune/rune_down.tres")
var rune_left = preload("res://rune/rune_left.tres")
var rune_right = preload("res://rune/rune_right.tres")
var rune_spacebar = preload("res://rune/rune_spacebar.tres")
var rune_bases = [rune_up, rune_down, rune_left, rune_right, rune_spacebar]
var tap_zone : Area2D
var actions = ["up", "down", "left", "right", "spacebar"]
var actions_in_tap_zone = []

func _ready():
	tap_zone = get_node("%RuneTapZone")
	tap_zone.connect("rune_missed", on_rune_missed.bind())
	for i in range(5):
		var rune = rune_scene.instantiate()
		rune.position = Vector2(153 + (i * 14), 7)
		rune.name += str(i)
		rune.rune_base = rune_bases[i]
		add_child(rune)
		print("added " + rune.rune_base.key)

func _process(delta):
	actions_in_tap_zone.clear()
	for rune in get_children():
		# Move runes in the timeline
		rune.position -= Vector2(delta * timeline_speed, 0)
		# Check if a rune is in the tap zone -> validate it
		if Input.is_action_just_pressed(rune.rune_base.key) and rune.overlaps_area(tap_zone):
			print("validated [" + rune.rune_base.key + "] key for rune " + rune.name)
			rune.validated = true
			rune.queue_free()
		# Add action to list to check
		if tap_zone.overlaps_area(rune):
			actions_in_tap_zone.push_back(rune.rune_base.key)
	# Handle misses due to tapping too early
	for action in actions:
		if (get_children().size() > 0 
		and Input.is_action_just_pressed(action) 
		and !actions_in_tap_zone.has(action)):
			get_child(0).queue_free()
			print("too early")

func on_rune_missed(rune):
	print("too late")
	rune.queue_free()
