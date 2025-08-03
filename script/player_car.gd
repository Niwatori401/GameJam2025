extends Node2D

var speed = 1000;
var vertical_damping = 0.5;
const BULLET = preload("res://scene/bullet_1.tscn");


func _ready() -> void:
	pass;
	
func _process(delta: float) -> void:
	var movement_direction = get_direction_from_inputs()
	position.x += delta * speed * movement_direction.x;
	position.y += delta * speed * movement_direction.y * vertical_damping;
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
	add_child(bullet_instance);
	get_tree().create_timer(3.0).timeout.connect(func(): bullet_instance.queue_free())
	Utility.teleport(bullet_instance, $BulletSpawnPoint.global_position);
	

	
