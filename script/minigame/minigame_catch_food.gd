extends Node2D

const LAUNCH_ITEM = preload("res://scene/minigame/catch_minigame_pickup_item.tscn");
const SECONDS_DELAY_FOR_LAUNCHING : float = 2;
var current_delay_seconds : float = 1;


func _process(delta: float) -> void:

	current_delay_seconds += delta;
	if current_delay_seconds >= SECONDS_DELAY_FOR_LAUNCHING:
		current_delay_seconds -= SECONDS_DELAY_FOR_LAUNCHING;
		launch_new_item();
	
	var movement = Utility.get_move_direction_from_inputs();
	const MOVESPEED = 1500;
	$MrMouse.global_position = clamp($MrMouse.global_position + Vector2(movement.x, 0) * delta * MOVESPEED, Vector2(300, $MrMouse.global_position.y), Vector2(1940, $MrMouse.global_position.y));

func launch_new_item():
	var spawn_point = $MsMouse/ItemSpawnpoint.global_position;
	var launch_vector = Vector2(randf_range(-300, 1000), randf_range(-200, -800));
	var item_instance = LAUNCH_ITEM.instantiate();
	add_child(item_instance);
	Utility.teleport(item_instance, spawn_point, launch_vector);
