extends TextureRect

func _ready():
	SignalBus.boombox_purchased.connect(enable_ability)
	SignalBus.boombox_ready.connect(boombox_on)
	SignalBus.boombox_not_ready.connect(boombox_off)
	
func boombox_off():
	material.set_shader_parameter("light_mul", 0.4)

func boombox_on():
	material.set_shader_parameter("light_mul", 1.2)
	$"../AbilityResetSound".play()

func enable_ability():
	visible = true
	Game.boombox_enabled = true
