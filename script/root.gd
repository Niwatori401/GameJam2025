extends Node




func _ready() -> void:
	SignalBus.destroy_scene.connect(destroy_node);
	var splashScene = Utility.instantiate_scene(self, Strings.SCENE_STARTUP_SPLASH_SCREEN);
	const SPLASH_SCREEN_SECONDS := 2.0;
	
	get_tree().create_timer(SPLASH_SCREEN_SECONDS).timeout.connect(\
		func():
			splashScene.destroy();
			Utility.instantiate_scene(self, Strings.SCENE_MAIN_MENU);
	);

	
func _process(delta: float) -> void:
	pass;


func destroy_node(nodeId):
	for c in get_children(false):
		if c.name == nodeId:
			remove_child(c);
