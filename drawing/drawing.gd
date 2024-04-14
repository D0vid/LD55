class_name Drawing extends Node2D

var drawing_vertices: Array[Vector2] = []

var rate_limited_drawing_vertices: Array[Vector2]  = []


var drawing = false
var ended = false

@export var sampling_rate_sec = 0.10


var time_since_last_draw_sec = sampling_rate_sec

# signals
signal drawing_ended


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	if !drawing_vertices.is_empty():
		for current_index in self.drawing_vertices.size():
			draw_circle(drawing_vertices[current_index], 10, Color.RED)
			if current_index >= 1:
				draw_line(drawing_vertices[current_index-1], drawing_vertices[current_index], Color.BLUE, 5)

		for current_index in self.rate_limited_drawing_vertices.size():
			draw_circle(rate_limited_drawing_vertices[current_index], 15, Color.GREEN)
			if current_index >= 1:
				draw_line(rate_limited_drawing_vertices[current_index-1], rate_limited_drawing_vertices[current_index], Color.BROWN, 10)
				

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.is_released():
			self.drawing = false
			self.ended = true
			drawing_vertices.push_back(event.position)
			rate_limited_drawing_vertices.push_back(event.position)
			drawing_ended.emit()

		elif event.is_pressed():
			self.drawing = true

	elif event is InputEventMouseMotion:
		if self.drawing && !self.ended:
			if time_since_last_draw_sec >= sampling_rate_sec:
				rate_limited_drawing_vertices.push_back(event.position)
				self.time_since_last_draw_sec = 0
			drawing_vertices.push_back(event.position)
			


func get_normalized_drawing() -> CombinedPath:
	return CombinedPath.new(rate_limited_drawing_vertices)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	queue_redraw()
	time_since_last_draw_sec += delta

func reset(): 
	self.rate_limited_drawing_vertices = []
	self.drawing_vertices = []
	self.time_since_last_draw_sec = sampling_rate_sec
	self.drawing = false
	self.ended = false
