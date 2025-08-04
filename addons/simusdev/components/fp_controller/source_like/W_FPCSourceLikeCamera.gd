extends W_FPCSourceLike
class_name W_FPCSourceLikeCamera

@export var body: Node3D
@export_group("References")
@export var camera: Camera3D

@export_group("Camera Settings")
@export var make_current_at_start: bool = true
@export var camera_angle_min: float = -90
@export var camera_angle_max: float = 90

@export_group("Mouse Settings")
@export var mouse_sensitivity: float = 1.0

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

static var _active_camera_list: Array[W_FPCSourceLikeCamera] = []

static func get_active_camera_list() -> Array[W_FPCSourceLikeCamera]:
	return _active_camera_list

func _exit_tree() -> void:
	super()
	
	enabled = false
	
	if !_active_camera_list.is_empty():
		var camera: W_FPCSourceLikeCamera = _active_camera_list[_active_camera_list.size() - 1]
		if is_instance_valid(camera):
			camera.make_current()

func _enter_tree() -> void:
	super()
	

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
	if not is_authority():
		add_disable_priority()
		return
	
	_enabled_status_changed()
	
	#console.visibility_changed.connect(_on_console_visibility_changed)
	SimusDev.ui.interface_opened_or_closed.connect(_on_interface_opened_or_closed)
	
	if make_current_at_start:
		if is_authority():
			make_current()
			set_mouse_captured(true)

	if SimusDev.ui.has_active_interface():
		add_disable_priority()
		return

func _process(delta: float) -> void:
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
		
