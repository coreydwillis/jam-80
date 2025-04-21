extends Node2D
var bunny_resource = preload("res://scenes/game/characters/enemies/Bunny.tscn")
var rng

func _ready():
	SignalBus.night_started.connect(breed)
	SignalBus.item_bought.connect(_on_item_bought)
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
	
func replace_bunny(type: Bunny.BunnyType):
	var bunnies = get_children()
	for bunny in bunnies:
		if bunny.type == type:
			bunny.queue_free()
			add_bunny(Bunny.BunnyType.BASIC)
			return

func _on_item_bought(n: String):
	match n:
		"Add Bunny":
			add_bunny(Bunny.BunnyType.BASIC)
		"Add Golden":
			add_bunny(Bunny.BunnyType.GOLDEN)
		"More Mutations":
			for t in [Bunny.BunnyType.HYPER, Bunny.BunnyType.GUNNER, Bunny.BunnyType.MAGIC, Bunny.BunnyType.BUFF, Bunny.BunnyType.KILLER]:
				Game.mutation_rates[t] += 0.5
		"Remove Buff Bunny":
			replace_bunny(Bunny.BunnyType.BUFF)
		"Remove Gunner Bunny":
			replace_bunny(Bunny.BunnyType.GUNNER)
		"Remove Magic Bunny":
			replace_bunny(Bunny.BunnyType.MAGIC)
		"Remove Hyper Bunny":
			replace_bunny(Bunny.BunnyType.HYPER)
		"Remove Killer Bunny":
			replace_bunny(Bunny.BunnyType.KILLER)
