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
var game_started: bool = false
var runs: int = 1
var longest_run: int
var bunnies_in_pen: int = 0
var total_bunnies: int = 0
var bunnies_needed: int = 2
var bunnies_needed_inc: int = 1
var night_length: int = 60
var day_length_base: int = 1
var day_length_inc: int = 5
var centerpoint = Vector2(0,0)
var pen_radius = 40.0
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
var rng = RandomNumberGenerator.new()
var eggs = 0

# Accessibility Vars
var night_timer: bool = true

# Character/Story Vars
var alien_name: String
var bunnylady_name: String
var renguy_name: String
var deity_name: String
var scripture_name = "Lagomorphicon"
var bazaar_name = "The Nightfaire"

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
	return str(get_column(db, "Name")[rng.rand_weighted(get_column(db, "Rarity"))])

func _ready():
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
