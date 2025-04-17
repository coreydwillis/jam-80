class_name PlayerKeybindResource

extends Resource

const MOVE_LEFT : String = "left"
const MOVE_RIGHT : String = "right"
const MOVE_UP : String = "up"
const MOVE_DOWN : String = "down"
const JUMP : String = "jump"
const USE : String = "use"
const ABILITY1 : String = "ability1"
const ABILITY2 : String = "ability2"
const ABILITY3 : String = "ability3"

@export var DEFAULT_MOVE_LEFT_KEY = InputEventKey.new()
@export var DEFAULT_MOVE_RIGHT_KEY = InputEventKey.new()
@export var DEFAULT_UP_KEY = InputEventKey.new()
@export var DEFAULT_DOWN_KEY = InputEventKey.new()
@export var DEFAULT_JUMP_KEY = InputEventKey.new()
@export var DEFAULT_USE_KEY = InputEventKey.new()
@export var DEFAULT_ABILITY1_KEY = InputEventKey.new()
@export var DEFAULT_ABILITY2_KEY = InputEventKey.new()
@export var DEFAULT_ABILITY3_KEY = InputEventKey.new()

var move_left_key = InputEventKey.new()
var move_right_key = InputEventKey.new()
var move_up_key = InputEventKey.new()
var move_down_key = InputEventKey.new()
var jump_key = InputEventKey.new()
var use_key = InputEventKey.new()
var ability1_key = InputEventKey.new()
var ability2_key = InputEventKey.new()
var ability3_key = InputEventKey.new()
