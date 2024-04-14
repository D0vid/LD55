class_name CombinedPath 

#Array[Array[CombinedVector2]]
var input_path: PackedVector2Array
var path = []

func _init(input_path):
	self.input_path = input_path
	for current_index in input_path.size():
		if current_index+2 < input_path.size():
			var start_point: Vector2 = input_path[current_index]
			var end_point: Vector2 = input_path[current_index+1]
			var start_point2: Vector2 = input_path[current_index+1]
			var end_point2: Vector2 = input_path[current_index+2]

			var mut_first = CombinedVector2.from_vector2(start_point, end_point)
			var second = CombinedVector2.from_vector2(start_point2, end_point2)

			if mut_first.is_direction_equal(second):
				#Same segment
				mut_first.combine(second)
			else:
				#New segment
				var new_segment = []
				new_segment.push_back(second)
				self.path.push_back(new_segment)

			if self.path.is_empty():
				var new_segment = []
				new_segment.push_back(mut_first)
				self.path.push_back(new_segment)
			else:
				self.path.back().push_back(mut_first)

func compare_in_percentage(other: CombinedPath) -> float:
	return _base_compare(self.path, other.path)


func _base_compare(path: Array, other_path: Array) -> float:
	var discreptancies: float = 0
	var segment_count: float = 0

	var fraction = (3 * other_path.size()) / 4
	if path.size() <= fraction:
		discreptancies += 100;
		print("breako2")
		return discreptancies;

	for i in path.size():
		#Array[CombinedVector2]
		var current : Array = path[i]
		segment_count += current.size()
		if i > other_path.size(): 
			#guard
			discreptancies += 100;
			print("breako")
			break;
		
		var lower_boundary = i-1;
		if lower_boundary < 0:
			lower_boundary = 0

		var higher_boundary = i+1
		if higher_boundary > other_path.size():
			higher_boundary = other_path.size()

		for o in range(lower_boundary, higher_boundary, 1):
			#Array[CombinedVector2]
			var current_other: Array = other_path[o]
			discreptancies += self._compare_segment(current, current_other)

	if discreptancies <= 0:
		discreptancies = segment_count
	
	if segment_count > discreptancies:
		segment_count = discreptancies

	print(str(segment_count) + "/" + str(discreptancies) + " = " + str(segment_count / discreptancies))

	return (segment_count / discreptancies) * 100

						#Array[CombinedVector2]
func _compare_segment(first: Array, second: Array) -> float:
	var discreptancies: float = 0

	for i in first.size():
		var current : CombinedVector2 = first[i]
		if i > second.size(): 
			#guard
			discreptancies += 1;
			break;
		
		var lower_boundary = i-1;
		if lower_boundary < 0:
			lower_boundary = 0

		var higher_boundary = i+1
		if higher_boundary > second.size():
			higher_boundary = second.size()

		for o in range(lower_boundary, second.size(), 1):
			var current_other: CombinedVector2 = second[o]
			if current.is_direction_equal(current_other):
				discreptancies -= 1
				break;
			discreptancies+=1
	return discreptancies;

func get_reverse() -> CombinedPath:
	var og_reverse = self.input_path.duplicate();
	og_reverse.reverse()

	return CombinedPath.new(og_reverse)
	







