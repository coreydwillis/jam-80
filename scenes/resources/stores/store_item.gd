extends Resource

class_name InvItem

@export var name: String = ""
@export var description: String = ""
@export var texture: Texture2D
@export var tint: Color = Color(1,1,1)
@export var vendor: Game.Vendor
@export var min_night: int = 1
@export var max_owned: int = -1
@export var price: int
@export var price_scaling: float = 1.0
@export var rarity: float = 1
@export var graphic_scale: Vector2 = Vector2(1, 1)
