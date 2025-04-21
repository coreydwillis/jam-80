extends TextureRect

func _ready():
	SignalBus.magnet_purchased.connect(enable_ability)
	SignalBus.magnet_not_ready.connect(magnet_off)
	SignalBus.magnet_ready.connect(magnet_on)
	
func magnet_off():
	material.set_shader_parameter("light_mul", 0.4)

func magnet_on():
	material.set_shader_parameter("light_mul", 1.2)

func enable_ability():
	visible = true
	Game.magnet_enabled = true
