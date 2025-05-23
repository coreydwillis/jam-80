extends Node

# Gameplay Signals
@warning_ignore_start("unused_signal")
signal night_started
signal day_started
signal game_over
signal game_win
signal danger_time
signal end_danger_time
signal egg_count_change
signal day_increment
signal check_win
signal item_bought(item_name: String)
signal splash_done
signal reset_game_vars
signal reset_names
signal player_drink
signal player_eat
signal magnet_activated(mult: float)

# Ability Signals
signal dash_purchased
signal dash_ready
signal dash_not_ready
signal boombox_purchased
signal boombox_ready
signal boombox_not_ready
signal magnet_purchased
signal magnet_ready
signal magnet_not_ready
signal hammer_purchased
signal hammer_ready
signal hammer_not_ready
signal consume_item
signal cycle_consume

# Bunny Signals
signal bunny_count_change
signal time_increment

# Audio Signals #
signal main_menu
signal main_level

# CSV Signals #
signal request_csv_to_resource
