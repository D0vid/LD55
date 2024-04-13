extends Area2D

@export var rune_base: RuneBase
var rune_tap_zone: Area2D
var validated = false

func _ready():
	rune_tap_zone = get_node("../../RuneTapZone")

func _physics_process(_delta):
	if Input.is_action_just_pressed(rune_base.key) and overlaps_area(rune_tap_zone) and !validated:
		print("validated [" + rune_base.key + "] key for rune " + name)
		validated = true
