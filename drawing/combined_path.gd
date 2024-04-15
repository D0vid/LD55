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
				var current_segment = self.path.back()
				if current_segment != null:
					var current_point = current_segment.back()
					if current_point != null:
						current_point.combine(mut_first)
					else:
						current_segment.push_back(mut_first)
				else:
					var new_segment = []
					new_segment.push_back(mut_first)
					self.path.push_back(new_segment)
			else:
				var current_segment = self.path.back()
				if current_segment != null:
					current_segment.push_back(mut_first)
				else:
					var new_segment = []
					new_segment.push_back(mut_first)
					self.path.push_back(new_segment)
				var new_segment = []
				new_segment.push_back(second)
				self.path.push_back(new_segment)

func compare_in_percentage(other: CombinedPath) -> float:
	return _base_compare2(self.path, other.path)

func _base_compare2(first: Array, second: Array) -> float:

	var latest_first_index = 0
	var found_count=0

	for i in second.size():
		for y in first.size():
			var current_first = first[y]
			var current_second = second[i]
			if y >= latest_first_index:
				if _compare_segment2(current_first, current_second):
					found_count+=1
					latest_first_index=y
					break;
	
	print("Final Found Count: " + str(found_count))
	if found_count >= (second.size() * 60 / 100):
		return 100
	else:
		return 0

		
func _compare_segment2(first: Array, second: Array) -> bool:
	
	var latest_first_index = 0
	var found_count=0

	for i in second.size():
		for y in first.size():

			var current_first = first[y]
			var current_second = second[i]

			if y >= latest_first_index:
				if current_second.is_direction_equal(current_first):
					found_count+=1
					latest_first_index=y
					break;

	print("Found Count: " + str(found_count))
	if found_count >= second.size():
		return true
	else:
		return false
				










func _base_compare(path: Array, other_path: Array) -> float:
	var discreptancies: float = 0
	var segment_count: float = 0

	for opath in other_path:
		segment_count += opath.size()

	for i in path.size():
		#Array[CombinedVector2]
		var current : Array = path[i]
		
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


	#print(str(segment_count) + "/" + str(discreptancies) + " = " + str(segment_count / discreptancies))



	if discreptancies <= 0:
		discreptancies = segment_count
	#10
	if segment_count > discreptancies:
		segment_count = discreptancies


	#        #13             #23                       
	var disc_percent = (discreptancies * 60) / 100

	if segment_count >= disc_percent:
		return 100;
	else:
		return 0

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
				break;
			discreptancies+=1
	return discreptancies;

func get_reverse() -> CombinedPath:
	var og_reverse = self.input_path.duplicate();
	og_reverse.reverse()

	return CombinedPath.new(og_reverse)
	







