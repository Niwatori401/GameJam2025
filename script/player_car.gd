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
	
	var movement_direction = get_direction_from_inputs()
	var velocity_target = Vector2(delta * speed * movement_direction.x, delta * speed * movement_direction.y * vertical_damping);
	move_and_collide(velocity_target);
	
	fire_bullets_if_firing();

func get_direction_from_inputs() -> Vector2:
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
	
	
func fire_bullets_if_firing():
	if !Input.is_action_just_pressed("fire_weapon"):
		return;
		
	var bullet_instance = BULLET.instantiate();
	# This could cause issues if there is not parent, but in practice that shouldn't happen.
	# Adding as child of car causes bullets to "vibrate"
	get_parent().add_child(bullet_instance);
	const DEPSAWN_SECONDS = 3.0;
	get_tree().create_timer(DEPSAWN_SECONDS).timeout.connect(func(): if bullet_instance != null: bullet_instance.queue_free())
	Utility.teleport(bullet_instance, $BulletSpawnPoint.global_position, Vector2(-BULLET_SPEED, 0));
	
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
