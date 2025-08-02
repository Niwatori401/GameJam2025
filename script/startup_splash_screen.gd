extends DestructibleScene

func destroy():
	SignalBus.destroy_scene.emit(name);
