extends Node

enum Vendor {
	RENGUY,
	ALIEN,
	BUNNYGIRL
}

const BUNNIES_NEEDED_DEFAULT = 2
const TOTAL_BUNNIES_DEFAULT = 5
const BUNNIES_IN_PEN_DEFAULT = 5

#Gameplay Vars
var game_over: bool = false
var danger_time: bool = false
var days: int = 1
var is_day = true
var runs: int
var longest_run: int
var bunnies_in_pen: int = 0
var total_bunnies: int = 0
var bunnies_needed: int = 2
var bunnies_needed_inc: int = 1
var night_length: int = 20
var day_length_base: int = 25
var day_length_inc: int = 20
var centerpoint = Vector2(0,0)
var pen_radius = 40.0
var bunny_breed_rate = 2.5 # 1 means for each bunny, add 1 new bunny. 2 means add 2 bunnies for each etc
var egg_rates = {
	Bunny.BunnyType.BASIC: 1,
	Bunny.BunnyType.KILLER: 2,
	Bunny.BunnyType.BUFF: 2,
	Bunny.BunnyType.MAGIC: 3,
	Bunny.BunnyType.GUNNER: 3,
	Bunny.BunnyType.HYPER: 3,
	Bunny.BunnyType.GOLDEN: 5
}
var mutation_rates = {
	Bunny.BunnyType.BASIC: 0.5,
	Bunny.BunnyType.KILLER: 0.1,
	Bunny.BunnyType.BUFF: 0.1,
	Bunny.BunnyType.MAGIC: 0.1,
	Bunny.BunnyType.GUNNER: 0.1,
	Bunny.BunnyType.HYPER: 0.1,
	Bunny.BunnyType.GOLDEN: 0
}
var bunny_colors = { # TEMP
	Bunny.BunnyType.BASIC: Color(1, 1, 1),
	Bunny.BunnyType.KILLER: Color(0.9, 0.2, 0.2),
	Bunny.BunnyType.BUFF: Color(0.1, 0.7, 0.7),
	Bunny.BunnyType.MAGIC: Color(0.8, 0, 0.7),
	Bunny.BunnyType.GUNNER: Color(1, 0.5, 0.1),
	Bunny.BunnyType.HYPER: Color(0.1, 0.8, 0.2),
	Bunny.BunnyType.GOLDEN: Color(0.8, 0.7, 0.1)
}

# Character/Story Vars
var alien_name: String
var bunnylady_name: String
var renguy_name: String
var deity_name: String
var scripture_name = "Lagomorphicon"
var bazaar_name = "The Nightfaire"

var name_db: Resource
var diag_db: Resource
