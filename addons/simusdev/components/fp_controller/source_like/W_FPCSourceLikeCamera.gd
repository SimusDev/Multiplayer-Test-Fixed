extends W_FPCSourceLike
class_name W_FPCSourceLikeCamera

@export var body: CharacterBody3D
@export_group("References")
@export var camera: Camera3D

@export_group("Camera Settings")
@export var make_current_at_start: bool = true
@export var camera_angle_min: float = -90
@export var camera_angle_max: float = 90

@export_group("Mouse Settings")
const DEFAULT_SENSITIVITY: float = 1.0
@export var mouse_sensitivity: float = DEFAULT_SENSITIVITY

@export var _mouse_captured: bool = false

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

var mouse_input:Vector2 = Vector2.ZERO

static var _active_camera_list: Array[W_FPCSourceLikeCamera] = []

@onready var _sensitivity_cmd: SD_ConsoleCommand

static var instance: W_FPCSourceLikeCamera

static func get_local_sensitivity() -> float:
	if instance:
		return instance._sensitivity_cmd.get_value_as_float()
	return DEFAULT_SENSITIVITY

static func get_active_camera_list() -> Array[W_FPCSourceLikeCamera]:
	return _active_camera_list

func _exit_tree() -> void:
	super()
	
	if is_authority():
		enabled = false
	
	if !_active_camera_list.is_empty():
		var camera: W_FPCSourceLikeCamera = _active_camera_list[_active_camera_list.size() - 1]
		if is_instance_valid(camera):
			camera.make_current()
	
	

func _enter_tree() -> void:
	super()
	
	if is_authority():
		enabled = true

func make_current() -> void:
	if camera:
		camera.make_current()
		enabled = true

func set_current(value: bool) -> void:
	if camera:
		camera.current = value
		enabled = true

func _enabled_status_changed() -> void:
	
	if enabled:
		
		for i in get_instance_list():
			if i is W_FPCSourceLikeCamera:
				if not i == self:
					i.enabled = false
		
		SD_Array.append_to_array_no_repeat(_active_camera_list, self)
	else:
		SD_Array.erase_from_array(_active_camera_list, self)
	
	set_process(enabled)
	set_physics_process(enabled)
	set_process_input(enabled)
	set_process_unhandled_input(enabled)
	
	if is_authority():
		set_mouse_captured(enabled)
	
	

func _ready() -> void:
	SD_Network.register_object(self)
	
	SD_Components.append_to(body, self)
	if not is_authority():
		add_disable_priority()
		return
	
	_enabled_status_changed()
	
	#console.visibility_changed.connect(_on_console_visibility_changed)
	SimusDev.ui.interface_opened_or_closed.connect(_on_interface_opened_or_closed)
	
	if is_authority():
		instance = self
		_sensitivity_cmd = SD_ConsoleCommand.get_or_create("sensitivity", DEFAULT_SENSITIVITY)
		_sensitivity_cmd.executed.connect(_update_sensitivity)
		_update_sensitivity()
	
	if make_current_at_start:
		if is_authority():
			make_current()
			set_mouse_captured(true)

	if SimusDev.ui.has_active_interface():
		add_disable_priority()
		return

func _update_sensitivity() -> void:
	mouse_sensitivity = _sensitivity_cmd.get_value_as_float()

func viewmodel_sway(delta:float) -> void:
	pass
	#mouse_input = lerp(mouse_input, Vector2.ZERO, 10*delta)
	#if viewmodel:
		#viewmodel.rotation.x = lerp(viewmodel.rotation.x, (mouse_input.y * 0.025) * sway_multiplier, 10 * delta)
		#viewmodel.rotation.y = lerp(viewmodel.rotation.y, (mouse_input.x * 0.025)  * sway_multiplier, 10 * delta)

func _process(delta: float) -> void:
	#viewmodel_sway(delta)
	
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
	


func _on_console_visibility_changed() -> void:
	if console.is_visible():
		add_disable_priority()
	else:
		subtract_disable_priority()
	

func _on_interface_opened_or_closed(node: Node, status: bool) -> void:
	if status:
		add_disable_priority()
	else:
		subtract_disable_priority()

func set_mouse_captured(value: bool) -> void:
	var cursor: SD_TrunkCursor = SimusDev.cursor
	_mouse_captured = value
	
	cursor.set_mode(cursor.MODE_VISIBLE)
	if _mouse_captured:
		cursor.set_mode(cursor.MODE.CAPTURED)

func is_mouse_captured() -> bool:
	return _mouse_captured

func is_can_free_move() -> bool:
	return (not body) and camera.current


func _unhandled_input(event: InputEvent) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	
	if event is InputEventMouseMotion:
		var sens: float = normalize_mouse_sensitivity(mouse_sensitivity)
		var relative: Vector2 = event.relative
		
		mouse_input = relative * sens
		
		var y: float = deg_to_rad(-relative.x * sens)
		var x: float = deg_to_rad(-relative.y * sens)
		
		if body:
			body.rotate_y(y)
			rotate_x(x)
			rotation.x = clamp(rotation.x, deg_to_rad(camera_angle_min), deg_to_rad(camera_angle_max))
		else:
			if is_can_free_move():
				rotate_y(y)
				var pitch: float = x
				rotate_object_local(Vector3(1, 0, 0), pitch)
