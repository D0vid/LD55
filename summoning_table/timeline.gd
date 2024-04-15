extends Sprite2D

# Runes & Co
var rune_scene = preload("res://rune/rune.tscn")
var rune_up = preload("res://rune/rune_up.tres")
var rune_down = preload("res://rune/rune_down.tres")
var rune_left = preload("res://rune/rune_left.tres")
var rune_right = preload("res://rune/rune_right.tres")
var rune_spacebar = preload("res://rune/rune_spacebar.tres")
var rune_bases: Array[RuneBase] = [rune_up, rune_down, rune_left, rune_right, rune_spacebar]

# Mandarine & Co
var glyph_shape_ankh = preload("res://glyph_shape/glyph_shape_ankh.tres")
var glyph_shape_circle = preload("res://glyph_shape/glyph_shape_circle.tres")
var glyph_shape_inverted_v = preload("res://glyph_shape/glyph_shape_inverted_v.tres")
var glyph_shape_lightning = preload("res://glyph_shape/glyph_shape_lightning.tres")
var glyph_shape_power_button = preload("res://glyph_shape/glyph_shape_power_button.tres")
var glyph_shape_spiral = preload("res://glyph_shape/glyph_shape_spiral.tres")
var glyph_shape_tilted_hourglass = preload("res://glyph_shape/glyph_shape_tilted_hourglass.tres")
var glyph_shape_tilted_square = preload("res://glyph_shape/glyph_shape_tilted_square.tres")
var glyph_shape_v = preload("res://glyph_shape/glyph_shape_v.tres")
var glyph_shape_weird = preload("res://glyph_shape/glyph_shape_weird.tres")
var glyph_shape_bases: Array[GlyphShapeBase] = [glyph_shape_ankh,glyph_shape_circle,glyph_shape_inverted_v,glyph_shape_lightning,glyph_shape_power_button,glyph_shape_spiral,glyph_shape_tilted_hourglass,glyph_shape_tilted_square,glyph_shape_v,glyph_shape_weird]

var glyph_scene = preload("res://glyph/glyph.tscn")

# SPAWN
const SPAWN_POS = Vector2(160, 7)
var last_spawned_interval_sec: float = 0
var spawn_interval_boundary: float = 1
var current_spawn_interval_boundary: float = 0.5
var pause_spawn: bool = false
const PAUSE_SPAWN_DURATION: float = 5;

var wave_size = 20
var wave_current_count = 0

var rand = RandomNumberGenerator.new()

# Timeline 
@export var timeline_speed = 100
@onready var tap_zone : Area2D = get_node("%RuneTapZone")
@onready var canvas : Drawing = get_node("/root/ViewManager/DrawViewport/SubViewport/Drawing")
@onready var summoner : Sprite2D = get_node("%Summoner")


var speed_up_audio = preload("res://audio_player/audio/fx/SpeedUp.ogg")
var fx_player: AudioStreamPlayer = AudioPlayer.get_node("FXPlayer");


var timer: SceneTreeTimer

signal missed
signal hit


func _ready():
	tap_zone.connect("area_entered", on_tapzone_entered)
	tap_zone.connect("area_exited", on_tapzone_exitted.bind())
	canvas.connect("drawing_ended", on_drawing_ended)
	timer = get_tree().create_timer(2)

	


func on_drawing_ended(glyph: Glyph):
	print("Drawing ended")
	self.canvas.enabled = false
	glyph.drawing_ended = true;


func on_wave_ended():
	pause_spawn = true
	wave_current_count = 0

func on_resume_spawn():
	pause_spawn = false
	AudioPlayer.pitch_scale += 0.02
	timeline_speed += 25

func on_tapzone_entered(colliding: Area2D):
	if colliding is BaseTimelineObject:
		colliding.in_tap_zone = true

	if colliding is Glyph:
		print("Enabled canvas")
		self.canvas.enabled = true
		self.canvas.current_glyph = colliding
		self.canvas.show_glyph()


func on_tapzone_exitted(colliding: Area2D):
	if colliding is BaseTimelineObject:
		colliding.in_tap_zone = false
		colliding.to_delete = true
		print("Oust")


	if colliding is Glyph:
		print("Disabled canvas")
		self.canvas.enabled = false
		colliding.drawing_ended = true;
		self.canvas.next_drawing()
		self.canvas.hide_glyph()

