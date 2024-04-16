extends TextureProgressBar

var timeline

func _ready():
	timeline = get_node("%Timeline")
	timeline.connect("missed", on_missed)

func on_missed():
	if value > 0:
		value -= 1

func add_health(amount = 1):
	if value < 10:
		value += amount
