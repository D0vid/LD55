extends Node2D

@onready var canvas : Drawing = get_node("Drawing") as Drawing

var normalized_array: Array[CombinedPath] = []


# Called when the node enters the scene tree for the first time.
func _ready():
	self.canvas.connect("drawing_ended", on_drawing_ended)
	self.canvas.enabled = true
	self.canvas.debug = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_drawing_ended(thing, two):
	print(self.canvas.current_rate_limited_path)
	
	normalized_array.push_back(thing)
	self.canvas.next_drawing();

	if self.normalized_array.size() == 2:
		var result = self.compare_two_arrays(normalized_array[0], normalized_array[1])
		print("IS SAME SHAPE??? " + str(result))
		
		var result_reverse = self.compare_two_arrays(normalized_array[0].get_reverse(), normalized_array[1])
		print("IS SAME SHAPE IN REVERSE?? " + str(result_reverse))
		normalized_array=[]

func compare_two_arrays(array1: CombinedPath, array2: CombinedPath) -> bool:
	var percentage = array1.compare_in_percentage(array2)
	print("percentage of discreptancy: " + str(percentage))
	return percentage >= 60