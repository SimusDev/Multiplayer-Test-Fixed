@tool
@icon("res://addons/simusdev/icons/MultiplayerSynchronizer.svg")
extends Node
class_name SD_NetworkTransform

@export var node: Node
#@export var synchronize_position: bool = true
#@export var synchronize_rotation: bool = true
#@export var synchronize_scale: bool = true
@export var interpolation: bool = true
@export var interpolation_strength: float = 20.0
@export var channel: StringName = "transform" : set = set_channel

func set_channel(new: StringName) -> void:
	if channel == new:
		return
	
	channel = new
	
	if !Engine.is_editor_hint():
		SD_Network.register_channel(new)

@export var tickrate: float = 32.0
@export var transfer_mode: MultiplayerPeer.TransferMode = MultiplayerPeer.TransferMode.TRANSFER_MODE_UNRELIABLE
@export var authority: AUTHORITY = AUTHORITY.LOCAL : set = set_authority
func set_authority(auth: AUTHORITY) -> void:
	authority = auth
	
	if authority == AUTHORITY.SERVER:
		set_multiplayer_authority(SD_Network.SERVER_ID, false)

@export var process: PROCESS = PROCESS.PHYSICS

var _tick: float = 0.0
var _tick_wait_time: float = 0.0
var _property_changes: Dictionary[StringName, Variant] = {}
var _recieved_changes: Dictionary[StringName, Variant] = {}

@export_group("Editor")
@export var _editor_initialize: bool = false

var _stream_buffer: StreamPeerBuffer = StreamPeerBuffer.new()

enum AUTHORITY {
	LOCAL,
	SERVER,
}

enum PROCESS {
	IDLE,
	PHYSICS,
	DISABLED,
}

var _last_position: Vector3 = Vector3.ZERO
var _last_rotation: Vector3 = Vector3.ZERO
var _last_scale: Vector3 = Vector3.ZERO

func _on_editor_initialize() -> void:
	pass

func _ready() -> void:
	if !node:
		if owner:
			node = owner
		else:
			node = get_parent()
	
	if not _editor_initialize:
		_editor_initialize = true
		_on_editor_initialize()
	
	if Engine.is_editor_hint():
		set_process(false)
		set_physics_process(false)
		return
	
	if not node:
		SD_Console.i().write_from_object(self, "node reference not found!", SD_ConsoleCategories.ERROR)
		return
	
	if !"transform" in node:
		SD_Console.i().write_from_object(self, "node transform not found!", SD_ConsoleCategories.ERROR)
		set_process(false)
		set_physics_process(false)
		return
	
	_stream_buffer.big_endian = true
	
	SD_Network.register_object(self)
	SD_Network.register_channel(channel)
	
	_tick_wait_time = 1.0 / tickrate
	
	if authority == AUTHORITY.SERVER:
		set_multiplayer_authority(SD_Network.SERVER_ID, false)
	
	SD_Network.register_rpc_authority(_recieve_position, transfer_mode, channel)
	SD_Network.register_rpc_authority(_recieve_rotation, transfer_mode, channel)
	SD_Network.register_rpc_authority(_recieve_scale, transfer_mode, channel)
	
	SD_Network.register_rpc_any_peer(_send_start, MultiplayerPeer.TRANSFER_MODE_RELIABLE, channel)
	SD_Network.register_rpc_any_peer(_recieve_start, MultiplayerPeer.TRANSFER_MODE_RELIABLE, channel)
	
	_last_position = _parse_last_vector(node.position)
	_last_rotation = _parse_last_vector(node.rotation)
	_last_scale = _parse_last_vector(node.scale)
	
	if not SD_Network.is_server():
		SD_Network.call_rpc_on_server(_send_start)
	

func _parse_last_vector(from: Variant) -> Vector3:
	if from is Vector3:
		return from
	return Vector3(from.x, from.y, 0.0)

func _send_start() -> void:
	if SD_Network.is_server():
		SD_Network.call_rpc_on(multiplayer.get_remote_sender_id(), _recieve_start, [node.position, _encode_rotation(node.rotation_degrees), node.scale])

func _recieve_start(position: Variant, rotation: PackedByteArray, scale: Variant) -> void:
	node.position = position
	node.rotation_degrees = _decode_rotation(rotation)
	node.scale = scale
	

func _process(delta: float) -> void:
	if !SD_Network.is_authority(self):
		_interpolate(delta)
		return
	
	if process == PROCESS.IDLE:
		_check_transform(delta)

func _interpolate(delta: float) -> void:
	node.position = lerp(node.position, _last_position, interpolation_strength * delta)
	node.scale = lerp(node.scale, _last_scale, interpolation_strength * delta)
	
	node.rotation.x = lerp_angle(deg_to_rad(node.rotation_degrees.x), deg_to_rad(_last_rotation.x), interpolation_strength * delta)
	node.rotation.y = lerp_angle(deg_to_rad(node.rotation_degrees.y), deg_to_rad(_last_rotation.y), interpolation_strength * delta)
	node.rotation.z = lerp_angle(deg_to_rad(node.rotation_degrees.z), deg_to_rad(_last_rotation.z), interpolation_strength * delta)

func _physics_process(delta: float) -> void:
	if !SD_Network.is_authority(self):
		return
	
	if process == PROCESS.PHYSICS:
		_check_transform(delta)

func _check_transform(delta: float) -> void:
	_tick_wait_time = 1.0 / tickrate
	_tick = move_toward(_tick, _tick_wait_time, delta)
	
	if _tick >= _tick_wait_time:
		_tick = 0.0
		
		_check_transform_node(node)
		

func _check_transform_node(target: Node) -> void:
	var position: Vector3 = _parse_last_vector(target.position)
	var rotation: Vector3 = _parse_last_vector(target.rotation_degrees)
	var scale: Vector3 = _parse_last_vector(target.scale)
	
	if position != _last_position:
		_last_position = position
		SD_Network.call_rpc_except_self(_recieve_position, [position])
	
	if rotation != _last_rotation:
		_last_rotation = rotation
		SD_Network.call_rpc_except_self(_recieve_rotation, [_encode_rotation(rotation)])
	
	if scale != _last_scale:
		_last_scale = scale
		SD_Network.call_rpc_except_self(_recieve_scale, [scale])

func _encode_rotation(rotation: Vector3) -> PackedByteArray:
	var bytes := PackedByteArray()
	bytes.resize(6)
	bytes.encode_half(0, rotation.x)
	bytes.encode_half(2, rotation.y)
	bytes.encode_half(4, rotation.z)
	return bytes

func _decode_rotation(bytes: PackedByteArray) -> Vector3:
	return Vector3(bytes.decode_half(0), bytes.decode_half(2), bytes.decode_half(4))

func _recieve_position(value: Variant) -> void:
	if !interpolation:
		node.position = value
	_last_position = value

func _recieve_rotation(value: PackedByteArray) -> void:
	var rot: Vector3 = _decode_rotation(value)
	if !interpolation:
		node.rotation_degrees = rot
	_last_rotation = rot

func _recieve_scale(value: Variant) -> void:
	if !interpolation:
		node.scale = value
	_last_scale = value
