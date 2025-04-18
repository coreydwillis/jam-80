extends Node

@onready var env_audio = $"."
var isDayTime: bool = true

func _ready():
	dayAudioStart()
	SignalBus.night_started.connect(timePeriodAudioEnd)
	SignalBus.day_started.connect(timePeriodAudioEnd)

func dayAudioStart():
	var birbsStreamAsset = load("res://assets/audio/sfx/env/day/Birbs.wav")
	createAudioStreamPlayer(birbsStreamAsset, true, true, true, false, 0.1, 1, "SFX")
	
func nightAudioStart():
	var owlStreamAsset = load("res://assets/audio/sfx/env/night/Owl Call 1.wav")
	createAudioStreamPlayer(owlStreamAsset, false, false, true, false, 10.0, 1.0, "SFX")
	
func timePeriodAudioEnd():
	isDayTime = !isDayTime
	print(isDayTime)
	for i in range(0, env_audio.get_child_count()):
		get_child(i).queue_free()
	if isDayTime:
		dayAudioStart()
	else:
		nightAudioStart()

func createAudioStreamPlayer(sfx_asset, isDay : bool, playNow: bool, randomized : bool, loop : bool, volume : float, pitch : float, bus : String):
	var sfx = AudioStreamPlayer.new()
	sfx.set_stream(sfx_asset)
	env_audio.add_child(sfx)
	sfx.volume_db = volume
	sfx.volume_linear = volume
	sfx.pitch_scale = pitch
	sfx.bus = "SFX"
	
	if randomized:
		if playNow:
			if sfx != null:
				sfx.play()
		else:
			await get_tree().create_timer(delay_randomizer()).timeout
			if sfx != null:
				sfx.play()
			
		if isDay == isDayTime:
			await get_tree().create_timer(time_randomizer()).timeout
			if isDay == isDayTime:
				createAudioStreamPlayer(sfx_asset, isDay, playNow, randomized, loop, volume, pitch, bus)
		if sfx != null:
			sfx.queue_free()
	else:
		if playNow:
			sfx.play()
		else:
			await get_tree().create_timer(delay_randomizer()).timeout
			sfx.play()

func time_randomizer():
	var time = randi_range(5, 20)
	return time
	
func delay_randomizer():
	var time = randi_range(1, 2)
	return time

func pitch_randomizer():
	var pitch = randf_range(0.25, 1.0)
	return pitch

func volume_randomizer():
	var volume = randf_range(0.25, 1.0)
	return volume
