extends RigidBody2D

const DAMAGE = 10;

func _ready() -> void:
	pass

func _on_body_entered(body: Node) -> void:
	SignalBus.hit_enemy.emit(DAMAGE, body);
	queue_free();
