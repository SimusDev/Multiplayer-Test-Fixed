extends W_FPController
class_name W_FPControllerCamera

@export var make_current_at_start: bool = true
@export var camera: Camera3D
@export var camera_angle_min: float = -90
@export var camera_angle_max: float = 90

@export_group("Sensitivity")
@export var configurable_sensitivity: bool = true
@export var custom_cursor: bool = false
@export var sensitivity: float = 1.0

@export_group("Free Camera")
@export var freecam_speed: float = 10.0
@export var freecam_boost_scale: float = 3.0
@export var freecam_slowdown_scale: float = 0.3
@export var key_forward: String = "ui_up"
@export var key_backward: String = "ui_down"
@export var key_left: String = "ui_left"
@export var key_right: String = "ui_right"
@export var key_boost: String = "boost"
@export var key_slowdown: String = "slowdown"

@export var auto_update_mouse: bool = true

signal mouse_motion(event: InputEventMouseMotion, relative: Vector2)

func is_current() -> bool:
	return camera.current

func is_can_free_move() -> bool:
	return (not character_component) and camera.current

func _ready() -> void:
	enabled_status_changed.connect(_on_enabled_status_changed)
	console.visibility_changed.connect(_on_console_visibility_changed)
	
	_setup_configurable_sensitivity()
	_setup_camera()
	

func _physics_process(delta: float) -> void:
	if not enabled:
		return
	
	if is_can_free_move():
		_handle_free_camera(delta)

func _handle_free_camera(delta: float) -> void:
	if console.is_visible():
		return
	
	var input_dir: Vector2 = Input.get_vector(key_left, key_right, key_forward, key_backward)
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	var velocity: Vector3 = direction
	velocity *= freecam_speed
	
	if Input.is_action_pressed(key_boost):
		velocity *= freecam_boost_scale
	if Input.is_action_pressed(key_slowdown):
		velocity *= freecam_slowdown_scale
	
	global_translate(velocity * delta)
	


func _setup_camera() -> void:
	if make_current_at_start:
		make_current()
	
	camera.current = is_current()
	update_mouse()

func make_current() -> void:
	camera.make_current()

func _setup_configurable_sensitivity() -> void:
	if configurable_sensitivity:
		var cmd: SD_ConsoleCommand = console.create_command("sensitivity", sensitivity)
		cmd.updated.connect(_on_config_sensitivity_update.bind(cmd))
		cmd.update_command()

func _on_config_sensitivity_update(cmd: SD_ConsoleCommand) -> void:
	sensitivity = cmd.get_value_as_float()

func _on_console_visibility_changed() -> void:
	if auto_update_mouse:
		update_mouse()

func update_mouse() -> void:
	
	if enabled and !console.is_visible():
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		if custom_cursor:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event: InputEvent) -> void:
	if console.is_visible() or (not enabled):
		return
	
	if event is InputEventMouseMotion:
		var sens: float = W_FPController.get_normalized_mouse_sensitivity(sensitivity)
		var relative: Vector2 = event.relative
		
		var y: float = deg_to_rad(-relative.x * sens)
		var x: float = deg_to_rad(-relative.y * sens)
		
		var _body: CharacterBody3D
		if character_component:
			_body = character_component.body
		
		if _body:
			_body.rotate_y(y)
			rotate_x(x)
			rotation.x = clamp(rotation.x, deg_to_rad(camera_angle_min), deg_to_rad(camera_angle_max))
		else:
			if is_can_free_move():
				rotate_y(y)
				var pitch: float = x
				rotate_object_local(Vector3(1, 0, 0), pitch)



func _on_enabled_status_changed(status: bool) -> void:
	update_mouse()
