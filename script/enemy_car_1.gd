class_name EnemyCar extends CharacterBody2D

var should_freeze : bool = false;
var should_fall_behind : bool = false;


var speed = 1000;
var vertical_damping = 0.5;

const MAX_HEALTH : float = 20;
var current_health : float = MAX_HEALTH;

var graphic_list = [
	preload("res://asset/enemy_car.png"),
	preload("res://asset/enemy_car_damaged.png"),
	preload("res://asset/enemy_car_destroyed.png")
]

var min_health_for_graphic = [
	MAX_HEALTH / 2,
	0,
	-INF
]

const BULLET := preload("res://scene/enemy_bullet_1.tscn");
const BULLET_SPEED :float = 1000;

const SHOOT_DELAY_SECONDS : float = 1;
var current_shoot_delay_seconds : float = 0;

const INITIAL_DELAY_SECONDS : float = 1;
var current_delay_seconds : float = INITIAL_DELAY_SECONDS + 1; # add small delay between invincible moving onto screen and shooting start

var map_entry_pos = Vector2(randf_range(215, 512), randf_range(250, 820));


func _ready() -> void:
	SignalBus.player_died.connect(handle_player_death);
	$Hitbox.set_deferred("disabled", true);
	var initial_pos = Vector2(randf_range(-512, -200), randf_range(250, 820));
	Utility.teleport_characterbody2d(self, initial_pos);
	


var total_delta : float = 0;

func _process(delta: float) -> void:
	if should_fall_behind:
		move_and_collide(Vector2(-ScrollingBackground.scroll_rate_per_second * delta, 0));
		return;
	
	if should_freeze:
		return;
	
	if current_delay_seconds >= 0:
		approach_starting_position(delta);
		current_delay_seconds -= delta;
		if current_delay_seconds <= 0:
			$Hitbox.set_deferred("disabled", false);
		
		return;
	
	total_delta += delta;
	current_shoot_delay_seconds += delta;
	
	
	if current_shoot_delay_seconds >= SHOOT_DELAY_SECONDS:
		current_shoot_delay_seconds -= SHOOT_DELAY_SECONDS;
		shoot();
	
	move_and_collide(delta * get_movement_vector());

func approach_starting_position(delta):
	var PERCENT_TO_MOVE_PER_SECOND = (1 / INITIAL_DELAY_SECONDS);
	var target_location = global_position + ((map_entry_pos - global_position) * PERCENT_TO_MOVE_PER_SECOND * delta);
	Utility.teleport_characterbody2d(self, target_location);





func get_movement_vector() -> Vector2:
	return Vector2(cos(total_delta) / 5 * speed, sin(total_delta)/5 * speed * vertical_damping);
	
	


func get_player_direction_vector() -> Vector2:
	var player_car = get_tree().get_first_node_in_group(Strings.PLAYER_GROUP);
	var player_pos = player_car.get_global_coords_for_car_center();
	var bullet_centering_offset = BULLET.instantiate().get_node("Hitbox").shape.get_rect().size * Vector2(1, -3);
	var aim_direction = $BulletSpawnPoint.global_position - player_pos - bullet_centering_offset;
	return aim_direction;

func _on_hit(damage : float):
	current_health -= damage;
	if current_health <= 0:
		die();
		
	update_sprite();

func shoot() -> void:
	var bullet_instance = BULLET.instantiate();
	# This could cause issues if there is not parent, but in practice that shouldn't happen.
	# Adding as child of car causes bullets to "vibrate"
	get_parent().add_child(bullet_instance);
	const DEPSAWN_SECONDS = 5.0;
	get_tree().create_timer(DEPSAWN_SECONDS).timeout.connect(func(): if bullet_instance != null: bullet_instance.queue_free())
	var velocity_vector = (get_player_direction_vector()).normalized() * BULLET_SPEED;
	Utility.teleport(bullet_instance, $BulletSpawnPoint.global_position, -velocity_vector);


func update_sprite():
	for i in range(len(min_health_for_graphic)):
		if current_health > min_health_for_graphic[i]:
			if $CarSprite.texture != graphic_list[i]:
				$CarSprite.texture = graphic_list[i];
			return;
			
	
	$CarSprite.texture = graphic_list[len(graphic_list) - 1];

func die():
	should_fall_behind = true;
	$Hitbox.set_deferred("disabled", true);
	get_tree().create_timer(3.0).timeout.connect(func(): queue_free());

func handle_player_death():
	should_freeze = true;