func _process(delta):
	if summoner.dead || timer.time_left > 0: 
		return
		
	last_spawned_interval_sec += delta

	handle_pause()

	handle_spawn()

	var first_no_delete_child_handled = false

	for i in get_child_count():
		var timeline_object: BaseTimelineObject	= get_child(i)
		# Move runes in the timeline
		timeline_object.position -= Vector2(delta * timeline_speed, 0)

		if !timeline_object.to_delete:
			if !first_no_delete_child_handled:
				first_no_delete_child_handled = true
				if timeline_object is Rune && !timeline_object.in_tap_zone && Input.is_action_just_pressed(timeline_object.get_action()):
					missed.emit()
					print("too early")

	
			if timeline_object.in_tap_zone and !timeline_object.validated:
				if timeline_object is Rune && Input.is_action_just_pressed(timeline_object.get_action()):
					timeline_object.validated = true
					hit.emit()
					print("BOOM")
				if timeline_object is Glyph && timeline_object.drawing_ended && !timeline_object.validated && !timeline_object.handled:
					
					var drawn_glyph = canvas.current_path
					var glyph_area : Area2D = canvas.glyph_shape
					var valid_points = 0
					var invalid_points = 0
					for point in drawn_glyph:
						if Geometry2D.is_point_in_polygon(point - glyph_area.position, glyph_area.collider.polygon):
							valid_points += 1
						else:
							invalid_points += 1
					var total_points = valid_points + invalid_points
					invalid_points = maxi(invalid_points, 1) # prevent div by 0
					var cover_percentage = float(valid_points) / total_points * 100
					print("Cover percentage : " + str(cover_percentage))
					
					timeline_object.handled = true

					if cover_percentage >= 80:
						print("GLYPH IS SAME")
						timeline_object.validated = true
						hit.emit()
					else:
						missed.emit()
						
					self.canvas.next_drawing()

		else:
			if !timeline_object.validated:
				if timeline_object is Glyph && !timeline_object.handled || timeline_object is Rune:
					missed.emit()
					print("OOPS")
			
			timeline_object.queue_free()

func handle_pause():
	if pause_spawn && last_spawned_interval_sec >= PAUSE_SPAWN_DURATION: 
		#Resume spawn when pause is over.
		on_resume_spawn()
		last_spawned_interval_sec = 0

func handle_spawn():
		# If we are not in pause mode, 
	if  !pause_spawn && last_spawned_interval_sec >= current_spawn_interval_boundary && has_free_space():
		if wave_current_count >= wave_size:
			# Wave is at max size, end wave
			on_wave_ended()
			return;

		var rando = rand.randi_range(0,10)
		if rando == 2:
			spawn_glyph()
		else:
			spawn_rune()

		# we just spawned, increment wave count.
		wave_current_count+=1
		last_spawned_interval_sec = 0
		#randomize_spawn_interval()

func randomize_spawn_interval():
	var random = rand.randf_range(0, 40)
	print("DEBUG RAND: " + str(random))
	random = random / 4
	print("DEBUG MODULOTED: " + str(random))
	current_spawn_interval_boundary = spawn_interval_boundary / random

func spawn_rune() -> Rune :
	var action = rand.randi_range(0,rune_bases.size()-1)
	var rune : Rune = rune_scene.instantiate()
	rune.rune_base = rune_bases[action]
	add_child(rune)
	rune.position = SPAWN_POS + Vector2(rune.size().x ,0) / 2
	return rune

func spawn_glyph() -> Glyph:
	var glyph: Glyph = glyph_scene.instantiate()
	glyph.glyph_shape_base = get_random_glyph_shape_base()
	glyph.length_in_blocks = 16
	add_child(glyph)
	glyph.position = SPAWN_POS + Vector2(glyph.size().x ,0) / 2
	return glyph
	
func get_random_glyph_shape_base() -> GlyphShapeBase:
	var random = rand.randi_range(0, 9)
	return glyph_shape_bases[random] as GlyphShapeBase

func has_free_space() -> bool:
	if get_children().size() == 0:
		return true;
	var latest = get_children().back()
	var right_boundary = latest.position.x + (latest.size().x / 2)
	return right_boundary <= SPAWN_POS.x - 20
