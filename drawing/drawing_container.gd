extends Node2D

@onready var canvas : Drawing = get_node("Node2D") as Drawing

var normalized_array: Array[CombinedPath] = []


# Called when the node enters the scene tree for the first time.
func _ready():
	self.canvas.connect("drawing_ended", on_drawing_ended)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_drawing_ended():
	var normalized = self.canvas.get_normalized_drawing()
	normalized_array.push_back(normalized)
	self.canvas.reset();

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



	




