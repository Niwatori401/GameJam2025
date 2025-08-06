extends Node2D


var is_game_over = false;

const SUCCESS_MR_MOUSE_SPRITE = preload("res://asset/texture/minigame/SafeOpening/MrMouse_OpeningSafe_Success.png");
#const CORRECT_TICK_SOUND = preload();
#const NORMAL_TICK_SOUND = preload("res://asset/sound/minigame/SafeOpening/NormalTick.ogg");

const NUMBER_OF_ANGLE_DIVISIONS = 30;
const ANGLE_DIVISION_MAGNITUDE = TAU / NUMBER_OF_ANGLE_DIVISIONS;
var current_ring_index = 1;

var rotation_solution_ring_1 = randi_range(1, NUMBER_OF_ANGLE_DIVISIONS - 1); # outer-most
var rotation_solution_ring_2 = randi_range(1, NUMBER_OF_ANGLE_DIVISIONS - 1);
var rotation_solution_ring_3 = randi_range(1, NUMBER_OF_ANGLE_DIVISIONS - 1); # inner-most

var current_rotation_index : int = 0;

func _process(delta: float) -> void:
	if is_game_over:
		return;
		
	if Input.is_action_just_pressed("fire_weapon"):
		try_lock_in_answer();
	
	if current_ring_index >= 4:
		win();
		return; 
	
	
	var current_knob : Node2D = ($Safe/Rings.get_children()[current_ring_index - 1] as Node2D)
	rotate_knob_rings_and_arm(current_knob, delta);
	var new_rotation_index = floori(current_knob.rotation / ANGLE_DIVISION_MAGNITUDE) % 30;
	if new_rotation_index != current_rotation_index:
		current_rotation_index = new_rotation_index;
		try_make_tick_sounds();
	

	
	
	
	
	
	
	
	
	
	
	
	

func try_make_tick_sounds():
	var success : bool = false;
	match current_ring_index:
		1:
			success = rotation_solution_ring_1 == current_rotation_index;
		2:
			success = rotation_solution_ring_2 == current_rotation_index;
		3:
			success = rotation_solution_ring_3 == current_rotation_index;
		_:
			printerr("Default case in try_make_tick_sounds()");
	
	if success:
		$SFX.pitch_scale = 2.0;
		$SFX.play();
	else:
		$SFX.pitch_scale = 1.0;
		$SFX.play();
		pass;

func rotate_knob_rings_and_arm(current_knob, delta):
	var movement = Utility.get_move_direction_from_inputs();
	const BASE_ROTATE_SPEED = 1;
	var rotation_speed = BASE_ROTATE_SPEED * delta * movement.x;
	current_knob.rotate(rotation_speed);
	$Safe/Knob.rotate(rotation_speed);
	tween_arm(rotation_speed);

func tween_arm(rotation_speed : float) -> void:
	const MIN_ARM_ANGLE = 0;
	const MAX_ARM_ANGLE = deg_to_rad(30);
	
	$MrMouse/MrMouseHand.rotate(rotation_speed);
	if $MrMouse/MrMouseHand.rotation > MAX_ARM_ANGLE:
		$MrMouse/MrMouseHand.rotation = MIN_ARM_ANGLE;
	elif $MrMouse/MrMouseHand.rotation < MIN_ARM_ANGLE:
		$MrMouse/MrMouseHand.rotation = MAX_ARM_ANGLE

func try_lock_in_answer():
	var success : bool = false;
	match current_ring_index:
		1:
			success = rotation_solution_ring_1 == current_rotation_index;
		2:
			success = rotation_solution_ring_2 == current_rotation_index;
		3:
			success = rotation_solution_ring_3 == current_rotation_index;
		_:
			printerr("Default case in try_lock_in_answer()");
	
	if success:
		current_ring_index += 1;

func win():
	is_game_over = true;
	$MrMouse/MrMouseHead.texture = SUCCESS_MR_MOUSE_SPRITE;
