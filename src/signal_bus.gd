extends Node

# Gameplay Signals
@warning_ignore_start("unused_signal")
signal night_started
signal day_started
signal game_over
signal danger_time
signal end_danger_time

# Bunny Signals
signal bunny_count_change
signal time_increment
signal requirement_increment

# Audio Signals #
signal main_menu
signal main_level

# CSV Signals #
signal request_csv_to_resource
