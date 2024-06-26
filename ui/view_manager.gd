extends Control

@onready var main_menu = $MainMenu
@onready var game_viewport = $GameViewport
@onready var draw_viewport = $DrawViewport
@onready var dead_overlay = $DeadOverlay
@onready var transition_rect = $TransitionRect
@onready var intro = $Intro
@onready var wave_label = $WaveLabel
@onready var wave_death_label = get_node("%WaveDeathLabel")
@onready var combo_label = $ComboLabel

var summoning_scene = preload('res://summoning_table/summoning_table.tscn')
var audio1 = preload("res://audio_player/audio/grishnek_loop_1.ogg")
var main_theme_intro = preload("res://audio_player/audio/main/Main_Theme_Intro.ogg")

var fx_player: AudioStreamPlayer = AudioPlayer.get_node("FXPlayer2");
var death_audio = preload("res://audio_player/audio/fx/Death.ogg")

var summoning_table_instance

var views = []
var combo = 0
var max_combo = 0

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
	max_combo = 0
	AudioPlayer.stream = main_theme_intro
	AudioPlayer.pitch_scale = 1
	AudioPlayer.play()
	summoning_table_instance = summoning_scene.instantiate()
	game_viewport.get_node("SubViewport").add_child(summoning_table_instance)
	summoning_table_instance.get_node("Timeline").connect("new_wave", on_new_wave.bind())
	summoning_table_instance.get_node("Timeline").connect("hit", on_hit)
	summoning_table_instance.get_node("Timeline").connect("missed", on_missed)
	summoning_table_instance.get_node("Summoner").connect("died", on_died)
	transition_to([game_viewport, draw_viewport], on_new_wave.bind(1))

func on_hit():
	combo += 1
	update_combo_label()
	if combo % 25 == 0:
		summoning_table_instance.get_node("Summoner").add_health()
		summoning_table_instance.get_node("%HealthBar").add_health()
		summoning_table_instance.on_combo()
	
func on_missed():
	max_combo = maxi(combo, max_combo)
	combo = 0
	update_combo_label()
	
func update_combo_label():
	combo_label.visible = combo > 0
	combo_label.text = "x" + str(combo)

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
	var wave_number = summoning_table_instance.get_node("Timeline").current_wave
	wave_death_label.text = "Wave " + str(wave_number + 1) + "\nMax combo : x" + str(max_combo)
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
