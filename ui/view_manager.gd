extends Control

@onready var main_menu = $MainMenu
@onready var game_viewport = $GameViewport
@onready var transition_rect = $TransitionRect

var views = []

func _ready():
	main_menu.get_node("%StartGameButton").connect("pressed", _on_start_game_button_pressed)
	views = [main_menu, game_viewport]
	pass

func _on_start_game_button_pressed():
	transition_to(game_viewport)

func transition_to(new_view):
	var tween = create_tween()
	tween.tween_property(transition_rect, "color:a", 1, 0.25)
	tween.tween_callback(func(): for view in views: view.visible = view == new_view);
	tween.tween_property(transition_rect, "color:a", 0, 0.25)
