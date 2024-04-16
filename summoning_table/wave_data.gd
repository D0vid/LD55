class_name WaveData

var wave_size : int
var margin_between_blocks
var next_speed_increase : float
var glyph_odd : int
var glyph_size : int
var pause_duration: int
var play_transition

func _init(wave_size: int, next_speed_increase: float, glyph_odd: int, glyph_size: int, margin_between_blocks, pause_duration, play_transition = ""): 
    self.wave_size = wave_size
    self.next_speed_increase = next_speed_increase
    self.glyph_odd = glyph_odd
    self.glyph_size = glyph_size
    self.margin_between_blocks = margin_between_blocks
    self.pause_duration = pause_duration
    self.play_transition = play_transition

