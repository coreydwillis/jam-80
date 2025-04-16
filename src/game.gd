extends Node

#Gameplay Vars
var days: int = 1
var is_day = true
var runs: int
var longest_run: int
var bunnies_in_pen: int = 0
var total_bunnies: int = 0
var night_length: int = 20
var day_length_base: int = 10
var day_length_inc: int = 20
var centerpoint = Vector2(0,0)
var pen_radius = 40.0

# Settings Vars #
var master_volume: float
var music_volume: float
var sfx_volume: float
var fullscreen: bool

# Character/Story Vars
var alien_name: String
var bunnylady_name: String
var renguy_name: String
var deity_name: String
var scripture_name = "Lagomorphicon"
var bazaar_name = "The Nightfaire"
