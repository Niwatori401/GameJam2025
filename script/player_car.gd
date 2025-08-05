extends CharacterBody2D

var speed = 1000;
var vertical_damping = 0.5;
const BULLET = preload("res://scene/bullet_1.tscn");

const BULLET_SPEED :float = 2000;

const MAX_HEALTH : float = 20;
var current_health : float = MAX_HEALTH;

var is_dead : bool = false;

var  graphic_list = [
	preload("res://asset/player_car.png"),
	preload("res://asset/player_car_damaged.png"),
	preload("res://asset/player_car_destroyed.png")
]

var min_health_for_graphic = [
	MAX_HEALTH / 2,
	0,
	-INF
]




func _ready() -> void:
	SignalBus.hit_player.connect(_on_hit);
	

func _process(delta: float) -> void:
	
	if is_dead:
		return;
	
	var movement_direction = get_move_direction_from_inputs()
	var velocity_target = Vector2(delta * speed * movement_direction.x, delta * speed * movement_direction.y * vertical_damping);
	move_and_collide(velocity_target);
	
	fire_bullets_if_firing(get_aim_direction_from_inputs());

func get_move_direction_from_inputs() -> Vector2:
	var movement = Vector2();
	if Input.is_action_pressed("up"):
		movement.y += -1;
	if Input.is_action_pressed("down"):
		movement.y += 1;
	if Input.is_action_pressed("right"):
		movement.x += 1;
	if Input.is_action_pressed("left"):
		movement.x += -1;
	
	return movement;
	

func get_aim_direction_from_inputs() -> Vector2:
	var aim = Vector2();
	if Input.is_action_pressed("aim_up"):
		aim.y += -1;
	if Input.is_action_pressed("aim_down"):
		aim.y += 1;
	if Input.is_action_pressed("aim_right"):
		aim.x += 1;
	if Input.is_action_pressed("aim_left"):
		aim.x += -1;
	
	return aim;

func fire_bullets_if_firing(aim_direction : Vector2):
	if !Input.is_action_just_pressed("fire_weapon"):
		return;
	
	var aim_unit_vector;
	if aim_direction.x != 0:
		const DIAGONAL_ANGLE_OFFSET_MAGNITUDE = deg_to_rad(30);
		aim_unit_vector = Vector2(cos(DIAGONAL_ANGLE_OFFSET_MAGNITUDE) * aim_direction.x, sin(DIAGONAL_ANGLE_OFFSET_MAGNITUDE) * aim_direction.y);
	elif aim_direction.x == 0 and aim_direction.y == 0:
		aim_unit_vector = Vector2(-1, 0);
	else:
		aim_unit_vector = aim_direction;

	aim_unit_vector = aim_unit_vector.normalized();
	
	var bullet_instance = BULLET.instantiate();
	# This could cause issues if there is not parent, but in practice that shouldn't happen.
	# Adding as child of car causes bullets to "vibrate"
	get_parent().add_child(bullet_instance);
	const DESPAWN_SECONDS = 3.0;
	get_tree().create_timer(DESPAWN_SECONDS).timeout.connect(Utility.despawn_instance.bind(bullet_instance));
	Utility.teleport(bullet_instance, $BulletSpawnPoint.global_position, BULLET_SPEED * aim_unit_vector);
	
func get_global_coords_for_car_center() -> Vector2:
	var center_offset = Vector2($CarHitbox.shape.get_rect().size) * Vector2(0.5, 0.5);
	return $CarHitbox.global_position + center_offset;
	
func _on_hit(damage : float):
	current_health -= damage;
	if current_health <= 0:
		die();
		
	update_sprite();
	
func update_sprite():
	for i in range(len(min_health_for_graphic)):
		if current_health > min_health_for_graphic[i]:
			if $CarSprite.texture != graphic_list[i]:
				$CarSprite.texture = graphic_list[i];
			return;
			
	
	$CarSprite.texture = graphic_list[len(graphic_list) - 1];
	
func die():
	is_dead = true;
	SignalBus.player_died.emit();
	print("You died!");
