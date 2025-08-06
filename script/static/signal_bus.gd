extends Node

# Make signal declarations here
# Ex: signal store_item_selected(item_name, item_description, item_price)
# Invoked as: SignalBus.store_item_selected.connect(set_text_for_currently_selected_item); in source files
@warning_ignore_start("unused_signal")
signal destroy_scene(scene_name)
signal hit_player(damage)
signal hit_enemy(damage, vehicle)
signal player_died
