extends Control

@onready var main_menu = $MainMenu
@onready var game_viewport = $GameViewport
@onready var draw_viewport = $DrawViewport
@onready var transition_rect = $TransitionRect
@onready var intro = $Intro

var summoning_scene = preload('res://summoning_table/summoning_table.tscn')

var views = []

func _ready():
	main_menu.get_node("%StartGameButton").connect("pressed", _on_start_game_button_pressed)
	main_menu.get_node("%StartGameNoIntro").connect("pressed", on_start_game)
	views = [main_menu, game_viewport, draw_viewport, intro]
	intro.connect("start_game", on_start_game)
	
func on_start_game():
	var instance = summoning_scene.instantiate()
	game_viewport.get_node("SubViewport").add_child(instance)
	transition_to([game_viewport, draw_viewport])

func _on_start_game_button_pressed():
	transition_to([intro])

func transition_to(new_views: Array):
	var tween = create_tween()
	tween.tween_property(transition_rect, "color:a", 1, 1)
	tween.tween_callback(func(): for view in views: view.visible = new_views.has(view));
	tween.tween_property(transition_rect, "color:a", 0, 1)
