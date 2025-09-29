@icon("res://Games/source_game/components/vehicle/seat.png")
extends RigidBody3D
class_name SourceSeat

var _target: Node3D

var _remote_transform: RemoteTransform3D

@export var custom_point: Node3D

@export var _input: SourceEntityInput

func _create_inputs() -> void:
	_input = SourceEntityInput.new()
	_input.name = "seat_input"
	_input.set_multiplayer_authority(_target.get_multiplayer_authority())
	_input.allowed_actions.append("jump")
	_target.add_child(_input)
	_input.action_just_pressed.connect(_input_on_action_just_pressed)

func _input_on_action_just_pressed(action: StringName) -> void:
	if _target:
		set_target(null)

func _delete_inputs() -> void:
	if is_instance_valid(_input):
		_input.queue_free()
		_input = null

func _ready() -> void:
	SD_Network.register_object(self)
	SD_Network.register_functions([
		_send,
		_recieve,
		_set_target_net,
	])
	
	_remote_transform = RemoteTransform3D.new()
	_remote_transform.update_rotation = false
	if custom_point:
		custom_point.add_child(_remote_transform)
	else:
		add_child(_remote_transform)
	
	if SD_Network.is_server():
		set_target(_target)
	else:
		SD_Network.call_func_on_server(_send)

func _send() -> void:
	SD_Network.call_func_on(SD_Network.get_remote_sender_id(), _recieve, [_target])

func _recieve(new_target: Node3D) -> void:
	set_target(new_target)

func get_target() -> Node3D:
	return _target

func set_target(new: Node3D) -> void:
	SD_Network.call_func(_set_target_net, [new])

func _set_target_net(new: Node3D) -> void:
	if get_target():
		_target_exit()
	
	_remote_transform.remote_path = NodePath()
	
	if not is_instance_valid(new):
		return
	
	_target = new
	_remote_transform.remote_path = _remote_transform.get_path_to(new)
	
	if get_target():
		_target_enter()

var _data: Dictionary[String, Variant] = {}

func _target_enter() -> void:
	_create_inputs()
	
	if _target is CollisionObject3D:
		_data.layer = _target.collision_layer
		_data.mask = _target.collision_mask
		_target.collision_layer = 0
		_target.collision_mask = 0
	
	if _target is PhysicsBody3D:
		_target.axis_lock_linear_x = true
		_target.axis_lock_linear_y = true
		_target.axis_lock_linear_z = true

func _target_exit() -> void:
	_delete_inputs()
	
	if _target is CollisionObject3D:
		_target.collision_layer = _data.layer
		_target.collision_mask = _data.mask
	
	if _target is PhysicsBody3D:
		_target.axis_lock_linear_x = false
		_target.axis_lock_linear_y = false
		_target.axis_lock_linear_z = false

func _source_interacted(ray: SourceInteractRay) -> void:
	if ray.root == _target:
		set_target(null)
	else:
		if ray.root is Node3D:
			set_target(ray.root)
