extends Sprite2D

@export var hit_sprite: Texture2D
@export var miss_sprite: Texture2D

@onready var timeline = %Timeline
@onready var tap_zone = %RuneTapZone
@onready var summoner = $Summoner

var miss_audio = preload("res://audio_player/audio/fx/Miss.ogg")
var hit_audio = preload("res://audio_player/audio/fx/Hit.ogg")


var fx_player: AudioStreamPlayer = AudioPlayer.get_node("FXPlayer");


var popup_scene = preload("res://popup_effect/popup_effect.tscn")
var popup_position

func _ready():
	popup_position = tap_zone.position
	timeline.connect("hit", on_hit)
	timeline.connect("missed", on_missed)
	
func on_hit():
	fx_player.stream = hit_audio
	fx_player.play()
	if summoner.dead: return
	var popup = popup_scene.instantiate() as PopupEffect
	popup.position = popup_position
	popup.sprite = hit_sprite
	add_child(popup)
	
func on_missed():
	fx_player.stream = miss_audio
	fx_player.play()

	if summoner.dead: return
	var popup = popup_scene.instantiate() as PopupEffect
	popup.position = popup_position
	popup.sprite = miss_sprite
	add_child(popup)
