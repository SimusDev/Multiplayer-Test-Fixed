@tool
@icon("res://Games/source_game/components/icons/health.png")
extends Node
class_name W_EntityHealth

signal died()
signal health_changed()
signal max_health_changed()

@export var enabled: bool = true
@export var target: Node
@export var god_mode: bool = false
@export var health: float = 100.0 : set = set_health, get = get_health
@export var max_health: float = 100.0 : set = set_max_health, get = get_max_health

@export_group("Network")
@export var transfer_mode: MultiplayerPeer.TransferMode = MultiplayerPeer.TransferMode.TRANSFER_MODE_RELIABLE
@export var channel: StringName = "health"
@export var server_authorative: bool = true

var _last_health: float = 100.0

var _died: bool = false

func _ready() -> void:
	if not target:
		if owner:
			target = owner
		else:
			target = get_parent()
	
	if not Engine.is_editor_hint():
		SD_Network.register_channel(channel)
		
		SD_Network.register_rpc_authority(_recieve, transfer_mode, channel)
		SD_Network.register_rpc_any_peer(_send, transfer_mode, channel)
		SD_Network.register_rpc_authority(_recieve_health, transfer_mode, channel)
		SD_Network.register_rpc_authority(_recieve_max_health, transfer_mode, channel)
		
		if !target.is_node_ready():
			await target.ready
			
			if server_authorative:
				set_multiplayer_authority(SD_Network.SERVER_ID)
			
			if not SD_Network.is_server():
				SD_Network.call_rpc_on_server(_send)

func _send() -> void:
	SD_Network.call_func_on(multiplayer.get_remote_sender_id(), _recieve, [health, max_health])

func _recieve(_health: float, _max_health: float) -> void:
	health = _health
	max_health = _max_health

func get_last_health() -> int:
	return _last_health

func kill() -> void:
	set_health(0)

func set_health(points: float) -> void:
	if !Engine.is_editor_hint():
		if !SD_Network.is_authority(self):
			return
	
	if not enabled:
		return
	
	if points == health:
		return
	
	if points > 0:
		_died = false
	
	_last_health = health
	health = points
	health = clamp(health, 0.0, max_health)
	__on_health_changed_()
	

func set_max_health(points: float) -> void:
	if not enabled:
		return
	
	if max_health == points:
		return
	
	max_health = points
	
	if Engine.is_editor_hint():
		health = max_health
	
	max_health_changed.emit(max_health)
	
	__on_max_health_changed()

func apply_damage(points: float) -> void:
	if god_mode:
		return
	
	health -= points

func heal(points: float) -> void:
	health += points

func get_max_health() -> float:
	return max_health

func get_health() -> float:
	return health

func is_dead() -> bool:
	return _died

func is_alive() -> bool:
	return not _died

func __on_health_changed_() -> void:
	health_changed.emit()
	
	if health <= 0.0:
		if not _died:
			died.emit()
			_on_died()
			_died = true
	
	if Engine.is_editor_hint():
		return
	
	SD_Network.call_rpc(_recieve_health, [health])

func __on_max_health_changed() -> void:
	SD_Network.call_rpc(_recieve_max_health, [max_health])

func _recieve_health(points: float) -> void:
	health = points

func _recieve_max_health(points: float) -> void:
	max_health = points

func _on_died() -> void:
	pass

func get_parsed_string_value(value: int) -> String:
	return str(round(value))

func get_parsed_string_value_int(value: int) -> String:
	return str(int(round(value)))
