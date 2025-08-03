extends Node2D

const SCREEN_WIDTH : float = 1920;
var starting_x = SCREEN_WIDTH * 2.5; # Screen width * (number of screen widths  / 2)
var max_x = -1 * (starting_x - 1920);

var scroll_rate_per_second : float = 2000;

func _ready() -> void:
	$BackgroundImage.position.x = starting_x;

func _process(delta: float) -> void:
	var old_x_pos = $BackgroundImage.position.x;
	var new_x_pos = old_x_pos - (delta * scroll_rate_per_second);
	if new_x_pos <= max_x:
		new_x_pos += (1920 * 4);
	
	$BackgroundImage.position.x = new_x_pos;



func start_scroll():
	pass;
	
func stop_scroll():
	pass;
