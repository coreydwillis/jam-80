extends TextureRect

func _ready():
	SignalBus.hammer_purchased.connect(enable_ability)
	SignalBus.hammer_not_ready.connect(hammer_off)
	SignalBus.hammer_ready.connect(hammer_on)
	
func hammer_off():
	material.set_shader_parameter("light_mul", 0.4)

func hammer_on():
	material.set_shader_parameter("light_mul", 1.2)

func enable_ability():
	visible = true
	Game.hammer_enabled = true
	
