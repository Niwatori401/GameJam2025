extends CharacterBody2D

var speed = 1000;
var vertical_damping = 0.5;
const BULLET = preload("res://scene/bullet_1.tscn");

const BULLET_SPEED :float = 2000;

func _ready() -> void:
	pass;
	

func _process(delta: float) -> void:
	var movement_direction = get_direction_from_inputs()
	var velocity_target = Vector2(delta * speed * movement_direction.x, delta * speed * movement_direction.y * vertical_damping);
	move_and_collide(velocity_target);
	#position.x += delta * speed * movement_direction.x;
	#position.y += delta * speed * movement_direction.y * vertical_damping;
	
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
	get_tree().create_timer(DEPSAWN_SECONDS).timeout.connect(func(): bullet_instance.queue_free())
	Utility.teleport(bullet_instance, $BulletSpawnPoint.global_position, Vector2(-BULLET_SPEED, 0));
	

	
