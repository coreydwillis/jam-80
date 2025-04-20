extends Node
var bunny_resource = preload("res://scenes/game/characters/enemies/Bunny.tscn")
var rng

func _ready():
	SignalBus.night_started.connect(breed)
	rng = RandomNumberGenerator.new()

func breed():
	var bunnies = get_children()
	for b in bunnies:
		if b.is_queued_for_deletion():
			bunnies.erase(b)
	var new_count = floor(len(bunnies) * Game.bunny_breed_rate)
	var current_count = len(bunnies)
	for bunny in bunnies:
		match bunny.type:
			Bunny.BunnyType.BASIC, Bunny.BunnyType.GOLDEN:
				pass
			_:
				for i in range(2):
					if current_count < new_count:
						add_bunny(bunny.type)
						current_count += 1
	for i in range(new_count - current_count):
		add_bunny(Game.mutation_rates.keys()[rng.rand_weighted(Game.mutation_rates.values())])

func add_bunny(type: Bunny.BunnyType):
	var baby = bunny_resource.instantiate()
	add_child(baby)
	baby.init(Bunny.BunnyState.SLEEPING, type)
