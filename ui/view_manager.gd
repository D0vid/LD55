extends Control

@onready var main_menu = $MainMenu
@onready var game_viewport = $GameViewport
@onready var draw_viewport = $DrawViewport
@onready var dead_overlay = $DeadOverlay
@onready var transition_rect = $TransitionRect
@onready var intro = $Intro
@onready var wave_label = $WaveLabel

var summoning_scene = preload('res://summoning_table/summoning_table.tscn')
var audio1 = preload("res://audio_player/audio/grishnek_loop_1.ogg")
var music_test = preload("res://audio_player/audio/music_test.ogg")

var fx_player: AudioStreamPlayer = AudioPlayer.get_node("FXPlayer2");
var death_audio = preload("res://audio_player/audio/fx/Death.ogg")

var summoning_table_instance

var views = []

func _ready():
	main_menu.get_node("%StartGameButton").connect("pressed", _on_start_game_button_pressed)
	views = [main_menu, game_viewport, draw_viewport, intro, dead_overlay]
	intro.connect("start_game", on_start_game)
	
func _process(_delta):
	if dead_overlay.visible and Input.is_action_just_pressed("reset"):
		summoning_table_instance.queue_free()
		dead_overlay.color = Color(Color.BLACK, 1)
		on_start_game()
	
func on_start_game():
	music_test.loop = true
	AudioPlayer.stream = music_test
	AudioPlayer.pitch_scale = 1
	AudioPlayer.play()
	summoning_table_instance = summoning_scene.instantiate()
	game_viewport.get_node("SubViewport").add_child(summoning_table_instance)
	summoning_table_instance.get_node("Timeline").connect("new_wave", on_new_wave.bind())
	summoning_table_instance.get_node("Summoner").connect("died", on_died)
	transition_to([game_viewport, draw_viewport], on_new_wave.bind(1))
	
func on_new_wave(wave_number):
	var text = "Wave " + str(wave_number)
	if wave_number > 1:
		text += "\nThe chanting intensifies"
	wave_label.text = text
	var anim_player = wave_label.get_node("AnimationPlayer") as AnimationPlayer
	anim_player.play("new_wave")
	
func on_died():
	fx_player.stream = death_audio
	fx_player.play()
	dead_overlay.color = Color(Color.BLACK, 0.5)
	dead_overlay.visible = true

func _on_start_game_button_pressed():
	audio1.loop = true
	AudioPlayer.stream = audio1
	AudioPlayer.play()

	transition_to([intro])

func transition_to(new_views: Array, callback = null):
	var tween = create_tween()
	tween.tween_property(transition_rect, "color:a", 1, 1)
	tween.tween_callback(func(): 
		for view in views: view.visible = new_views.has(view)
		if callback != null:
			callback.call()
	);
	tween.tween_property(transition_rect, "color:a", 0, 1)
