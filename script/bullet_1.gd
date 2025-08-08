extends RigidBody2D

const DAMAGE = 10;
var DEFAULT_ROTATION = PI / 4;

func _on_body_entered(body: Node) -> void:
	SignalBus.hit_enemy.emit(DAMAGE, body);
	queue_free();

func rotate_sprite_to(rad):
	$Sprite.call_deferred("set_global_rotation", rad + DEFAULT_ROTATION);
