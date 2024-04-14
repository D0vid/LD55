extends Sprite2D

@export var timeline_speed = 100

var rune_scene = preload("res://rune/rune.tscn")
var rune_up = preload("res://rune/rune_up.tres")
var rune_down = preload("res://rune/rune_down.tres")
var rune_left = preload("res://rune/rune_left.tres")
var rune_right = preload("res://rune/rune_right.tres")
var rune_spacebar = preload("res://rune/rune_spacebar.tres")
var rune_bases: Array[RuneBase] = [rune_up, rune_down, rune_left, rune_right, rune_spacebar]

var glyph_scene = preload("res://glyph/glyph.tscn")

var tap_zone : Area2D

const SPAWN_POS = Vector2(160, 7)

var rand = RandomNumberGenerator.new()

var last_spawned_interval_sec: float = 0
var spawn_interval_boundary: float = 1
var current_spawn_interval_boundary: float = 0.5

var pause_spawn: bool = false
const PAUSE_SPAWN_DURATION: float = 5;

var wave_size = 20
var wave_current_count = 0

var actions_in_tap_zone = []


func _ready():
	tap_zone = get_node("%RuneTapZone")
	tap_zone.connect("rune_missed", on_rune_missed.bind())

func on_wave_ended():
	pause_spawn = true
	wave_current_count = 0

func on_resume_spawn():
	pause_spawn = false
	timeline_speed += 25


func _process(delta):
	actions_in_tap_zone.clear()
	last_spawned_interval_sec += delta

	handle_pause()

	handle_spawn()

	for rune in get_children():
		# Move runes in the timeline
		rune.position -= Vector2(delta * timeline_speed, 0)
		# Check if a rune is in the tap zone -> validate it
		if rune is Rune and Input.is_action_just_pressed(rune.rune_base.key) and rune.overlaps_area(tap_zone):
			print("validated [" + rune.rune_base.key + "] key for rune " + rune.name)
			rune.validated = true
			rune.queue_free()
		# Add action to list to check
		if tap_zone.overlaps_area(rune):
			if rune is Rune:
				actions_in_tap_zone.push_back(rune.rune_base.key)
			if rune is Glyph:
				#Glyph out
				rune.in_tap_zone = true

		else:
			if rune is Glyph && rune.in_tap_zone:
				#Glyph out
				rune.in_tap_zone = false
				rune.queue_free()


	# Handle misses due to tapping too early
	for rune_base in self.rune_bases:
		var action = rune_base.key
		if (get_children().size() > 0 
		and Input.is_action_just_pressed(action) 
		and !actions_in_tap_zone.has(action)):
			print("too early")

func handle_pause():
	if pause_spawn && get_children().size() == 0:
		#Resets the spawn timer when timeline is empty (So we wait really for n seconds)
		last_spawned_interval_sec = 0
	if pause_spawn && last_spawned_interval_sec >= PAUSE_SPAWN_DURATION: 
		#Resume spawn when pause is over.
		on_resume_spawn()

func handle_spawn():
		# If we are not in pause mode, 
	if  !pause_spawn && last_spawned_interval_sec >= current_spawn_interval_boundary && has_free_space():
		if wave_current_count >= wave_size:
			# Wave is at max size, end wave
			on_wave_ended()
			return;

		var rand = rand.randi_range(0,10)
		if rand == 2:
			spawn_glyph()
		else:
			spawn_rune()

		# we just spawned, reset interval, increment wave count.
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
	glyph.length_in_blocks = 16
	add_child(glyph)
	glyph.position = SPAWN_POS + Vector2(glyph.size().x ,0) / 2
	return glyph

func has_free_space() -> bool:
	var latest = get_children().back()
	if !latest:
		return true;
	
	var right_boundary = latest.position.x + (latest.size().x / 2)
	return right_boundary <= SPAWN_POS.x - 10

func on_rune_missed(rune):
	print("too late")
	rune.queue_free()
