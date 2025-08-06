extends Node

const ENEMY_CAR_1 = preload("res://scene/enemy_car_1.tscn");

var current_delay : float = 0;

var spawn_delays = [
	2,
	4,
	5,
]

var spawn_groups = [
	[ENEMY_CAR_1],
	[ENEMY_CAR_1],
	[ENEMY_CAR_1, ENEMY_CAR_1]
]


func _ready():
	assert(len(spawn_delays) == len(spawn_groups));
	SignalBus.hit_enemy.connect(deal_damage_to_enemy);
	
func _process(delta):
	if len(spawn_delays) == 0:
		return;
	
	current_delay += delta;
	if current_delay >= spawn_delays[0]:
		current_delay -= spawn_delays[0];
		spawn_delays.pop_front();
		spawn_next_enemies();
		spawn_groups.pop_front();
	
func spawn_next_enemies():
	for enemy in spawn_groups[0]:
		spawn_single_enemy(enemy);
	
	
func deal_damage_to_enemy(damage, enemy):
	if enemy != null and enemy.has_method("_on_hit"):
		enemy._on_hit(damage);

func spawn_single_enemy(enemy) -> void:
	var enemy_instance = enemy.instantiate();
	enemy_instance.visible = false;
	get_parent().add_child(enemy_instance);
	# meant for rigid bodies, but might work for character bodies? randf_range(100, 500)
	#Utility.teleport_characterbody2d(enemy_instance, Vector2(200, 900));
	enemy_instance.visible = true;
