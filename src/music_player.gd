extends Node

const MUSIC_MAIN = preload("res://assets/audio/music/beta/music_main.mp3")
const DAY_TIME_IDEA = preload("res://assets/audio/music/beta/day time idea.mp3")
const NIGHT_TIME_IDEA = preload("res://assets/audio/music/beta/creepy-256824.mp3")

#audio transition vars
@export var transition_duration = 10.00
@export var transition_type = 1 # TRANS_SINE
@onready var tween: Tween
var menu_music_stream = AudioStreamPlayer.new()
var day_music_stream = AudioStreamPlayer.new()
var night_music_stream = AudioStreamPlayer.new()

func _ready():
	setup_tracks()
	SignalBus.night_started.connect(night_music)
	SignalBus.day_started.connect(day_music)
	SignalBus.main_menu.connect(menu_music)
	SignalBus.main_level.connect(end_menu)

func setup_tracks():
	menu_music_stream.set_stream(MUSIC_MAIN)
	add_child(menu_music_stream)
	day_music_stream.set_stream(DAY_TIME_IDEA)
	add_child(day_music_stream)
	night_music_stream.set_stream(NIGHT_TIME_IDEA)
	add_child(night_music_stream)
	
	menu_music_stream.play()

func night_music():
	fade_out(day_music_stream)
	await get_tree().create_timer(1.5).timeout
	night_music_stream.volume_db = 0.5
	night_music_stream.volume_linear = 0.5
	night_music_stream.play()
	
func day_music():
	fade_out(night_music_stream)
	await get_tree().create_timer(2).timeout
	day_music_stream.volume_db = 1
	day_music_stream.play()

func end_menu():
	fade_out(menu_music_stream)
	await get_tree().create_timer(2).timeout
	day_music_stream.volume_db = 1
	day_music_stream.play()
	
func menu_music():
	fade_out(night_music_stream)
	fade_out(day_music_stream)
	menu_music_stream.volume_db = 1
	menu_music_stream.play()

func play_audio(song):
	var music = AudioStreamPlayer.new()
	music.set_stream(song)
	add_child(music)
	music.volume_db = 1
	music.volume_linear = 1
	music.pitch_scale = 1
	music.bus = "Music"
	fade_in(music)
	
func stop_audio(song):
	fade_out(song)
	
func fade_in(audio_to_fade: AudioStreamPlayer, fade_duration: float = 10.0) -> void:
	print("what")
	if audio_to_fade.playing == false:
		audio_to_fade.play()
	if tween:
		tween.kill()
	tween = create_tween()
	#tween.connect("finished", _on_tween_finished)
	tween.tween_property(audio_to_fade, "volume_db", 0, fade_duration).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT) #Transition and easing set for faster fade in.

func fade_out(audio_to_fade: AudioStreamPlayer, fade_duration: float = 5.0, auto_stop: bool = true) -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	#tween.connect("finished", fadeComplete.bind(audio_to_fade))
	tween.tween_property(audio_to_fade, "volume_db", -80, fade_duration) #Turn down the volume to -80dB.
	#Optional, as it might not be ideal to stop the audio in some use cases.
	if auto_stop:
		tween.tween_property(audio_to_fade, "playing", false, 0.0)
