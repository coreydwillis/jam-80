extends TextureRect

func _ready():
	SignalBus.lasso_purchased.connect(enable_ability)
	SignalBus.lasso_ready.connect(lasso_on)
	SignalBus.lasso_not_ready.connect(lasso_off)
	
func lasso_off():
	material.set_shader_parameter("light_mul", 0.4)

func lasso_on():
	material.set_shader_parameter("light_mul", 1.2)

func enable_ability():
	visible = true
