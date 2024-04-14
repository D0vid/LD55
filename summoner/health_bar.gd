extends TextureProgressBar

var timeline

func _ready():
	timeline = get_node("%Timeline")
	timeline.connect("missed", on_missed)
	pass

func on_missed():
	value -= 1
