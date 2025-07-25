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
const BUNNIES_NEEDED_INC_DEFAULT = 2
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
var base_bunny_breed_rate = 2.5
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
	Bunny.BunnyType.BASIC: 8,
	Bunny.BunnyType.KILLER: 0.5,
	Bunny.BunnyType.BUFF: 0.5,
	Bunny.BunnyType.MAGIC: 0.5,
	Bunny.BunnyType.GUNNER: 0.5,
	Bunny.BunnyType.HYPER: 0.5,
	Bunny.BunnyType.GOLDEN: 0
}
var base_mutation_rates = {
	Bunny.BunnyType.BASIC: 8,
	Bunny.BunnyType.KILLER: 0.5,
	Bunny.BunnyType.BUFF: 0.5,
	Bunny.BunnyType.MAGIC: 0.5,
	Bunny.BunnyType.GUNNER: 0.5,
	Bunny.BunnyType.HYPER: 0.5,
	Bunny.BunnyType.GOLDEN: 0
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

func get_difficulty_multiplier():
	# Gradual difficulty scaling based on day
	# Days 1-2: Easy (0.5x to 0.75x difficulty)
	# Days 3-4: Normal (0.75x to 1.0x difficulty)  
	# Days 5-8: Hard (1.0x to 2.0x difficulty)
	if days <= 2:
		return 0.5 + (days - 1) * 0.25  # 0.5x to 0.75x
	elif days <= 4:
		return 0.75 + (days - 3) * 0.25  # 0.75x to 1.0x
	else:
		return 1.0 + (days - 5) * 0.25  # 1.0x to 1.75x for days 5-8

func update_difficulty_scaling():
	var difficulty_mult = get_difficulty_multiplier()
	
	# Scale breeding rate (more bunnies = harder to manage)
	bunny_breed_rate = base_bunny_breed_rate * difficulty_mult
	
	# Scale mutation rates for dangerous bunnies
	mutation_rates[Bunny.BunnyType.BASIC] = base_mutation_rates[Bunny.BunnyType.BASIC] / difficulty_mult
	mutation_rates[Bunny.BunnyType.KILLER] = base_mutation_rates[Bunny.BunnyType.KILLER] * difficulty_mult
	mutation_rates[Bunny.BunnyType.BUFF] = base_mutation_rates[Bunny.BunnyType.BUFF] * difficulty_mult
	mutation_rates[Bunny.BunnyType.MAGIC] = base_mutation_rates[Bunny.BunnyType.MAGIC] * difficulty_mult
	mutation_rates[Bunny.BunnyType.GUNNER] = base_mutation_rates[Bunny.BunnyType.GUNNER] * difficulty_mult
	mutation_rates[Bunny.BunnyType.HYPER] = base_mutation_rates[Bunny.BunnyType.HYPER] * difficulty_mult

func get_scaled_bunny_requirement():
	# More gradual scaling of bunny requirements
	var base_requirement = BUNNIES_NEEDED_DEFAULT
	var difficulty_mult = get_difficulty_multiplier()
	
	if days == 1:
		return base_requirement  # Start with 2 bunnies
	elif days <= 3:
		# Days 2-3: Add 1-2 bunnies per day
		return base_requirement + (days - 1)
	elif days <= 5:
		# Days 4-5: Add 2-3 bunnies per day
		return base_requirement + 2 + (days - 3) * 2
	else:
		# Days 6-8: Exponential growth but capped
		var exponential_base = 1.5 * difficulty_mult
		return int(base_requirement * pow(exponential_base, days - 1))

func _ready():
	_name_generation()
	SignalBus.reset_names.connect(_name_generation)
	SignalBus.day_started.connect(update_difficulty_scaling)
