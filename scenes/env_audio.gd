extends Node

@onready var env_audio = $"."

#audio transition vars
@export var transition_duration = 1.00
@export var transition_type = 1 # TRANS_SINE
@onready var tween: Tween

var isDayTime: bool = true

func _ready():
	dayAudioStart()
	SignalBus.night_started.connect(timePeriodAudioEnd)
	SignalBus.day_started.connect(timePeriodAudioEnd)

func dayAudioStart():
	var birbsStreamAsset = load("res://assets/audio/sfx/env/day/Birbs.wav")
	createAudioStreamPlayer(birbsStreamAsset, true, true, true, true, false, 0.1, 1, "SFX")
	
func nightAudioStart():
	await get_tree().create_timer(0.1).timeout
	if !Game.game_over:
		var owl1StreamAsset = load("res://assets/audio/sfx/env/night/Owl Call 1.wav")
		createAudioStreamPlayer(owl1StreamAsset, false, false, false, true, false, 10.0, 1.0, "SFX")
		var clothStreamAsset = load("res://assets/audio/sfx/env/night/Cloth Flapping.wav")
		createAudioStreamPlayer(clothStreamAsset, false, false, true, true, false, 1, 1.0, "SFX")
		var crowdStreamAsset = load("res://assets/audio/sfx/env/night/Crowd.wav")
		createAudioStreamPlayer(crowdStreamAsset, false, false, true, true, false, 1, 1.0, "SFX")
		var fireStreamAsset = load("res://assets/audio/sfx/env/night/Fireplace Main.wav")
		createAudioStreamPlayer(fireStreamAsset, false, false, true, true, false, 1, 1.0, "SFX")
		var owl2StreamAsset = load("res://assets/audio/sfx/env/night/Owl Call 2.wav")
		createAudioStreamPlayer(owl2StreamAsset, false, false, false, true, false, 1, 1.0, "SFX")
		var twig1StreamAsset = load("res://assets/audio/sfx/env/night/Twigs1.wav")
		createAudioStreamPlayer(twig1StreamAsset, false, false, false, true, false, 1, 1.0, "SFX")
		var twig2StreamAsset = load("res://assets/audio/sfx/env/night/Twigs1.wav")
		createAudioStreamPlayer(twig2StreamAsset, false, false, false, true, false, 1, 1.0, "SFX")
		var twig3StreamAsset = load("res://assets/audio/sfx/env/night/Twigs1.wav")
		createAudioStreamPlayer(twig3StreamAsset, false, false, false, true, false, 1, 1.0, "SFX")
	
	
func timePeriodAudioEnd():
	isDayTime = !isDayTime
	await get_tree().create_timer(1).timeout
	for i in range(0, env_audio.get_child_count()):
		env_audio.get_child(i).queue_free()
	if isDayTime:
		dayAudioStart()
	else:
		nightAudioStart()
	


func createAudioStreamPlayer(sfx_asset, isDay : bool, playNow: bool, fadeIn : bool, randomized : bool, loop : bool, volume : float, pitch : float, bus : String):
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
				if fadeIn:
					fade_in(sfx)
				else:
					sfx.play()
		else:
			await get_tree().create_timer(delay_randomizer()).timeout
			if sfx != null:
				if fadeIn:
					fade_in(sfx)
				else:
					sfx.play()
			
		if isDay == isDayTime:
			await get_tree().create_timer(time_randomizer()).timeout
			if isDay == isDayTime:
				createAudioStreamPlayer(sfx_asset, isDay, fadeIn, playNow, randomized, loop, volume, pitch, bus)
		if sfx != null:
			fade_out(sfx)
	else:
		if playNow:
			if fadeIn:
				fade_in(sfx)
			else:
				sfx.play()
		else:
			await get_tree().create_timer(delay_randomizer()).timeout
			if fadeIn:
				fade_in(sfx)
			else:
				sfx.play()
		if isDay != isDayTime:
			fade_out(sfx)

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

func fade_in(audio_to_fade: AudioStreamPlayer, fade_duration: float = 3.0) -> void:
	if audio_to_fade.playing == false:
		audio_to_fade.play()
	if tween:
		tween.kill()
	tween = create_tween()
	#tween.connect("finished", _on_tween_finished)
	tween.tween_property(audio_to_fade, "volume_db", 0, fade_duration).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT) #Transition and easing set for faster fade in.

func fade_out(audio_to_fade: AudioStreamPlayer, fade_duration: float = 3.0, auto_stop: bool = true) -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.connect("finished", fadeComplete.bind(audio_to_fade))
	tween.tween_property(audio_to_fade, "volume_db", -80, fade_duration) #Turn down the volume to -80dB.
	#Optional, as it might not be ideal to stop the audio in some use cases.
	if auto_stop:
		tween.tween_property(audio_to_fade, "playing", false, 0.0)

func fadeComplete(removeAudio):
	if removeAudio != null:
		removeAudio.queue_free()
