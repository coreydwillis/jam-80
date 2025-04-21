extends Node

enum Vendor {
	RENGUY,
	ALIEN,
	BUNNYGIRL
}

const BUNNIES_NEEDED_DEFAULT = 2
const TOTAL_BUNNIES_DEFAULT = 0
const BUNNIES_IN_PEN_DEFAULT = 0
const GAME_OVER_DEFAULT = false
const DANGER_TIME_DEFAULT = false
const DAYS_DEFAULT = 1
const IS_DAY_DEFAULT = true
const GAME_STARTED_DEFAULT = false
const BUNNIES_NEEDED_INC_DEFAULT = 1
const EGGS_DEFAULT = 0

# Menu Vars
var splash_done: bool = false

# Ability Vars
var hammer_enabled: bool = false
var boombox_enabled: bool = false
var magnet_enabled: bool = false

#Gameplay Vars
var game_over: bool = GAME_OVER_DEFAULT
var danger_time: bool = DANGER_TIME_DEFAULT
var days: int = DAYS_DEFAULT
var is_day = IS_DAY_DEFAULT
var game_started: bool = GAME_STARTED_DEFAULT
var runs: int = 1
var longest_run: int
var eggs = EGGS_DEFAULT
var bunnies_in_pen: int = BUNNIES_IN_PEN_DEFAULT
var total_bunnies: int = TOTAL_BUNNIES_DEFAULT
var bunnies_needed: int = BUNNIES_NEEDED_DEFAULT
var bunnies_needed_inc: int = BUNNIES_NEEDED_INC_DEFAULT
var night_length: int = 60
var day_length_base: int = 30
var day_length_inc: int = 30
var centerpoint = Vector2(0,0)
var pen_radius = 80
var bunny_breed_rate = 2.5
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
	Bunny.BunnyType.BASIC: 6,
	Bunny.BunnyType.KILLER: 1,
	Bunny.BunnyType.BUFF: 1,
	Bunny.BunnyType.MAGIC: 1,
	Bunny.BunnyType.GUNNER: 1,
	Bunny.BunnyType.HYPER: 1,
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
var rng = RandomNumberGenerator.new()

# Accessibility Vars
var night_timer: bool = true
 
# Character/Story Vars
var alien_name: String
var bunnylady_name: String
var renguy_name: String
var deity_name: String
var scripture_name = "Lagomorphicon"
var bazaar_name = "The Nightfaire"
var names_dict = {}

var name_resource = preload("res://assets/dbs/names_db.csv")
var dialog_resource = preload("res://assets/dbs/dialog_db.csv")
var name_db = name_resource.records
var dialog_db = dialog_resource.records

func get_column(db, id):
	var arr = []
	for row in db:
		arr.append(row[id])
	return arr

func randname(db):
	return str(get_column(db, "Name")[rng.rand_weighted(get_column(db, "Rarity").map(func(x): return 1.0/x))])

func _name_generation():
	var first_names = name_db.filter(func(n): return n["NameType"] == "First")
	var middle_names = name_db.filter(func(n): return n["NameType"] == "Middle")
	var last_names = name_db.filter(func(n): return n["NameType"] == "Last")
	var na_names = first_names.filter(func(n): return n["Gender"] == "na")
	var fem_names = first_names.filter(func(n): return n["Gender"] == "Fem") + na_names
	var masc_names = first_names.filter(func(n): return n["Gender"] == "Masc") + na_names
	var nb_names = first_names.filter(func(n): return n["Gender"].to_lower() == "nonbinary") + na_names
	
	alien_name = randname(nb_names)
	if rng.randf() < 0.5:
		alien_name += " " + randname(middle_names)
	alien_name += " " + randname(last_names)
	
	bunnylady_name = randname(fem_names)
	if rng.randf() < 0.5:
		bunnylady_name += " " + randname(middle_names)
	bunnylady_name += " " + randname(last_names)
	
	renguy_name = randname(masc_names)
	if rng.randf() < 0.5:
		renguy_name += " " + randname(middle_names)
	renguy_name += " " + randname(last_names)
	
	deity_name = randname(first_names)
	if rng.randf() < 0.5:
		deity_name += " " + randname(middle_names)
	deity_name += " " + randname(last_names)
	
	names_dict = {
		"deity": deity_name,
		"alien": alien_name,
		"renguy": renguy_name,
		"bunnylady": bunnylady_name
	}

func _ready():
	_name_generation()
	SignalBus.reset_names.connect(_name_generation)
