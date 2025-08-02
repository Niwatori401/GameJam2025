class_name DestructibleScene
extends Node2D

func destroy():
	assert(false, "The destroy method must be overriden by the child.")
	#SignalBus.destroy_scene.emit(id);
	
