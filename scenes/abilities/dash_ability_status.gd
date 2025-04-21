extends TextureRect

func _ready():
	SignalBus.dash_purchased.connect(enable_ability)
	SignalBus.dash_not_ready.connect(dash_off)
	SignalBus.dash_ready.connect(dash_on)
	
func dash_off():
	material.set_shader_parameter("light_mul", 0.4)

func dash_on():
	material.set_shader_parameter("light_mul", 1.2)
	$"../AbilityResetSound".play()
	
func enable_ability():
	visible = true
	
