class_name ScrollingBackground extends Node2D

const SCREEN_WIDTH : float = 1920;
var starting_x = SCREEN_WIDTH * 2.5; # Screen width * (number of screen widths  / 2)
var max_x = -1 * (starting_x - 1920);

static var scroll_rate_per_second : float = 1000;

var is_stopped = false;

func _ready() -> void:
	SignalBus.player_died.connect(stop_scroll);
	$BackgroundImage.position.x = starting_x;

func _process(delta: float) -> void:
	if is_stopped:
		return;
	
	var old_x_pos = $BackgroundImage.position.x;
	var new_x_pos = old_x_pos - (delta * ScrollingBackground.scroll_rate_per_second);
	if new_x_pos <= max_x:
		new_x_pos += (1920 * 4);
	
	$BackgroundImage.position.x = new_x_pos;



func start_scroll():
	is_stopped = false;
	
func stop_scroll():
	is_stopped = true;
