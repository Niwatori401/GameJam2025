extends Node

static var save_file : ConfigFile = ConfigFile.new();
static var config_file : ConfigFile = ConfigFile.new();



static func _static_init() -> void:
	make_config_and_save_files_if_needed();
	save_file.load(Strings.USER_SAVE_FILE);
	config_file.load(Strings.USER_CONFIG_FILE);
		
	#SignalBus.save_deleted.connect(load_inventory_from_file);
	#load_inventory_from_file();


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("kill_game"):
		get_tree().quit();

static func get_save():
	return save_file;

static func get_config():
	return config_file;


static func instantiate_scene(parent : Node, new_scene_string : String):
	ResourceLoader.load_threaded_request(new_scene_string);
	var scene = ResourceLoader.load_threaded_get(new_scene_string);
	var res = scene.instantiate();
	parent.add_child(res);
	return res;
	
	


static func make_config_and_save_files_if_needed():
	config_file = ConfigFile.new();
	save_file = ConfigFile.new();
	
	var save_load_status = save_file.load(Strings.USER_SAVE_FILE);
	var config_load_status = config_file.load(Strings.USER_CONFIG_FILE);

	if save_load_status != OK:
		save_file = ConfigFile.new();
		save_file.save(Strings.USER_SAVE_FILE);
		
	if config_load_status != OK:
		config_file = ConfigFile.new();
		config_file.save(Strings.USER_CONFIG_FILE);
