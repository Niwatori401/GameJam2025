extends RigidBody2D






func _on_body_entered(body: Node) -> void:
	if (body.is_in_group(Strings.ITEM_PICKUP_RECEIVER_GROUP)):
		queue_free();
