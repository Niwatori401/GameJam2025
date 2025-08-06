class_name Utility extends Node

static var save_file : ConfigFile = ConfigFile.new();
static var config_file : ConfigFile = ConfigFile.new();



static func _static_init() -> void:
	make_config_and_save_files_if_needed();
	save_file.load(Strings.USER_SAVE_FILE);
	config_file.load(Strings.USER_CONFIG_FILE);
		
	#SignalBus.save_deleted.connect(load_inventory_from_file);
	#load_inventory_from_file();


func _process(_delta: float) -> void:
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
	

static func get_move_direction_from_inputs() -> Vector2:
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
	

static func get_aim_direction_from_inputs() -> Vector2:
	var aim = Vector2();
	if Input.is_action_pressed("aim_up"):
		aim.y += -1;
	if Input.is_action_pressed("aim_down"):
		aim.y += 1;
	if Input.is_action_pressed("aim_right"):
		aim.x += 1;
	if Input.is_action_pressed("aim_left"):
		aim.x += -1;
	
	return aim;


static func despawn_object_in_x_seconds(object, seconds : float) -> void:
	object.get_tree().create_timer(seconds).timeout.connect(despawn_instance.bind(object));
	


# Capturing a vairable that may be freed elsewhere in a lambda causes an error to be created, even though there are no adverse effects.
# https://github.com/godotengine/godot/issues/85947
# Doing get_tree().create_timer(TIME).timeout.connect(despawn_instance.bind(instance)) gets around this bug.
static func despawn_instance(instance):
	if is_instance_valid(instance):
		instance.queue_free();

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


static func teleport_characterbody2d(object: CharacterBody2D, position: Vector2) -> void:
	var id = object.get_rid()
	object.global_transform = Transform2D.IDENTITY.translated(position)
	PhysicsServer2D.body_set_state(id, PhysicsServer2D.BODY_STATE_TRANSFORM, Transform2D.IDENTITY.translated(position))

# from https://www.chrismccole.com/blog/how-to-teleport-an-object-with-physics-in-godot
static func teleport(object: RigidBody2D, position: Vector2, velocity: Vector2 = Vector2.ZERO, angularVelocity:float = 0.0, isSleeping:bool = false) -> void:
	var id = object.get_rid()
	object.global_transform = Transform2D.IDENTITY.translated(position)
	PhysicsServer2D.body_set_state(id, PhysicsServer2D.BODY_STATE_TRANSFORM, Transform2D.IDENTITY.translated(position))

	object.linear_velocity = velocity
	PhysicsServer2D.body_set_state(id, PhysicsServer2D.BODY_STATE_LINEAR_VELOCITY, velocity)
	object.angular_velocity = angularVelocity
	PhysicsServer2D.body_set_state(id, PhysicsServer2D.BODY_STATE_ANGULAR_VELOCITY, angularVelocity)
	object.sleeping = isSleeping
	PhysicsServer2D.body_set_state(id, PhysicsServer2D.BODY_STATE_SLEEPING, isSleeping)

static func set_gravity(object: RigidBody2D, gravityScale:float) -> void:
	var id = object.get_rid()
	object.gravity_scale = gravityScale;
	PhysicsServer2D.body_set_param(id, PhysicsServer2D.BODY_PARAM_GRAVITY_SCALE, gravityScale)
