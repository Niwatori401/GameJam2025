extends RigidBody2D


const DAMAGE = 5;


func _on_body_entered(body: Node) -> void:
	SignalBus.hit_player.emit(DAMAGE);
	queue_free();
