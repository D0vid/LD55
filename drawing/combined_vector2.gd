class_name CombinedVector2

var x : float
var y : float
var magnitude : float
var direction : float

const direction_tolerance = 50;
const scaling_tolerance = 10;


func _init(x: float, y: float, magnitude: float, direction: float) :
	self.x = x
	self.y = y
	self.magnitude = magnitude
	self.direction = direction

static func from_vector2(first: Vector2, second: Vector2) -> CombinedVector2:
	var dx = second.x - first.x
	var dy = second.y - first.y
	var magnitude = sqrt((dx * dx) + (dy * dy))
	var direction =  atan2(dy, dx) * (180 / PI)

	return CombinedVector2.new(dx, dy, magnitude, direction)

func is_direction_equal(other: CombinedVector2) -> bool :
	var diff = abs(self.direction - other.direction)
	#print("Direction Calc:" + str(diff) + "<=" + str(direction_tolerance))
	return diff <= direction_tolerance

func is_magnitude_equal(other: CombinedVector2, scaling_factor: float) -> bool:
	var scaling_factor_to_compare = calculate_scaling_factor(other)
	#print("Scaling Calc: " + str(abs(scaling_factor_to_compare - scaling_factor)) + "<=" + str(scaling_tolerance))
	
	var test = abs(scaling_factor_to_compare - scaling_factor) <= scaling_tolerance
	return test

func combine(other: CombinedVector2): 
	self.magnitude += other.magnitude

func calculate_scaling_factor(other: CombinedVector2) -> float: 
	return self.magnitude / other.magnitude







