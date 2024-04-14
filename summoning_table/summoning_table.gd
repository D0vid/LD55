extends Sprite2D

@export var hit_sprite: Texture2D
@export var miss_sprite: Texture2D

@onready var timeline = %Timeline
@onready var tap_zone = %RuneTapZone
@onready var summoner = $Summoner

var popup_scene = preload("res://popup_effect/popup_effect.tscn")
var popup_position

func _ready():
	popup_position = tap_zone.position
	timeline.connect("hit", on_hit)
	timeline.connect("missed", on_missed)
	
func on_hit():
	if summoner.dead: return
	var popup = popup_scene.instantiate() as PopupEffect
	popup.position = popup_position
	popup.sprite = hit_sprite
	add_child(popup)
	
func on_missed():
	if summoner.dead: return
	var popup = popup_scene.instantiate() as PopupEffect
	popup.position = popup_position
	popup.sprite = miss_sprite
	add_child(popup)
