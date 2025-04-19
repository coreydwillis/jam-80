extends Node

const BUNNIES_NEEDED_DEFAULT = 2
const TOTAL_BUNNIES_DEFAULT = 5
const BUNNIES_IN_PEN_DEFAULT = 5

#Gameplay Vars
var days: int = 1
var is_day = true
var runs: int
var longest_run: int
var bunnies_in_pen: int = 0
var total_bunnies: int = 0
var bunnies_needed: int = 2
var bunnies_needed_inc: int = 1
var night_length: int = 20
var day_length_base: int = 10
var day_length_inc: int = 20
var centerpoint = Vector2(0,0)
var pen_radius = 40.0

# Character/Story Vars
var alien_name: String
var bunnylady_name: String
var renguy_name: String
var deity_name: String
var scripture_name = "Lagomorphicon"
var bazaar_name = "The Nightfaire"
