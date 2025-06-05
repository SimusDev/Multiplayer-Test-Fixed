extends W_FPCSourceLike
class_name W_FPCSourceLikeMovement

@export var actor: CharacterBody3D

@export_group("References")
@export var state_machine: SD_NodeStateMachine

@export_group("Movement")
@export var crouch_disabled: bool = false
@export var is_crouched: bool = false : set = set_crouched
@export var is_sprinting: bool = false : set = set_sprinting
@export var gravity: float = 22.0
@export var jump_force: float = 8.0
@export var _move_speed: float = 7.0
@export var _sprint_speed: float = 10.0
@export var _crouch_speed: float = 3.5
@export var _crouch_sprint_speed: float = 3.5
@export var speed_scale: float = 1.0
@export var ground_accel: float = 14.0
@export var ground_decel: float = 10.0
@export var ground_friction: float = 6.0

var wish_direction: Vector3 = Vector3.ZERO

@export_group("Air Movement")
@export var air_cap: float = 0.85
@export var air_accel: float = 800.0
@export var air_move_speed: float = 500.0

@export_group("Input")
@export var input_enabled: bool = true
@export var auto_bhop: bool = false
@export var key_forward: String = "ui_up"
@export var key_backward: String = "ui_down"
@export var key_left: String = "ui_left"
@export var key_right: String = "ui_right"
@export var key_jump: String = "ui_accept"
@export var key_sprint: String = "key_sprint"
@export var key_crouch: String = "key_crouch"

signal jumped()

signal crouched_status_changed()
signal sprinting_status_changed()

func set_crouched(value: bool) -> void:
	if is_crouched == value or crouch_disabled:
		return
	
	is_crouched = value
	crouched_status_changed.emit()

func set_sprinting(value: bool) -> void:
	if is_sprinting == value:
		return
	
	is_sprinting = value
	sprinting_status_changed.emit()

func _enabled_status_changed() -> void:
	set_process(enabled)
	set_physics_process(enabled)

func get_current_state() -> SD_State:
	return state_machine.get_current_state()

func get_move_speed() -> float:
	return _move_speed 

func get_wish_move_speed() -> float:
	var speed: float = _move_speed
	
	if is_crouched:
		speed = _crouch_speed
	elif is_sprinting:
		speed = _sprint_speed
		if is_crouched:
			speed = _crouch_sprint_speed
	
	return speed * speed_scale

func set_move_speed(value: float) -> void:
	_move_speed = value

func get_move_direction() -> Vector3:
	return wish_direction

func get_velocity() -> Vector3:
	return actor.velocity

func is_on_floor() -> bool:
	return actor.is_on_floor()

func _ready() -> void:
	if not is_authority() or console.is_visible():
		add_disable_priority()
		return
	console.visibility_changed.connect(_on_console_visibility_changed)
	
	if actor.is_on_floor():
		state_machine.switch_by_name("ground")
	else:
		state_machine.switch_by_name("air")
	

func _on_console_visibility_changed() -> void:
	if console.is_visible():
		add_disable_priority()
	else:
		subtract_disable_priority()
	

func _physics_process(delta: float) -> void:
	if input_enabled and enabled:
		var input_dir: Vector2 = Input.get_vector(key_left, key_right, key_forward, key_backward).normalized()
		wish_direction = self.global_transform.basis * Vector3(input_dir.x, 0., input_dir.y)
		
		is_sprinting = Input.is_action_pressed(key_sprint)
		is_crouched = Input.is_action_pressed(key_crouch)
	else:
		wish_direction = Vector3.ZERO
	
	if actor.is_on_floor():
		_handle_ground_physics(delta)
	else:
		_handle_air_physics(delta)
	
	actor.move_and_slide()

func _handle_ground_physics(delta: float) -> void:
	#actor.velocity.x = wish_direction.x * get_wish_move_speed()
	#actor.velocity.z = wish_direction.z * get_wish_move_speed()

	if input_enabled and enabled:
		if (!auto_bhop and Input.is_action_just_pressed(key_jump)) or (auto_bhop and Input.is_action_pressed(key_jump)):
			jump()
	
	var cur_speed_in_wish_dir: float = actor.velocity.dot(wish_direction)

	var add_speed_til_cap: float = get_wish_move_speed() - cur_speed_in_wish_dir
	if add_speed_til_cap > 0:
		var accel_speed: float = ground_accel * air_move_speed * delta
		accel_speed = min(accel_speed, add_speed_til_cap)
		actor.velocity += accel_speed * wish_direction
	
	
	var control: float = max(actor.velocity.length(), ground_decel)
	var drop: float = control * ground_friction * delta
	var new_speed: float = max(actor.velocity.length() - drop, 0.0)
	if actor.velocity.length() > 0:
		new_speed /= actor.velocity.length()
	actor.velocity *= new_speed
	
	var state: String = "ground"
	
	if actor.velocity:
		state = "walk"
		
		if is_sprinting:
			state = "run"
			if is_crouched:
				state = "crouched_run"
		
		elif is_crouched:
			state = "crouched_walk"
		
		
	else:
		if is_crouched:
			state = "crouched"
	
	state_machine.switch_by_name(state)
	
func _handle_air_physics(delta: float) -> void:
	var state: String = _parse_state_crouch_sprint("air", "air_crouch", "air_sprint", "air_crouch_sprint")
	state_machine.switch_by_name(state)
	
	actor.velocity.y -= gravity * delta
	
	var cur_speed_in_wish_dir: float = actor.velocity.dot(wish_direction)
	var capped_speed: float = min((air_move_speed * wish_direction).length(), air_cap)
	
	var add_speed_til_cap: float = capped_speed - cur_speed_in_wish_dir
	if add_speed_til_cap > 0:
		var accel_speed: float = air_accel * air_move_speed * delta
		accel_speed = min(accel_speed, add_speed_til_cap)
		actor.velocity += accel_speed * wish_direction
	
func jump() -> void:
	actor.velocity.y = jump_force
	state_machine.switch_by_name("jump")

func _on_state_machine_state_enter(state: SD_State) -> void:
	if state.name == "jump":
		state_machine.switch_by_name("air")

func _parse_state_crouch_sprint(default: String, crouch: String, sprint: String, sprint_crouch: String) -> String:
	var state: String = default
	if is_crouched:
		state = crouch
	elif is_sprinting:
		state = sprint
	elif is_crouched and is_sprinting:
		state = sprint_crouch
	return state

func _parse_state_crouch_sprint_and_switch(default: String, crouch: String, sprint: String, sprint_crouch: String) -> String:
	var state: String = _parse_state_crouch_sprint(default, crouch, sprint, sprint_crouch)
	state_machine.switch_by_name(state)
	return state
