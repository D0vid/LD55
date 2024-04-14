class_name Drawing extends Node2D

var previous_paths = []

var current_path: PackedVector2Array = []
var current_rate_limited_path: PackedVector2Array  = []

var drawing = false

var enabled = true

@export var sampling_rate_sec = 0.10


var time_since_last_draw_sec = sampling_rate_sec

# signals
signal drawing_ended(combined_path)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():

	for path: PackedVector2Array in self.previous_paths:
		draw_polyline(path, Color.DARK_RED, 15)


	if current_path.size() > 1:
		draw_polyline(self.current_path, Color.RED, 15)
		#draw_polyline(self.current_rate_limited_path, Color.BROWN, 10)

func _input(event):
	if event is InputEventMouseButton:
		if event.is_released():
			self.drawing = false
			current_path.push_back(event.position)
			current_rate_limited_path.push_back(event.position)
			drawing_ended.emit(CombinedPath.new(self.current_rate_limited_path))
			next_drawing()
		elif event.is_pressed():
			self.drawing = true

	elif event is InputEventMouseMotion:
		if self.drawing && self.enabled:
			if time_since_last_draw_sec >= sampling_rate_sec:
				current_rate_limited_path.push_back(event.position)
				self.time_since_last_draw_sec = 0
			current_path.push_back(event.position)
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	queue_redraw()
	time_since_last_draw_sec += delta

func next_drawing():
	self.previous_paths.push_back(current_path)
	self.current_rate_limited_path = []
	self.current_path = []
	self.time_since_last_draw_sec = sampling_rate_sec
	self.drawing = false
