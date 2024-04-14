extends Control

@export var scale_speed = 1

@onready var transition_rect = $TransitionRect
@onready var summoner = $Summoner

var labels: Array[Label] = []
var current_label_index = 0
var transitioning = false
var first_click = true

signal start_game

func _ready():
	for child in get_children():
		if child is Label:
			labels.push_back(child)
			
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed and !transitioning and !first_click:
			if current_label_index == labels.size() - 1:
				start_game.emit()
			current_label_index += 1
			transition_to(current_label_index)
		if first_click: # hack to prevent first mouse click input when pressing start game
			first_click = false
			
func transition_to(label_index):
	transitioning = true
	var tween = create_tween()
	tween.tween_property(transition_rect, "color:a", 1, 1)
	tween.tween_callback(func():
		for label in labels: label.visible = label_index == labels.find(label)
		summoner.scale += Vector2(3, 3)
		summoner.modulate.a += 1.0 / 7
		if label_index >= 7:
			summoner.visible = false
	)
	tween.tween_property(transition_rect, "color:a", 0, 1)
	transitioning = false
